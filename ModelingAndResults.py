# -*- coding: utf-8 -*-
"""
Created on Sun Mar 14 18:40:01 2021

@author: Thomas Pandolfi

If you try running this script on your machine, it will not work
Some parts might, but many areas requires specific CSV sheets, the downloaded MIMIC data, results files, etc...
As well as requiring a number of nonstandard libraries to be downloaded. 
Many areas of the code were written with no specific structure idealized for the final iteration, so at points its a bit hard to understand
additionally, code is extremely repetitive in some areas because what we wanted originally changed over time
This is evident in the results section (complete bottom)

This script includes a few things

One: Reading one example of a PPG waveform from the MIMIC database to quantify the potential peak detection error in absolute time
We did this to determine whether sampling our video at 30 fps or 60 fps was a potential problem compared to a higher sampling frequency

Two: Preforming Lin, lasso, symbolic regression on the predictor variables included in the Guilin People's database (Guilin, China)'

Three: Extracting clinical information from the downloaded clinical database - MIMIC
    This is the lengthiest section for obvious reasons
    The database is jagged, as any database with this much information will be
    Separate sections were created for age, weight, height etc.
    Sections were needed for reading the major chartevents file, as well as saving it and modifying it after the fact
    interested_rows() is a one time ran function for example
    
Four: Extracting waveform information from the downloaded waveform data - MIMIC
    A few functions are created to get the patients names that are relevant
    A major looping script goes through each file
    One master function for the waveform database allows significant input output to get the best points for PTT calculation for each patient

Five: Final results section from the PTT and blood pressure within our group
    Mostly plotting stuff, extremely redundant code because we kept adding new stuff before I could make it modular 
    Can easily be reduced in size in the future to about 1/4 of the original size
    
Above all, there are significant portions of this code that can be rewritten, many are not optimized correctly

Contact information for questions (if someone reads this! :) )
pandolfi.t@northeastern.edu
"""

#Useful libraries in Python
import pandas as pd 
from datetime import datetime
import numpy as np 
from sklearn.linear_model import LinearRegression
import sklearn
import matplotlib
matplotlib.use("qt5agg")
from matplotlib import pyplot as plt
from gplearn.genetic import SymbolicRegressor
import graphviz
from scipy.signal import butter, lfilter
from scipy.signal import find_peaks
from matplotlib.patches import ConnectionPatch
import os
import wfdb
import time
base_file = "D:\\users\\tpand\\desktop\\database\\"

#butter filters for PPG signals
def butter_bandpass(lowcut, highcut, fs, order=5):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = butter(order, [low, high], btype='band')
    return b, a


def butter_bandpass_filter(data, lowcut, highcut, fs, order=5):
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = lfilter(b, a, data)
    return y
#%%
'''
This section is for the peak detection with the downsampled waveforms
We are trying to determine if downsampling the waveforms significantly effects the time that peaks are detected at
Results: Not too much
'''
#This whole section is patient specific. Data was plotted and modified accordingly. (removing an erroneous peak, picking good sections for error analysis)
PPG1 = pd.read_csv('C:\\Users\\tpand\\desktop\\spring2021\\Capstone\\BI\\bidmc_csv\\bidmc_01_signals.csv')
plt.figure('PPG and Fitler')
plt.subplot(2,1,1)
filteredPPG = butter_bandpass_filter(PPG1[' PLETH'], 0.6, 15, 125) #bandpass filter
plt.plot(np.array(range(0, len(filteredPPG))) /125, filteredPPG, c = 'black')
#plot peaks on the top graph
peakx = find_peaks(filteredPPG, width = 0, prominence = 0.02, height = np.mean(filteredPPG))[0]
peakx = np.delete(peakx, 147)
peaky = [filteredPPG[i] for i in peakx]
plt.subplot(2,1,1)
plt.scatter(peakx / 125, peaky, c=[0.8,0.1,0])
plt.title('Subject 001 - 125 Hz')
plt.xlim([8, 32])
plt.ylabel('Amplitude (mV)')
plt.xlabel('Time (s)')


#downsampling simply take sample every 5 instead of every 1, should be about 30 hz
downsamp = [filteredPPG[i] for i in range(0, len(filteredPPG), 5)]
peakx_25hz = find_peaks(downsamp, width = 0, prominence = 0.02, height = np.mean(filteredPPG))[0]
peaky_25hz = [downsamp[i] for i in peakx_25hz]
plt.subplot(2,1,2)
plt.plot(np.array(range(0, len(downsamp))) /25, downsamp, c = 'black')
plt.scatter(peakx_25hz / 25, peaky_25hz, c=[0.1,0.8,0])
plt.title('Subject 001 - 25 Hz')
plt.xlim([1000/5, 4000 / 5])
plt.xlim([8, 32])
plt.ylabel('Amplitude (mV)')
plt.xlabel('Time (s)')
matplotlib.rcParams.update({'font.size': 10})
plt.tight_layout()

#histogram  - these modifications are patient specific, we took the best part of the signal to do the analysis on, naturally
hh = peakx[0:130]  - (5 * peakx_25hz[0:130])
px = np.concatenate((peakx[0:130], peakx[200:600]))
px25 = np.concatenate((peakx_25hz[0:130], peakx_25hz[200: 600]))
upd = px - (5 * px25)

#creating a dictionary of the number of peak times that are off by a specific amount
asd = dict()
for x in upd:
    if x not in asd:
        asd[x] = 1
    else:
        asd[x] += 1
print(asd)

#keys and values of the dictionary
vals = list(asd.values())
key = list(asd.keys())
#plot results
plt.figure('hist of errors')
plt.subplot(2,1,1)
plt.bar(key, height = vals, color = 'red')
plt.title('Histogram of errors of peak time differences')
plt.xlabel('Samp difference (1/125 s)')
plt.ylabel('# of samples')
matplotlib.rcParams.update({'font.size': 10})

plt.subplot(2,1,2)
plt.bar((np.array(key) * (1000/125)), height = 1000 * np.array(vals) / 125, color = 'blue')

plt.title('Histogram of errors of peak time differences')
plt.xlabel('Peak difference (ms)')
plt.ylabel('# of samples')

plt.tight_layout()
#%%  
'''

Guilin Database

'''
#Lets get a bit of Age, weight, and other impornt data, along with the systolic and diastolic BP

Metrics = pd.read_excel("C:\\users\\tpand\\Desktop\\spring2021\\capstone\\Database\\Data\\Metrics.xlsx")
#Lets Redefine the male and female matrix, lets set females as 0s and males as 1s
#Essentially what this means is that the baseline model will assume a female, having a male will introduce a bias
Sex = [int(i) for i in (Metrics['Sex(M/F)'] == 'Male')]
Metrics['Sex(M/F)'] = pd.DataFrame(Sex)
Features = ['Sex(M/F)', 'Age', 'Height', 'Weight', 'HR'] #Feature dataset
bpn = ['SBP', 'DBP'] #what metrics we are predicting
Test = Metrics.loc[Metrics['Num.'] > round(len(Metrics['Num.']) * (8/10))] #use the last 80 for testing
Train = Metrics.loc[Metrics['Num.'] < round(len(Metrics['Num.']) * (8/10))] #first 20 for training


#%%

#Training
SBP_reg = LinearRegression() #Create linear regression model
SBP_reg.fit(Train[Features], Train[bpn[0]])
S_LinC = SBP_reg.coef_ #coefficients
S_LinI = SBP_reg.intercept_ #intercept
estimation_slin = (Test[Features] * S_LinC).sum(axis = 1) + S_LinI #coefficients for features considered multiplied by the features and summed in the linear regression model
SLin_MSE = sklearn.metrics.mean_squared_error(estimation_slin, Test[bpn[0]]) #mean squared error
plt.figure('Sys Linear Estimation vs Truth') #plot estimated vs actual
plt.subplot(1,2,1)
plt.scatter(estimation_slin, Test[bpn[0]], c= 'r')
plt.xlabel('SBP Actual (mmHg)')
plt.ylabel('SBP Estimated (mmHg)')
plt.title('SBP -Linear (Biomarkers)')
#matplotlib.rcParams.update({'font.size': 14})
esti_line = np.array((range(70, 180))) #this is for the validation bands
plt.plot(esti_line, esti_line + 10, c= [0.2, 0.2, 0.2])
plt.plot(esti_line, esti_line - 10,c= [0.2, 0.2, 0.2])
plt.fill_between(esti_line, esti_line + 10, esti_line - 10, color = [0.7, 0, 0], alpha = 0.2)
plt.ylim([80,160])
plt.xlim([80, 180])

DBP_reg = LinearRegression() #Create linear regression model
DBP_reg.fit(Train[Features], Train[bpn[1]])
D_LinC = DBP_reg.coef_ #coefficients
D_LinI = DBP_reg.intercept_ #intercept
estimation_dlin = (Test[Features] * D_LinC).sum(axis = 1) + D_LinI #coefficients for features considered multiplied by the features and summed in the linear regression model
DLin_MSE = sklearn.metrics.mean_squared_error(estimation_dlin, Test[bpn[1]]) #mean squared error
plt.subplot(1,2,2) #plot estimated vs actual
plt.scatter(estimation_dlin, Test[bpn[1]], c= 'b')
plt.xlabel('DBP Actual (mmHg)')
plt.ylabel('DBP Estimated (mmHg)')
plt.title('DBP -Linear (Biomarkers)')
#matplotlib.rcParams.update({'font.size': 14})
esti_line = np.array((range(50, 180)))
plt.plot(esti_line, esti_line + 10, c= [0.2, 0.2, 0.2])
plt.plot(esti_line, esti_line - 10,c= [0.2, 0.2, 0.2])
plt.fill_between(esti_line, esti_line + 10, esti_line - 10, color = [0.0, 0, 0.7], alpha = 0.2)
plt.ylim([50,100])
plt.xlim([50, 100]) 
matplotlib.rcParams.update({'font.size': 11})
plt.tight_layout()
#Coefs can be obtained with reg.coef_ , intercepts with reg.intercept_

#%%Lasso regression With training on first 80%, test with last 20%

SBP_lasso = sklearn.linear_model.Lasso(alpha = 4) #systolic lasso and fit
SBP_lasso.fit(Train[Features], Train[bpn[0]])
SLC = SBP_lasso.coef_
SLI = SBP_lasso.intercept_
estimation_sl = (Test[Features] * SLC).sum(axis = 1) + SLI #coefficients for features considered multiplied by the features and summed in the linear regression model
SL_MSE = sklearn.metrics.mean_squared_error(estimation_sl, Test[bpn[0]]) #mean squared error
plt.figure(666) #plot estimated vs actual
plt.subplot(1,2,1)
plt.scatter(Test[bpn[0]], estimation_sl, c= 'r', s=20)
plt.xlabel('SBP Actual (mmHg)')
plt.ylabel('SBP Estimated (mmHg)')
plt.title('SBP -Lasso (Biomarkers)')
#matplotlib.rcParams.update({'font.size': 14})
esti_line = np.array((range(70, 180)))
plt.plot(esti_line, esti_line + 10, c= [0.2, 0.2, 0.2])
plt.plot(esti_line, esti_line - 10,c= [0.2, 0.2, 0.2])
plt.fill_between(esti_line, esti_line + 10, esti_line - 10, color = [0.7, 0, 0], alpha = 0.2)
plt.ylim([80,160])
plt.xlim([80, 180])

#Do the same with diastolic (lasso regression)
DBP_lasso = sklearn.linear_model.Lasso(alpha = 4) #Diastolic Lasso and Fit
DBP_lasso.fit(Train[Features], Train[bpn[1]])
DLC = DBP_lasso.coef_
DLI = DBP_lasso.intercept_
estimation_dl = (Test[Features] * DLC).sum(axis = 1) + DLI
DL_MSE = sklearn.metrics.mean_squared_error(estimation_dl, Test[bpn[1]]) #mean squared error
plt.figure(666)
plt.subplot(1,2,2)
plt.scatter(Test[bpn[1]], estimation_dl, c= 'b', s=20)
plt.xlabel('DBP Actual (mmHg)')
plt.ylabel('DBP Estimated (mmHg)')
plt.title('DBP - Lasso (Biomarkers)')
esti_line = np.array((range(50, 100)))
plt.plot(esti_line, esti_line + 10, c= [0.2, 0.2, 0.2])
plt.plot(esti_line, esti_line - 10,c= [0.2, 0.2, 0.2])
plt.fill_between(esti_line, esti_line + 10, esti_line - 10, color = [0.0, 0, 0.7], alpha = 0.2)
plt.xlim([50,100])
matplotlib.rcParams.update({'font.size': 10})
plt.tight_layout()

#%%
#Symbolic Regression
#lets use different feature dataset
FeaturesSym = ['Age', 'Weight', 'HR']
#FeaturesSym = ['AGE', 'HEIGHTS', 'WEIGHT', 'INVPTT']
function_set = ['add', 'sub', 'mul', 'div','sqrt', 'log', 'abs', 'max', 'min'] #functions allowed
SBP_sym = SymbolicRegressor(feature_names = FeaturesSym, function_set = function_set)
SBP_sym.fit(Train[FeaturesSym], Train['SBP'])
qweS = SBP_sym.predict(Test[FeaturesSym]) #predict the bp of the test points
SYMSBP_MSE = sklearn.metrics.mean_squared_error(qweS, Test[bpn[0]]) #mse
print(SYMSBP_MSE)
dot_data = SBP_sym._program.export_graphviz()
graphS = graphviz.Source(dot_data) #plot the graph function

#do the same for diastolic
DBP_sym = SymbolicRegressor(feature_names = FeaturesSym, function_set = function_set)
DBP_sym.fit(Train[FeaturesSym], Train['DBP'])
qweD = DBP_sym.predict(Test[FeaturesSym])
SYMDBP_MSE = sklearn.metrics.mean_squared_error(qweD, Test[bpn[1]])
dot_data = DBP_sym._program.export_graphviz()
graphD = graphviz.Source(dot_data)

plt.figure(1)
plt.subplot(1,2,1)
plt.scatter(Test[bpn[0]], qweS, c= 'r', s=20)
esti_line = np.array((range(70, 180)))
plt.plot(esti_line, esti_line + 10, c= [0.2, 0.2, 0.2])
plt.plot(esti_line, esti_line - 10,c= [0.2, 0.2, 0.2])
plt.fill_between(esti_line, esti_line + 10, esti_line - 10, color = [0.7, 0, 0.0], alpha = 0.2)
plt.xlabel('SBP Actual (mmHg)')
plt.ylabel('SBP Estimated (mmHg)')
plt.title('SBP - Symbolic (Biomarkers only)')

plt.subplot(1,2,2)
plt.scatter(Test[bpn[1]], qweD, c= 'b', s=20)
esti_line = np.array((range(50, 100)))
plt.plot(esti_line, esti_line + 10, c= [0.2, 0.2, 0.2])
plt.plot(esti_line, esti_line - 10,c= [0.2, 0.2, 0.2])
plt.fill_between(esti_line, esti_line + 10, esti_line - 10, color = [0.0, 0, 0.7], alpha = 0.2)
plt.xlabel('DBP Actual (mmHg)')
plt.ylabel('DBP Estimated (mmHg)')
plt.title('DBP - Symbolic (Biomarkers only)')


#%% Opening a new file from the MIMIC3 Dataset
'''

MIMIC 3 database - 

'''
#lets start with reading the csv sheet for each section

#%%forpatients (contains DOB, SEX, ID number)
PATIENTS = pd.read_csv("D:\\users\\tpand\\desktop\\database\\clinical\\PATIENTS.csv", usecols = ['SUBJECT_ID', 'GENDER', 'DOB'])
BIRTH_YEAR = np.array([int(i[0:4]) for i in PATIENTS.DOB])
PATIENTS = pd.concat([PATIENTS, pd.Series(BIRTH_YEAR, name = 'CY')],axis = 1)
PATIENTS.index = PATIENTS.iloc[:,3]

#%% For admissions (contains admission date, needed for age calculations)
ADMISSIONS = pd.read_csv("D:\\users\\tpand\\desktop\\database\\clinical\\ADMISSIONS.csv", usecols = ['SUBJECT_ID', 'ADMITTIME'])
ADMIT_TIME = np.array([int(i[0:4]) for i in ADMISSIONS.ADMITTIME])
ADMISSIONS = pd.concat([ADMISSIONS, pd.Series(ADMIT_TIME, name = 'CY')], axis = 1)

#%%Create an age dictionary
Age = dict()

for pt in PATIENTS.SUBJECT_ID:
    #if patient subject number is already in the dictionary
    #just check to see if the age can be lower and replace if it is
    #is it in both?
    if pt in ADMISSIONS.SUBJECT_ID.values:
        cand = ADMISSIONS[ADMISSIONS.SUBJECT_ID == pt]
        yearADMIN = int(cand.CY.min()) #we want first admission information
            
        cand = PATIENTS[PATIENTS.SUBJECT_ID == pt]
        yearBIRTH = int(cand.CY)
            
        Age[pt] = yearADMIN - yearBIRTH
                 
ser = np.array([])
for pt in PATIENTS.SUBJECT_ID:
    ser = np.append(ser, Age[pt])
PATIENTS = pd.concat([PATIENTS, pd.Series(ser, name = 'AGE', index = PATIENTS.index)], axis = 1)#ignore_index = True)


#%% weights section
w = dict()
weights = pd.read_csv('D:\\users\\tpand\\Desktop\\database\\weights.csv')
'''
all the ids in these sections have been handpicked from the itemid list in an arduous process
essentiall it is unclear which 'weight' measurmeents are true measurements of the patients weight
same goes for height, pressures, etc..., as they are all labeled with a slightly different label and 
many mean a slightly different thing
'''
weights_removed_ids = weights[(weights['ITEMID']== 226512) | (weights['ITEMID'] == 224639) | (weights['ITEMID'] == 763) | (weights['ITEMID'] == 580)]
w_thresh = 40 #40 kg threshold
weights_removed_ids = weights_removed_ids.loc[weights_removed_ids.VALUENUM > w_thresh]
for pt in set(weights.SUBJECT_ID):
    
    print(pt)
    curr_frame = weights_removed_ids[weights_removed_ids.SUBJECT_ID == pt]
    
    #go through the most useful weight measurements
    ids = curr_frame.iloc[:,1].values
   
    if 226512 in ids:
        w[pt] = np.mean((curr_frame.loc[curr_frame['ITEMID'] == 226512, 'VALUENUM']))
    elif 224639 in ids:
        w[pt] = np.mean((curr_frame.loc[curr_frame['ITEMID'] == 224639, 'VALUENUM']))
    elif 763 in ids:
        w[pt] = np.mean((curr_frame.loc[curr_frame['ITEMID'] == 763, 'VALUENUM']))
    elif 580 in ids:
        w[pt] = np.mean((curr_frame.loc[curr_frame['ITEMID'] == 580, 'VALUENUM']))
    else:
        w[pt] = 0
  
temp = np.array([])
for pt in PATIENTS.SUBJECT_ID:
    if pt in w:
        temp = np.append(temp, w[pt])
    else:
        temp = np.append(temp, 0)
PATIENTS = pd.concat([PATIENTS, pd.Series(temp, name = 'WEIGHT', index = PATIENTS.index)], axis = 1)



#%% Heights section
h = dict()
heights = pd.read_csv('D:\\users\\tpand\\desktop\\database\\heights.csv')
heights = heights.loc[heights.ITEMID == 226730]
for pt in heights.SUBJECT_ID:
    curr_height = np.mean(heights.loc[heights['SUBJECT_ID'] == pt, 'VALUENUM'])
    h[pt] = curr_height

temp = np.array([])
for pt in PATIENTS.SUBJECT_ID:
    if pt in h:
        temp = np.append(temp, h[pt])
    else:
        temp = np.append(temp, 0)
PATIENTS = pd.concat([PATIENTS, pd.Series(temp, name = 'HEIGHTS', index = PATIENTS.index)], axis = 1)


#%% Pressures section
pss = dict()
pdd = dict()
pressures = pd.read_csv('D:\\users\\tpand\\desktop\\database\\pressures.csv', usecols = ['SUBJECT_ID', 'ITEMID', 'VALUENUM'])
sys_removed = pressures.loc[(pressures['ITEMID'] == 220179) | (pressures['ITEMID'] == 51) | (pressures['ITEMID'] == 220050)]
dia_removed = pressures.loc[(pressures['ITEMID'] == 220180) | (pressures['ITEMID'] == 8368) | (pressures['ITEMID'] == 220051)]
for pt in set(pressures.SUBJECT_ID):
     
     print(pt)
     curr_sys= sys_removed[sys_removed.SUBJECT_ID == pt]
     curr_dia = dia_removed[dia_removed.SUBJECT_ID == pt]
     
     ids = set(curr_sys.iloc[:,1].values)
     idd = set(curr_dia.iloc[:,1].values)
     
     if 220179 in ids:
        pss[pt] = np.mean((curr_sys.loc[curr_sys['ITEMID'] == 220179, 'VALUENUM']))
        if 220180 in idd:
            pdd[pt] = np.mean((curr_dia.loc[curr_dia['ITEMID'] == 220180, 'VALUENUM']))
        else:
            pdd[pt] = 0
     elif 220050 in ids:
        pss[pt] = np.mean((curr_sys.loc[curr_sys['ITEMID'] == 220050, 'VALUENUM']))
        if 220051 in idd:
            
            pdd[pt] = np.mean((curr_dia.loc[curr_dia['ITEMID'] == 220051, 'VALUENUM']))
        else:
            pdd[pt] = 0
     
     elif 51 in ids:
         pss[pt] = np.mean((curr_sys.loc[curr_sys['ITEMID'] == 51, 'VALUENUM']))
         if 8368 in idd:
             pdd[pt] = np.mean((curr_dia.loc[curr_dia['ITEMID'] == 8368, 'VALUENUM']))
         else:
             pdd[pt] = 0
     else:
         pss[pt] = 0
         pdd[pt] = 0

s_temp = np.array([])
d_temp = []
for pt in PATIENTS.SUBJECT_ID:
    if pt in pss:
        s_temp = np.append(s_temp, pss[pt])
    else:
        s_temp = np.append(s_temp, 0)
    
    if pt in pdd:
        d_temp = np.append(d_temp, pdd[pt])
    else:
        d_temp = np.append(d_temp, 0)
        
PATIENTS = pd.concat([PATIENTS, pd.Series(s_temp, name = 'SYSTOLIC', index = PATIENTS.index)], axis = 1)
PATIENTS = pd.concat([PATIENTS, pd.Series(d_temp, name = 'DIASTOLIC', index = PATIENTS.index)], axis = 1)
        

#%% Datafrrame modifications
'''
#only want patients above age of 12, some patients named age == 300
#weights = 0
#heights = 0
#also if sys is > diastolic

There are number of patients to take out, for example all under the age of 12
All patients for which their weight is too low (less than 40 implies either very young or incorrectly labeled)
Patients with a non-possible height
If the systolic is greater than the diastolc (impossible)

As well as changing all patients whose age is listed as 300 (remember this means greater than 89 due to HIPPA)

'''
#best = PATIENTS.loc[(PATIENTS['HEIGHTS'] > 50) and (PATIENTS['WEIGHTS'] > 40) and (PATIENTS['AGE'] > 12) and (PATIENTS['SYSTOLIC'] > 40) and (PATIENTS['DIASTOLIC'] > 20)] 
PATIENTS.loc[PATIENTS['SYSTOLIC'] < PATIENTS['DIASTOLIC'], 'SYSTOLIC'] = 0
PATIENTS.loc[PATIENTS['SYSTOLIC'] < PATIENTS['DIASTOLIC'], 'DIASTOLIC'] = 0
PATIENTS.loc[PATIENTS['AGE'] == 300, 'AGE'] = 90

#Files are seperated here by name just in case i wanted to do something additional to C for example, before moving to D.
#this can all be done in one line
A = PATIENTS.loc[PATIENTS['HEIGHTS'] > 50]
B = A.loc[A['WEIGHT'] > 40]
C = B.loc[B['AGE'] > 12]
D = C.loc[C['SYSTOLIC'] > 40]
E = D.loc[D['DIASTOLIC'] > 20]
E.to_csv('D:\\users\\tpand\\desktop\\database\\YAY.csv')
#%% Chartevents (contains all other information) - too big to read, function interested rows does the heavy lifting
'''
This is the master function for creating the clinical extracted information for each patient
Creates dataframes for the stuff we are interested in, and then segments the total  330 million row file by chunks
For each chunk it reads the values that have the interested units
At the end it saves everything to a CSV file.
Lots of potential improvements to be made here, simply needed a solution that worked at the time
'''
def interested_rows(chunksize):
    iterator = 0
    weights = pd.DataFrame()
    heights = pd.DataFrame()
    pressures = pd.DataFrame()
    direc = 'D:\\users\\tpand\\desktop\\database\\clinical\\CHARTEVENTS.csv'
    
    
    c = ['ROW_ID', 'SUBJECT_ID', 'HADM_ID', 'ICUSTAY_ID', 'ITEMID', 'CHARTTIME',
       'STORETIME', 'CGID', 'VALUE', 'VALUENUM', 'VALUEUOM', 'WARNING',
       'ERROR', 'RESULTSTATUS', 'STOPPED']
    
    while 1:
        
        try:
            current = pd.read_csv(direc, index_col = False, names = c, usecols = ['SUBJECT_ID', 'ITEMID', 'VALUENUM', 'VALUEUOM'], nrows = chunksize, skiprows = (iterator * chunksize) + 1)
             #grabs the current chunk
            curr_weights = current[current.VALUEUOM == 'kg'] #gets current weights in the chunk
            curr_heights = current[current.VALUEUOM == 'cm']
            curr_pressures = current[current.VALUEUOM == 'mmHg'] #gets current pressures in the chunk
            weights = weights.append(curr_weights) #adds the current weights in the chunk to the dataframe
            heights = heights.append(curr_heights)
            pressures = pressures.append(curr_pressures)
            
            iterator += 1
        except:
            print('END')
            weights.to_csv('D:\\users\\tpand\\desktop\\database\\weights.csv', index = False)
            heights.to_csv('D:\\users\\tpand\\desktop\\database\\heights.csv', index = False)
            pressures.to_csv('D:\\users\\tpand\\desktop\\database\\pressures.csv', index = False)
            return(1) #if there is an error, we reached the end of the dataframe, return the results
        
        print(iterator*chunksize)

#%% this is just for determining relevant itemids from a csv file
def names_ids():
    directory = 'D:\\users\\tpand\\desktop\\database\\'
    ITEMS = pd.read_csv('D:\\users\\tpand\\desktop\\database\\clinical\\D_ITEMS.csv')
    filename = input('File name: ')
    curr = pd.read_csv(directory + filename)
    pre = set(curr.ITEMID)
    
    for x in pre:
        print(x, ITEMS.loc[ITEMS.ITEMID == x, 'LABEL'].values)
        input()
    return()    

#%%read a SINGLE dat measurements, fn is without dat or hea appendage, should be biggets dat file from recordings
    '''
    this is the master function for reading through the patients waveforms
    Firstly, we check if the data has the waveforms we are intrested in (ECG, PPG)
    
    Then the Data is filtered and the user is asked to specific a portion of the data to view
    Then the user confirms if this is a good section
        if its not, the user can repeat the past input and change a section
    user is asked if they want to flip the signals (sometimes ECG is flipped)
    Peaks detected and the section of the data chosen is redisplayed.
    If this looks good (user types 1) (equal number of peak for ecg and ppg)
        continue
    if it doesnt, user can sel;ect a smaller section of the data (typing in 2)
        it will remove a ppg peak if it is first as PTT is ECG --> PPG, not the other way
    Alternatively and most importantly, if there is a peak after the ECG that is too close and would not possibly be the 
        corresponding peak for the PTT calculation, the user can put in a 5 to let the program figure this out for itself.
        
    
    This section has a lot of input output, and therefore some modifications to the code had to be made
        this includes operating system pauses, which allows the plots to be drawn before moving on in the code
        as well as areas for the user to move on to the next signal if need be (type 99 or some random set of letters to move on / cancel the loop, respectively)
    '''
def read_dat(pt_name, ptt_dict, fn):
    print(pt_name)
    sig, fields = wfdb.rdsamp(fn)
    sig = np.nan_to_num(sig)
    signals_avil = fields['sig_name']
    print(fields)
    
    #we need both pleth and at least one lead to be in the measurement
    if ('V' not in signals_avil) and ('III' not in signals_avil) and ('II' not in signals_avil):
        return(ptt_dict)
    
    if 'PLETH' not in signals_avil:
        return(ptt_dict)
    
    df = pd.DataFrame(sig, columns = signals_avil)
     #wfdb.rdsamp('3003025_0001', pn_dir = 'mimic3wdb-matched/p04/p040013')
    #first argument is the file name, second is the general directory
    
    filteredPPG = butter_bandpass_filter(df['PLETH'], 0.3, 8, fields['fs']) 
    
    
    if 'V' in signals_avil:
        filteredECG = butter_bandpass_filter(df['V'], 0.5, 40, fields['fs'])
    elif 'II' in signals_avil:
        filteredECG = butter_bandpass_filter(df['II'], 0.5, 40, fields['fs'])
    os.system("pause")
    contin = 0
    while contin == 0:
        
        good_range_beg = int(input('Beginning to measure :'))
        
        if good_range_beg == 99:
            return(ptt_dict)
        good_range_end = int(input('Ending to measure :'))
        plt.figure(1)
        plt.plot(filteredECG[good_range_beg : good_range_end], color = 'black')
        plt.pause(1)
        plt.plot(filteredPPG[good_range_beg : good_range_end], color = 'red')
        plt.title('Signals from Patient :' + str(pt_name))
        plt.xlabel('Sample number (1/125 s)')
        plt.ylabel('Voltage (mV)')
        plt.legend({'ECG', 'PPG'})
        plt.pause(2)
        contin = int(input('Is this good to move on to peak finding :')) #if 1, we continue
        if contin == 99:
            return(ptt_dict)
        plt.close()
        
    filteredECG = filteredECG[good_range_beg: good_range_end]    
    filteredPPG= filteredPPG[good_range_beg: good_range_end]
    
    
    plt.figure()
    plt.plot(filteredECG)
   
    plt.pause(2)
    os.system("pause")
    flip = int(input('Should the ECG be flipped: '))
    if flip == 1:
        filteredECG = filteredECG * -1
    flip = int(input('Should the PPG be Flipped: '))
    if flip == 1:
        filteredPPG = filteredPPG * -1
    plt.close()
    peakx_PPG = find_peaks(filteredPPG, width = 0, prominence = 0.1, height = np.mean(filteredPPG))[0]
    peakx_ECG = find_peaks(filteredECG, width = 0, prominence = 0.4, height = np.mean(filteredECG))[0]
    
    try:
        
        if peakx_PPG[0] < peakx_ECG[0]:
            peakx_PPG = peakx_PPG[1:]
        if len(peakx_PPG) < len(peakx_ECG):
            peakx_ECG = peakx_ECG[:-1]
            
    except:
        plt.close()
        #return(ptt_dict)
    peaky_ECG = [filteredECG[i] for i in peakx_ECG]
    peaky_PPG = [filteredPPG[i] for i in peakx_PPG]   
    
    
    #filteredPPG = (filteredPPG - min(filteredPPG)) / max(filteredPPG)
    xaxis = np.linspace(1,len(filteredPPG), len(filteredPPG))
    xaxis = xaxis / fields['fs']
    plt.figure()
    
    plt.subplot(2,1,1)
    plt.plot(xaxis, filteredPPG, c= [0,0,0])
    plt.pause(2)
    plt.scatter(peakx_PPG / fields['fs'], peaky_PPG, c= 'blue')
    plt.title('PPG waveform w/peaks - Subject: ' + str(pt_name))
    #frame1 = plt.gca()
    #frame1.axes.get_xaxis().set_ticks([])
    plt.ylabel('Pleth (mV)')
    
    plt.pause(2)
    #for beg_line in range(0, len(peakx_ECG)):
    #    plt.fill_betweenx([-10,10], peakx_ECG[beg_line] / fields['fs'], peakx_PPG[beg_line] / fields['fs'], color='grey', alpha = 0.3)
    plt.ylim([np.min(filteredPPG), np.max(filteredPPG)])
    #plt.xlim([0, 8.2])
    plt.subplot(2,1,2)
    plt.plot(xaxis, filteredECG, c=[0.6,0.1,0.1])
    plt.pause(3)
    plt.scatter(peakx_ECG / fields['fs'], peaky_ECG, c= 'red')
    plt.title('ECG waveforms w/peaks - Subject: ' + str(pt_name))
    plt.xlabel('Time (s)')
    plt.ylabel('Volts (mV)')
    plt.ylim([np.min(filteredECG), np.max(filteredECG)])
    matplotlib.rcParams.update({'font.size': 12})
    #plt.xlim([0, 8.2])
    plt.tight_layout()
    
    #for beg_line in range(0, len(peakx_ECG)):
    #    plt.fill_betweenx([-10,10], peakx_ECG[beg_line] / fields['fs'], peakx_PPG[beg_line] / fields['fs'], color='grey', alpha = 0.3)
    #plt.ylim([-1,2])
    plt.pause(3)
        
    good = int(input('Is this good? :'))
    plt.close()
    if good == 1:
        PTT = peakx_PPG - peakx_ECG
        
        avg_PTT = np.mean(PTT)
        PTT_seconds = avg_PTT / fields['fs']
        ptt_dict[pt_name] = PTT_seconds
        print(PTT_seconds)
    elif good in [2,5]:
        #lett pick the section to measure
        beg = float(input('Beginning point :'))
        endi = float(input('Ending point: '))
        
        beg = int(beg * fields['fs'])
        endi = int(endi * fields['fs'])
        print(beg)
        print(endi)
        
        try:
            if good == 5:
                peakx_PPG = peakx_PPG[1:]
            if peakx_PPG[0] < peakx_ECG[0]:
                peakx_PPG = peakx_PPG[1:]
            if len(peakx_PPG) < len(peakx_ECG):
                peakx_ECG = peakx_ECG[:-1]
            if len(peakx_ECG) > len(peakx_PPG):
                peakx_ECG = peakx_ECG[:-1]
        except:
            ptt_dict[pt_name] = 0
            #plt.close()
            #return(ptt_dict)
        print(peakx_PPG)
        print(peakx_ECG)
        try:
            PTT = peakx_PPG - peakx_ECG
        
        
            avg_PTT = np.mean(PTT)
            PTT_seconds = avg_PTT / fields['fs']
            print(PTT_seconds)
            ptt_dict[pt_name] = PTT_seconds
        except:
            print('fail')
    else:
        ptt_dict[pt_name] = 0
    plt.close()
    return(ptt_dict)
    
#%%
#create fuction to get all the patients names that we are interetsted in given a directory (p04) for example
def patients_numbers(sub_dir):
    base_dir = "D:\\users\\tpand\\desktop\\database\\"
    ps = os.listdir(base_dir + sub_dir)
    corrected = [int(x[2:]) if x[:2] == 'p0' else int(x[1:]) for x in ps]
    return(corrected)
    #should return a list of the patients numbers just as string numbers but without a leading p or a learing 0

usable = patients_numbers('p04')

#%%However, this can be done whole file wide, for all patients
def patients():
    f = open('D:/Users/tpand/Desktop/database/RECORDS').readlines()
    suitable_patients = [int(x[5:len(x) - 2]) for x in f]
    return(suitable_patients)
    

#%%This is the main line 
    '''
    
    Main waveform function and loop
    E is the saved database with clinical information
    pt_to_check are all patients that have both waveform data, as well as patients that are in the downloaed waveforms
    I had on my computer (all patietns that start with the number 4)
    
    '''
E = pd.read_csv('D:\\users\\tpand\\desktop\\database\\YAY.csv')
pt_w_wave = E[E['SUBJECT_ID'].isin(patients())]
pt_w_wave = pt_w_wave[pt_w_wave['SYSTOLIC'] < 230]
pt_w_wave_40 = pt_w_wave[pt_w_wave['SUBJECT_ID'].isin(usable)]
to_check = pt_w_wave_40['SUBJECT_ID'].values #these are all patients to sift thru the waveform set to check
#they all have heights, eights, etc, and all of them are inluded in the waveform dataset
ZXCVBNM = to_check #This is called somethign different so that i can modify it when i end the script so i can reset the next block of code without going through points i already checked
#%% ptt dictionary
ptts = dict()
for pt in ZXCVBNM:
    os.system('pause')
    plt.close('all')
    PATIENT_DIRECTORY = base_file + 'p04\\' + 'p0' + str(pt)
    
    #use biggest dat file
    dats_heas = os.listdir(PATIENT_DIRECTORY)
    relevant_dats = [x for x in dats_heas if (x[-3:] == 'dat') and (x[-5] != 'n')]
    
    BIGGEST = [0,0]
    for dat in relevant_dats:
        if os.path.getsize(base_file + 'p04\\' + 'p0' + str(pt) + '\\' +  dat) > BIGGEST[0]:
            BIGGEST[0] = os.path.getsize(base_file + 'p04\\' + 'p0' + str(pt) + '\\' + dat)
            BIGGEST[1] = dat
    #Now we have the biggest dat file. Remove the dat from the name and then run it into the read dat function
    fn = BIGGEST[1][:-4]        
    fn = base_file + 'p04\\' + 'p0' + str(pt) + '\\' + fn
    
    ptts = read_dat(pt, ptts, fn) #runs the waveform function above



#%% 
#Final evaluation - SBP #All model building based on two points, so scikits lin regression module not needed but it was easy so it was kept
'''
    This first section is USER specific, and requires modification in the tt variable to use the right csv
    it just to plot results for one user, we had to do this multiple times so the modularity wasnt all that of a concern


'''
tt = pd.read_csv('D:\\users\\tpand\\desktop\\database\\clinical\\JS.csv')
Train = tt.iloc[0:2]
Test = tt.iloc[2:, :]
bpn = ['SBP', 'DBP']

#Training
Features = ['INV']
SBP_reg = LinearRegression() #Create linear regression model
SBP_reg.fit(Train[Features], Train[bpn[0]])
S_LinC = SBP_reg.coef_
S_LinI = SBP_reg.intercept_
Test = tt.copy() #
estimation_slin = (Test[Features] * S_LinC).sum(axis = 1) + S_LinI #coefficients for features considered multiplied by the features and summed in the linear regression model
SLin_MSE = sklearn.metrics.mean_squared_error(estimation_slin, Test[bpn[0]]) #mean squared error
plt.figure('sbpandinv') #plot estimated vs actual
plt.subplot(2,2,1)
plt.scatter(Test[bpn[0]], estimation_slin, c= 'r')
plt.xlabel('SBP Actual')
plt.ylabel('SBP Estimated')
plt.title('SBP Estimation - JS')
esti_line = np.array((range(70, 200)))
plt.plot(esti_line, esti_line + 10, c= [0.2, 0.2, 0.2])
plt.plot(esti_line, esti_line - 10,c= [0.2, 0.2, 0.2])
plt.fill_between(esti_line, esti_line + 10, esti_line - 10, color = [0.7, 0, 0], alpha = 0.2)
matplotlib.rcParams.update({'font.size': 12})

plt.tight_layout()
#plt.scatter(Test[bpn[0]], (Test.INV * S_LinC) + S_LinI)

plt.figure('sbpandinv')
plt.subplot(2,2,2)
plt.scatter(tt['INV'], tt['SBP'])
plt.xlabel('1/PTT (Hz)')
plt.ylabel('SBP (mmHg)')
plt.title('SBP vs 1/PTT - JS')
xranges = np.linspace(0, 3, num=10)
LSRL = (xranges * S_LinC) + S_LinI
plt.plot(xranges, LSRL, 'black')
matplotlib.rcParams.update({'font.size': 12})

#Final evaluation DBP

tt = pd.read_csv('D:\\users\\tpand\\desktop\\database\\clinical\\JS.csv')
Train = tt.iloc[0:2]
Test = tt.iloc[2:, :]
bpn = ['SBP', 'DBP']

#Training
Features = ['INV']

DBP_reg = LinearRegression() #Create linear regression model
DBP_reg.fit(Train[Features], Train[bpn[1]])
D_LinC = DBP_reg.coef_
D_LinI = DBP_reg.intercept_
estimation_dlin = (Test[Features] * D_LinC).sum(axis = 1) + D_LinI #coefficients for features considered multiplied by the features and summed in the linear regression model
DLin_MSE = sklearn.metrics.mean_squared_error(estimation_dlin, Test[bpn[1]]) #mean squared error
#plt.figure('dbpandinv') #plot estimated vs actual
plt.subplot(2,2,3)
plt.scatter(Test[bpn[1]], estimation_dlin, c= 'r')
plt.xlabel('DBP Actual')
plt.ylabel('DBP Estimated')
plt.title('DBP Estimation - JS')
esti_line = np.array((range(40, 140)))
plt.plot(esti_line, esti_line + 10, c= [0.2, 0.2, 0.2])
plt.plot(esti_line, esti_line - 10,c= [0.2, 0.2, 0.2])
plt.fill_between(esti_line, esti_line + 10, esti_line - 10, color = [0.7, 0, 0], alpha = 0.2)
matplotlib.rcParams.update({'font.size': 12})

plt.tight_layout()
#plt.scatter(Test[bpn[0]], (Test.INV * S_LinC) + S_LinI)

#plt.figure('dbpandinv')
plt.subplot(2,2,4)
plt.scatter(tt['INV'], tt['DBP'])
plt.xlabel('1/PTT (Hz)')
plt.ylabel('DBP (mmHg)')
plt.title('DBP vs 1/PTT - JS')
xranges = np.linspace(0, 3, num=10)
LSRL = (xranges * D_LinC) + D_LinI
plt.plot(xranges, LSRL, 'black')





#%% All the curves together - including bland altman
#these lists are for the actual and estimated pressures for systolic and diastolic, appended for each person
'''
TP = Thomas 
LK = Lorianne
JS = Jingyu
KC = Kristin
'''
ACTUAL= []
ACTUAL_dia = []
ESTIMATED_dia = []
ESTIMATED = []
COLORS = []

################################################### - Lorianne
plt.figure('together')
plt.subplot(1,2,2)
LORI = pd.read_csv('D:\\users\\tpand\\desktop\\database\\clinical\\loritest.csv')
Features = ['INV']
Train = LORI.iloc[0:2]
SBP_reg = LinearRegression() #Create linear regression model
SBP_reg.fit(Train[Features], Train[bpn[0]])
S_LinC = SBP_reg.coef_
S_LinI = SBP_reg.intercept_
plt.scatter(LORI['INV'], LORI['SBP'], c = 'red', s=12)
xranges = np.linspace(0, 3, num=10)
LSRL = (xranges * S_LinC) + S_LinI
plt.plot(xranges, LSRL, 'red')
plt.subplot(1,2,1)
estimation_slin = (LORI[Features] * S_LinC).sum(axis = 1) + S_LinI #coefficients for features considered multiplied by the features and summed in the linear regression model
SLin_MSE = sklearn.metrics.mean_squared_error(estimation_slin, LORI[bpn[0]]) #mean squared error
plt.scatter(LORI[bpn[0]], estimation_slin, c = 'red', s=12)

DBP_reg = LinearRegression() #Create linear regression model
DBP_reg.fit(Train[Features], Train[bpn[1]])
D_LinC = DBP_reg.coef_
D_LinI = DBP_reg.intercept_
estimation_dlin = (LORI[Features] * D_LinC).sum(axis = 1) + D_LinI
plt.figure('dia')
plt.subplot(1,2,2)
plt.scatter(LORI['INV'], LORI['DBP'], c = 'red', s=12)
xranges = np.linspace(0, 3, num=10)
LSRL = (xranges * D_LinC) + D_LinI
plt.plot(xranges, LSRL, 'red')
plt.subplot(1,2,1)
plt.scatter(LORI[bpn[1]], estimation_dlin, c = 'red', s=12)
ACTUAL_dia = ACTUAL_dia + LORI[bpn[1]].to_list()
ESTIMATED_dia = ESTIMATED_dia + estimation_dlin.to_list()

ACTUAL = ACTUAL + LORI[bpn[0]].to_list()
ESTIMATED = ESTIMATED + estimation_slin.to_list()
COLORS = COLORS + ([[1, 0, 0]] * len(estimation_slin) )


################################################ Kristin
plt.figure('together')
plt.subplot(1,2,2)
KC= pd.read_csv('D:\\users\\tpand\\desktop\\database\\clinical\\KC.csv')
Features = ['INV']
Train = KC.iloc[0:2]
SBP_reg = LinearRegression() #Create linear regression model
SBP_reg.fit(Train[Features], Train[bpn[0]])
S_LinC = SBP_reg.coef_
S_LinI = SBP_reg.intercept_
plt.scatter(KC['INV'], KC['SBP'], c='blue', s=12)
xranges = np.linspace(0, 3, num=10)
LSRL = (xranges * S_LinC) + S_LinI
plt.plot(xranges, LSRL, 'blue')
plt.subplot(1,2,1)
estimation_slin = (KC[Features] * S_LinC).sum(axis = 1) + S_LinI #coefficients for features considered multiplied by the features and summed in the linear regression model
SLin_MSE = sklearn.metrics.mean_squared_error(estimation_slin, KC[bpn[0]]) #mean squared error
plt.scatter(KC[bpn[0]], estimation_slin, c = 'blue', s=12)


DBP_reg = LinearRegression() #Create linear regression model
DBP_reg.fit(Train[Features], Train[bpn[1]])
D_LinC = DBP_reg.coef_
D_LinI = DBP_reg.intercept_
estimation_dlin = (KC[Features] * D_LinC).sum(axis = 1) + D_LinI
plt.figure('dia')
plt.subplot(1,2,2)
plt.scatter(KC['INV'], KC['DBP'], c = 'blue', s=12)
xranges = np.linspace(0, 3, num=10)
LSRL = (xranges * D_LinC) + D_LinI
plt.plot(xranges, LSRL, 'blue')
plt.subplot(1,2,1)
plt.scatter(KC[bpn[1]], estimation_dlin, c = 'blue', s=12)
ACTUAL_dia = ACTUAL_dia + KC[bpn[1]].to_list()
ESTIMATED_dia = ESTIMATED_dia + estimation_dlin.to_list()

ACTUAL = ACTUAL + KC[bpn[0]].to_list()
ESTIMATED = ESTIMATED + estimation_slin.to_list()
COLORS = COLORS + ([[0, 0, 1]] * len(estimation_slin) )



############################################################### - Thomas
plt.figure('together')
plt.subplot(1,2,2)
TP = pd.read_csv('D:\\users\\tpand\\desktop\\database\\clinical\\tomtest.csv')
Features = ['INV']
Train = TP.iloc[0:2]
SBP_reg = LinearRegression() #Create linear regression model
SBP_reg.fit(Train[Features], Train[bpn[0]])
S_LinC = SBP_reg.coef_
S_LinI = SBP_reg.intercept_
plt.scatter(TP['INV'], TP['SBP'], c='black', s=12)
xranges = np.linspace(0, 3, num=10)
LSRL = (xranges * S_LinC) + S_LinI
plt.plot(xranges, LSRL, 'black')
plt.subplot(1,2,1)
estimation_slin = (TP[Features] * S_LinC).sum(axis = 1) + S_LinI #coefficients for features considered multiplied by the features and summed in the linear regression model
SLin_MSE = sklearn.metrics.mean_squared_error(estimation_slin, TP[bpn[0]]) #mean squared error
plt.scatter(TP[bpn[0]], estimation_slin, c = 'black', s=12)

DBP_reg = LinearRegression() #Create linear regression model
DBP_reg.fit(Train[Features], Train[bpn[1]])
D_LinC = DBP_reg.coef_
D_LinI = DBP_reg.intercept_
estimation_dlin = (TP[Features] * D_LinC).sum(axis = 1) + D_LinI
plt.figure('dia')
plt.subplot(1,2,2)
plt.scatter(TP['INV'], TP['DBP'], c = 'black', s=12)
xranges = np.linspace(0, 3, num=10)
LSRL = (xranges * D_LinC) + D_LinI
plt.plot(xranges, LSRL, 'black')
plt.subplot(1,2,1)
plt.scatter(TP[bpn[1]], estimation_dlin, c = 'black', s=12)

ACTUAL_dia = ACTUAL_dia + TP[bpn[1]].to_list()
ESTIMATED_dia = ESTIMATED_dia + estimation_dlin.to_list()
ACTUAL = ACTUAL + TP[bpn[0]].to_list()
ESTIMATED = ESTIMATED + estimation_slin.to_list()
COLORS = COLORS + ([[0, 0, 0]] * len(estimation_slin) )


############################################################### - Jingyu
plt.figure('together')
plt.subplot(1,2,2)
JS = pd.read_csv('D:\\users\\tpand\\desktop\\database\\clinical\\JS.csv')
Features = ['INV']
Train = JS.iloc[0:2]
SBP_reg = LinearRegression() #Create linear regression model
SBP_reg.fit(Train[Features], Train[bpn[0]])
S_LinC = SBP_reg.coef_
S_LinI = SBP_reg.intercept_
plt.scatter(JS['INV'], JS['SBP'], c='green', s=12)
xranges = np.linspace(0, 3, num=10)
LSRL = (xranges * S_LinC) + S_LinI
plt.plot(xranges, LSRL, 'green')
plt.subplot(1,2,1)
estimation_slin = (JS[Features] * S_LinC).sum(axis = 1) + S_LinI #coefficients for features considered multiplied by the features and summed in the linear regression model
SLin_MSE = sklearn.metrics.mean_squared_error(estimation_slin, JS[bpn[0]]) #mean squared error
plt.scatter(JS[bpn[0]], estimation_slin, c = 'green', s=12)

DBP_reg = LinearRegression() #Create linear regression model
DBP_reg.fit(Train[Features], Train[bpn[1]])
D_LinC = DBP_reg.coef_
D_LinI = DBP_reg.intercept_
estimation_dlin = (JS[Features] * D_LinC).sum(axis = 1) + D_LinI
plt.figure('dia')
plt.subplot(1,2,2)
plt.scatter(JS['INV'], JS['DBP'], c = 'green', s=12)
xranges = np.linspace(0, 3, num=10)
LSRL = (xranges * D_LinC) + D_LinI
plt.plot(xranges, LSRL, 'green')
plt.subplot(1,2,1)
plt.scatter(JS[bpn[1]], estimation_dlin, c = 'green', s=12)

ACTUAL_dia = ACTUAL_dia + JS[bpn[1]].to_list()
ESTIMATED_dia = ESTIMATED_dia + estimation_dlin.to_list()
ACTUAL = ACTUAL + JS[bpn[0]].to_list()
ESTIMATED = ESTIMATED + estimation_slin.to_list()
COLORS = COLORS + ([[0, 0.7, 0]] * len(estimation_slin))



#%% add legends to the plots
import matplotlib.patches as mpatches
legend_dict = {'LK' : 'red', 'KC' : 'blue', 'TP' : 'black', 'JS' : 'green'}
patchList = []
for key in legend_dict:
        data_key = mpatches.Patch(color=legend_dict[key], label=key)
        patchList.append(data_key)



plt.figure('together')
plt.subplot(1,2,1)
plt.legend(handles=patchList)
plt.title('SBP Estimated vs Actual')
plt.xlabel('SBP Actual (mmHg)')
plt.ylabel('SBP Estimated (mmHg)')
esti_line = np.array((range(40, 200)))
plt.plot(esti_line, esti_line + 10, c= [0.2, 0.2, 0.2])
plt.plot(esti_line, esti_line - 10,c= [0.2, 0.2, 0.2])
plt.fill_between(esti_line, esti_line + 10, esti_line - 10, color = [0.6, 0.6, 0.6], alpha = 0.2)
matplotlib.rcParams.update({'font.size': 12})
plt.subplot(1,2,2)
plt.title('SBP vs 1/PTT')
plt.xlabel('1/PTT (Hz)')
plt.ylabel('SBP (mmHg)')
plt.suptitle('SBP / PTT For the team')


plt.figure('dia')
plt.subplot(1,2,1)
plt.legend(handles=patchList)
plt.title('DBP Estimated vs Actual')
plt.xlabel('DBP Actual (mmHg)')
plt.ylabel('DBP Estimated (mmHg)')
esti_line = np.array((range(40, 200)))
plt.plot(esti_line, esti_line + 10, c= [0.2, 0.2, 0.2])
plt.plot(esti_line, esti_line - 10,c= [0.2, 0.2, 0.2])
plt.fill_between(esti_line, esti_line + 10, esti_line - 10, color = [0.6, 0.6, 0.6], alpha = 0.2)
matplotlib.rcParams.update({'font.size': 12})
plt.subplot(1,2,2)
plt.title('DBP vs 1/PTT')
plt.xlabel('1/PTT (Hz)')
plt.ylabel('DBP (mmHg)')
plt.suptitle('DBP / PTT For the team')





#%% make the bland altman plots
#actual - estimated / average
plt.scatter((np.array(ACTUAL) + np.array(ESTIMATED)) / 2, np.array(ACTUAL) - np.array(ESTIMATED), c = COLORS, s=20)
esti_line = np.array((range(70, 200)))
plt.plot(esti_line, [10] * len(esti_line), c = 'black')
plt.plot(esti_line, [-10] * len(esti_line), c = 'black')
plt.fill_between(esti_line, -10, 10, color = [0.6, 0.6, 0.6], alpha = 0.2)
matplotlib.rcParams.update({'font.size': 12})
defr = np.array(ACTUAL) - np.array(ESTIMATED)
abo = len(defr[defr > 10])
bel = len(defr[defr < -10])
print(abo)
print(bel)
print(len(defr))
plt.title('Bland Altman Plot (Actual vs Estimated SBP)')
plt.xlabel('Average (mmHg)')
plt.ylabel('Actual -  Estimated (mmHg)')
plt.xlim([80,180])
plt.legend(handles=patchList)

plt.figure('dia bland')
plt.scatter((np.array(ACTUAL_dia) + np.array(ESTIMATED_dia)) / 2, np.array(ACTUAL_dia) - np.array(ESTIMATED_dia), c = COLORS, s=20)
esti_line = np.array((range(30, 200)))
plt.plot(esti_line, [10] * len(esti_line), c = 'black')
plt.plot(esti_line, [-10] * len(esti_line), c = 'black')
plt.fill_between(esti_line, -10, 10, color = [0.6, 0.6, 0.6], alpha = 0.2)
matplotlib.rcParams.update({'font.size': 12})
defr = np.array(ACTUAL_dia) - np.array(ESTIMATED_dia)
abo = len(defr[defr > 10])
bel = len(defr[defr < -10])
print(abo)
print(bel)
print(len(defr))
plt.title('Bland Altman Plot (Actual vs Estimated DBP)')
plt.xlabel('Average (mmHg)')
plt.ylabel('Actual -  Estimated (mmHg)')

plt.legend(handles=patchList)
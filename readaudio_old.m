% Read in and name audio files
iphone_11 = 'Audio/carotid_iphone11.m4a';
iphone_7  = 'Audio/carotid_iphone7.m4a';
iphone_11_2 = 'Audio/carotid_iphone11_2.m4a';
iphone_7_2  = 'Audio/carotid_iphone7_2.m4a';

% Samples (y_x) and sample rate (Fs_x) for files
[y_11,Fs_11] = audioread(iphone_11);
[y_7, Fs_7]  = audioread(iphone_7);

[y_11_2,Fs_11_2] = audioread(iphone_11_2);
[y_7_2, Fs_7_2]  = audioread(iphone_7_2);
% To start 5 sec in and cut off last 5 sec:
% Delete the % before the %{ and %} if not using this block. Add in if using.
%{ 
removelast5sec_11= numel(y_11)- 5*Fs_11;
removelast5sec_7 = numel(y_7) - 5*Fs_7;
removelast5sec_11_2= numel(y_11_2)- 5*Fs_11_2;
removelast5sec_7_2 = numel(y_7_2) - 5*Fs_7_2;

samples_11 = [5*Fs_11, numel(y_11)- 5*Fs_11];
samples_7  = [5*Fs_7 , numel(y_7) - 5*Fs_7];
samples_11_2 = [5*Fs_11_2, numel(y_11_2)- 5*Fs_11_2];
samples_7_2  = [5*Fs_7_2 , numel(y_7_2) - 5*Fs_7_2];
%}

% If you want to start 5 sec in and use the next 20 sec:
% Delete the % before the %{ and %} if not using this block. Add in if using.
% %{ 
samples_11 = [5*Fs_11, 25*Fs_11];
samples_7  = [5*Fs_7 , 25*Fs_7];
samples_11_2 = [5*Fs_11_2, 25*Fs_11_2];
samples_7_2  = [5*Fs_7_2 , 25*Fs_7_2];
% %}

% Clear previous y_x value to replace with new y_x value
clear y_11
clear y_7 
clear y_11_2
clear y_7_2

% Samples for adjusted audio file
[y_11,Fs_11] = audioread(iphone_11,samples_11);
[y_7, Fs_7]  = audioread(iphone_7, samples_7);
[y_11_2,Fs_11_2] = audioread(iphone_11_2,samples_11_2);
[y_7_2, Fs_7_2]  = audioread(iphone_7_2, samples_7_2);

% x values for audio file (how many samples)
x_11 = 1:numel(y_11);
x_7  = 1:numel(y_7);
x_11_2 = 1:numel(y_11_2);
x_7_2  = 1:numel(y_7_2);

% plot audio files
subplot(4,1,1)
plot(x_11,y_11)
findpeaks(y_11,Fs_11,'MinPeakDistance', 0.6,'MinPeakProminence', 0.3);

subplot(4,1,2)
plot(x_7,y_7)
findpeaks(y_7, Fs_7, 'MinPeakDistance', 0.6,'MinPeakProminence', 0.3);

subplot(4,1,3)
plot(x_11_2,y_11_2)
findpeaks(y_11_2,Fs_11_2,'MinPeakDistance', 0.6,'MinPeakProminence', 0.3);

subplot(4,1,4)
plot(x_7_2,y_7_2)
findpeaks(y_7_2, Fs_7_2, 'MinPeakDistance', 0.6,'MinPeakProminence', 0.3);

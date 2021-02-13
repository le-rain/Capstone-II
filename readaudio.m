% Read in and name audio files
iphone_11 = 'carotid_iphone11_2.m4a';
iphone_7  = 'carotid_iphone7_2.m4a';

% Samples (y_x) and sample rate (Fs_x) for files
[y_11,Fs_11] = audioread(iphone_11);
[y_7, Fs_7]  = audioread(iphone_7);

% To start 5 sec in and cut off last 5 sec:
% Delete the % before the %{ and %} if not using this block. Add in if using.
%{ 
removelast5sec_11= numel(y_11)- 5*Fs_11;
removelast5sec_7 = numel(y_7) - 5*Fs_7;

samples_11 = [5*Fs_11, numel(y_11)- 5*Fs_11];
samples_7  = [5*Fs_7 , numel(y_7) - 5*Fs_7];
%}

% If you want to start 5 sec in and use the next 20 sec:
% Delete the % before the %{ and %} if not using this block. Add in if using.
% %{ 
samples_11 = [5*Fs_11, 20*Fs_11];
samples_7  = [5*Fs_7 , 20*Fs_7];
% %}

clear y_11 Fs_11
clear y_7  Fs_7

% Samples for adjusted audio file
[y_11,Fs_11] = audioread(iphone_11,samples_11);
[y_7, Fs_7]  = audioread(iphone_7, samples_7);

% x values for audio file (how many samples)
x_11 = 1:numel(y_11);
x_7  = 1:numel(y_7);

% plot audio files
subplot(2,1,1)
plot(x_11,y_11)

subplot(2,1,2)
plot(x_7,y_7)
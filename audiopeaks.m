% Call this function to plot audio files and find peaks
function [time, value] = audioPeaks(audio)

% Values (y_x) and sample rate (Fs_x) for file 
[y, Fs] = audioread(audio);

% Start sample at 5 sec in and use the next 20 sec:
sample = [5*Fs, 25*Fs]; 
hp = highpass(y, 0.1);
lp = lowpass_filter(sample, Fs, 5, 20);

% Clear previous y value to replace with new y value
clear y

% Values and sample rate for adjusted audio file
[y, Fs] = audioread(audio,lp);

% Convert x values from number of samples to seconds
x = 1:length(y);

% Get name of plot from name of audio file
m4a = contains(audio, 'm4a');
if m4a == 1 
    filename = extractBetween(audio, "Audio/", ".m4a");
else 
    filename = extractAfter(audio, "Audio/");
end

% Plot audio values vs. time
plot(x,y)

% findpeaks(y, Fs, 'MinPeakDistance', 0.5,'MinPeakProminence', 0.3);
findpeaks(y, Fs, 'MinPeakDistance', 0.2);
titlename = strcat("Audio Peaks for ",filename);
title(titlename);
xlabel('Time (s)');

end

% lowpass filter function
function data_filtered = lowpass_filter(data, sampl_rate, n_order, f_c);
[b_low,a_low] = butter(n_order, f_c/sampl_rate, 'low');
data_filtered = filtfilt(b_low, a_low, data);
end
% This plots the audio files and finds their peaks
close all;

figure(1)
audioPeaks('Audio/lorianne-iphone7.m4a');

figure(2)
audioPeaks('Audio/lorianne-iphone7-2.m4a');

figure(3)
audioPeaks('Audio/lorianne-iphone11.m4a');

figure(4)
audioPeaks('Audio/lorianne-iphone11-2.m4a');

% Call this function to plot audio files and find peaks
function [time, value] = audioPeaks(audio)

% Values (y_x) and sample rate (Fs_x) for file 
[y, Fs] = audioread(audio);

% Start sample at 5 sec in and use the next 20 sec:
sample = [5*Fs, 25*Fs];

% Clear previous y value to replace with new y value
clear y

% Values and sample rate for adjusted audio file
[y, Fs] = audioread(audio,sample);

% highpass band filter
%hps = highpass(y, 0.9);
lps = lowpass(y, 0.5);
%bps = bandpass(y, [0.5 0.7]);

% Convert x values from number of samples to seconds
% x = 1:numel(y);
n = 1:numel(y);
x = n ./ Fs;

% Get name of plot from name of audio file
m4a = contains(audio, 'm4a');
if m4a == 1 
    filename = extractBetween(audio, "Audio/", ".m4a");
end

% plot highpass
plot(x, lps);
findpeaks(lps, Fs, 'MinPeakDistance', 0.4,'MinPeakProminence', 0.2);
titlename = strcat("Audio Peaks for ",filename);
title(titlename);
xlabel('Time (s)');

%{ 
% Plot audio values vs. time
plot(x,y)
findpeaks(y, Fs, 'MinPeakDistance', 0.5,'MinPeakProminence', 0.3);
% findpeaks(y, Fs, 'MinPeakProminence', 0.1);
titlename = strcat("Audio Peaks for ",filename);
title(titlename);
xlabel('Time (s)');
%}

end
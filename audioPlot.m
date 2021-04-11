% This plots the audio files and finds their peaks
close all; clear all;

figure(1)
audioPeaks('App Videos/goldfish-1.mp4');

figure(2)
audioPeaks('App Videos/goldfish-2.mp4');

figure(3)
audioPeaks('App Videos/goldfish-3.mp4');
%}

% Call this function to plot audio files and find peaks
function [time, peaks] = audioPeaks(audio)

% Enter bpm, currently assuming 80 bpm
bpm = 80;
minDist = 60/bpm - 0.05;

% Values (y) and sample rate (Fs) for file 
[y, Fs] = audioread(audio);
[filepath,name,ext] = fileparts(audio);

% Use second channel/right channel
y = y(:,2);

% Square audio values to make peaks more prominent
y = y.^2;

% Convert x values from number of samples to seconds
n = 1:length(y);
x = n ./ Fs;

% Find peaks with minimum distance of entered BPM
[peaks, time] = findpeaks(y, Fs, 'MinPeakDistance', minDist);

findpeaks(y, Fs, 'MinPeakDistance', minDist);
hold on
titlename = strcat("Audio Peaks for ", name);
title(titlename, 'FontSize', 15, 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Relative Sound Amplitude');
ax = gca; 
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;
ax.FontWeight = 'bold';
hold off;

end
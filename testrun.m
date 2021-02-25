clear all; close all;

audio = 'Audio/lorianne-iphone11-3.m4a'

% Values (y_x) and sample rate (Fs_x) for file 
[y, Fs] = audioread(audio);

% Start sample at 5 sec in and use the next 20 sec:
sample = [5*Fs, 25*Fs];

% Clear previous y value to replace with new y value
clear y

% Values and sample rate for adjusted audio file
[y, Fs] = audioread(audio,sample);

% Convert x values from number of samples to seconds
n = 1:numel(y);
x = n ./ Fs;

% find all peaks
[value position] = findpeaks(y, Fs, 'MinPeakDistance', 0.5, 'MinPeakProminence', 0.05);
peaks = [position, value];

average_peak = mean(value);

%[i,~] = find(peaks(:,2) > average_peak*1.5 & peaks(:,2) < average_peak*0.5);
%peaks(i,:) = [];


% filter high frequency noise
%average_peak = mean(value);

%value([0:average_peak*0.5,average_peak*1.5:max(value)],1) = []


for i = 1:numel(value)
    if value(i) > average_peak * 1.5 | value(i) < average_peak * 0.5
        %peaks(i,:) = [];
        value(i) = 0;
        position(i) = 0;
    end
end

position = nonzeros(position);
value = nonzeros(value);

%filter_peaks = [position, value]
%[i,~] = find(pea

%}
% Get name of plot from name of audio file
m4a = contains(audio, 'm4a');
if m4a == 1 
    filename = extractBetween(audio, "Audio/", ".m4a");
end

% plot highpass
plot(x, y, 'b');
findpeaks(y, Fs, 'MinPeakDistance', 0.5, 'MinPeakProminence', 0.05);
hold on
plot(position, value, '.')
%plot(peaks(:,1), peaks(:,2), '.')
titlename = strcat("Audio Peaks for ",filename);
title(titlename);
xlabel('Time (s)');

%hold on
%plot(x, bps, 'r');
hold off
%}
%table = [y lps];

%{ 
% Plot audio values vs. time
plot(x,y)
findpeaks(y, Fs, 'MinPeakDistance', 0.5,'MinPeakProminence', 0.3);
% findpeaks(y, Fs, 'MinPeakProminence', 0.1);
titlename = strcat("Audio Peaks for ",filename);
title(titlename);
xlabel('Time (s)');
%}
% This plots the audio files and finds their peaks
close all; clear all;
% 
%figure()
%audioPeaks('Audio/iPhone7.2-1.m4a');
% 
%figure()
%audioPeaks('Audio/lorianne-iphone7-2.m4a');
% 
%figure(3)
%audioPeaks('Audio/lorianne-iphone11.m4a');
% 
% figure(4)
% audioPeaks('Audio/lorianne-iphone11-2.m4a');
% 
figure(5)
audioPeaks('Audio/Audio_s10mic.mp3');


% Call this function to plot audio files and find peaks
function [time, value] = audioPeaks(audio)

% Values (y_x) and sample rate (Fs_x) for file 
[y, Fs] = audioread(audio);

% Start sample at 5 sec in and use the next 20 sec:
sample = [5*Fs, 25*Fs]; 

% Values and sample rate for adjusted audio file
[data, Fs] = audioread(audio,sample);

% Convert x values from number of samples to seconds
n = 1:length(data);
x = n ./ Fs;

% find all peaks
[value time] = findpeaks(y, Fs, 'MinPeakDistance', 0.2, 'MinPeakProminence', 0.05);
peaks = [time, value];

average_peak = mean(value);

for i = 1:numel(value)
    if value(i) < average_peak * 0.5 %| value(i) > average_peak * 1.5
        %peaks(i,:) = [];
        value(i) = 0;
        time(i) = 0;
    end
end

time = nonzeros(time);
value = nonzeros(value);

peaks = [time value];

% find average distance between peaks
avg_dist = mean(diff(time))

s1 = []
s2 = []

for i = 1:(numel(time)-2)
    if time(i+1)-time(i) < avg_dist & time(i+2)-time(i+1) > avg_dist
        s1 = [s1; {time(i) value(i)}];
        s2 = [s2; {time(i+1) value(i+1)}];
    end
end

s1 = cell2mat(s1);
s2 = cell2mat(s2);

% Get name of plot from name of audio file
m4a = contains(audio, 'mp3');
if m4a == 1 
    filename = extractBetween(audio, "Audio/", ".mp3");
else 
    filename = extractAfter(audio, "Audio/");
end

% Plot audio values vs. time
plot(x, y, 'b');
findpeaks(y, Fs, 'MinPeakDistance', 0.2, 'MinPeakProminence', 0.05);
hold on
plot(s1(:,1), s1(:,2), 'o')
plot(s2(:,1), s2(:,2), 'o')
titlename = strcat("Audio Peaks for ",filename);
title(titlename, 'FontSize', 18, 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Relative Sound Amplitude');
ax = gca; 
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;
ax.FontWeight = 'bold';
hold off;
end
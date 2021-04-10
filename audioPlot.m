% This plots the audio files and finds their peaks
close all; clear all;
%{
figure(1)
audioPeaks('Audio/Audio_s10mic.mp3');

figure(2)
audioPeaks('Audio/s10-2.mp3');

figure(3)
audioPeaks('Audio/s10-4.m4a');
%}
% Call this function to plot audio files and find peaks
function [time, value] = audioPeaks(audio)

% Values (y) and sample rate (Fs) for file 
[y, Fs] = audioread(audio);
[filepath,name,ext] = fileparts(audio);

% Use second channel/right channel
y = y(:,2);

% Square values to make peaks more prominent
% y = y.^2;

% Convert x values from number of samples to seconds
n = 1:length(y);
x = n ./ Fs;

% Find peaks with minimum distance of 0.2 seconds (max 300 bpm)
peaks = findpeaks(y, Fs, 'MinPeakDistance', 0.2);

% Histogram to find and remove bottom 1% of range in values one at a time until normal(y) --> noise
figure()
subplot(3,1,1)
hist = histogram(peaks,100);
binEdges = hist.BinEdges;   
titlename = strcat("Histogram with Bin Size 100 for ", name);
title(titlename, 'FontSize', 15, 'FontWeight', 'bold');
xlabel('Relative Sound Amplitude');
ylabel('Percentage of Peaks in Each Bin');
ax = gca; 
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;
ax.FontWeight = 'bold';

bottomOnePercent = binEdges(2);
topTenPercent = binEdges(90);
 
[peaks, time] = findpeaks(y, Fs, 'MinPeakDistance', 0.2, 'MinPeakProminence', binEdges(2));

for i = 1:length(peaks)
    if peaks(i) >= topTenPercent
        peaks(i) = 0;
        time(i) = 0;
    end
end
peaks = nonzeros(peaks);
time = nonzeros(time);

% Find average peak distance in third quartile range of audio to use to identify some S1 and S2 peaks 
avg_dist = mean(diff(time(ceil(0.5*length(time)):ceil(0.75*length(time)))));

% Initiliaze list for S1 and S2 peaks
s1 = [];
s2 = [];

% Loop for identifying and appending S1 and S2 peaks
for i = 2:(length(time)-1)
    if (time(i)-time(i-1) > avg_dist && time(i+1)-time(i) < avg_dist)
        s1 = [s1; {time(i) peaks(i)}];
        s2 = [s2; {time(i+1) peaks(i+1)}];
    end
end

% Convert S1 and S2 lists from cells to array
s1 = cell2mat(s1);
s2 = cell2mat(s2);

avg_s1Dist = mean(diff(s1(1,:)));
avg_s2Dist = mean(diff(s2(1,:)));

% Plot original audio file with peaks at least 0.2 seconds apart
subplot(3,1,2)
findpeaks(y, Fs, 'MinPeakDistance', 0.2);
titlename = strcat("All Peaks with Minimum Peak Distance of 0.2s (Max 300 BPM)", name);
title(titlename, 'FontSize', 15, 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Relative Sound Amplitude');
ax = gca; 
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;
ax.FontWeight = 'bold';

% Plot audio file with identified S1 and S2 peaks
subplot(3,1,3)
findpeaks(y, Fs, 'MinPeakDistance', 0.2, 'MinPeakProminence', binEdges(2));
hold on
plot(s1(:,1), s1(:,2), 'r.')
plot(s2(:,1), s2(:,2), '.')
titlename = strcat("S1 and S2 Peaks for ", name);
title(titlename, 'FontSize', 15, 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Relative Sound Amplitude');
ax = gca; 
ax.XAxis.FontSize = 10;
ax.YAxis.FontSize = 10;
ax.FontWeight = 'bold';
hold off;

end
% This plots the audio files and finds their peaks
close all; clear all;

files = [%"01 Testing Videos/LK-B-1-122-70.mp4", 100, 1;
         %"01 Testing Videos/LK-B-2-116-64.mp4", 100, 1;
         %"01 Testing Videos/LK-B-3-90-60.mp4", 100, 1;
         %"01 Testing Videos/LK-B-4-90-60.mp4", 100, 1;     
         %"01 Testing Videos/LK-B-5-100-70.mp4", 100, 1;
         %"01 Testing Videos/LK-B-6-105-75.mp4", 100, 1;
         %"01 Testing Videos/LK-B-7-90-70.mp4", 100, 1;
         %"01 Testing Videos/TP-B-1-130-82.mp4", 100, 1;
         %"01 Testing Videos/kc-b-1-90-58.mp4", 100, 1;
         %"01 Testing Videos/kc-b-2-94-56.mp4", 100, 1;
         %"01 Testing Videos/kc-b-3-95-65.mp4", 100, 1;
         %"01 Testing Videos/kc-b-5-90-70.mp4", 100, 1;
         %"01 Testing Videos/kc-b-6-90-70.mp4", 100, 1;
         %"01 Testing Videos/kc-h-1-126-66.mp4", 120, 1;
         %"01 Testing Videos/kc-h-2-108-72.mp4", 120, 1;
         %"01 Testing Videos/LK-FHD-60.mp4";
         ];

size = size(files);
n_files = size(1);

section = cell(1,n_files);

for i = 1:n_files
    audio = convertStringsToChars(files(i,1));
    %bpm = str2double(files(i,2));
    %plotOption = str2double(files(i,3));
    [~,name,~] = fileparts(audio);
    [time, peaks] = audioPeaks(audio);
    %section{i} = sectionT;
end


% Call this function to plot audio files and find peaks
function [time, peaks] = audioPeaks(audio)

% Values (y) and sample rate (Fs) for file 
[y, Fs] = audioread(audio);

% Use second channel/right channel
y = y(:,2);

% Square the data to make peaks more prominent
y = y.^2;

% Convert x values from number of samples to seconds
n = 1:length(y);
x = n' ./ Fs;

% Find peaks of data and plot
figure()
subplot(3,1,1)
findpeaks(y, Fs);
peaks = findpeaks(y, Fs);

% Histogram to find and remove bottom 1% of range in values (y) --> noise
subplot(3,1,2)
h = histogram(peaks,100);
one_percent = h.BinWidth;

subplot(3,1,3)
findpeaks(y, Fs, 'MinPeakDistance', 0.2, 'MinPeakProminence', one_percent);
[peaks, time] = findpeaks(y, Fs, 'MinPeakDistance', 0.2, 'MinPeakProminence', one_percent);
%{
% Find average peak distance in third quartile range of audio to use to identify S1 and S2 peaks 
%avg_peak = mean(value(ceil(0.5*length(value)):ceil(0.75*length(value))));
avg_dist = mean(diff(time(ceil(0.5*length(time)):ceil(0.75*length(time)))));

% Remove non S1 and S2 peaks
for i = 1:(length(time)-2)
    if time(i+1)-time(i) < avg_dist && time(i+2)-time(i+1) < avg_dist
        time(i+2) = 0;
        peaks(i+2) = 0;
    end
end
time = nonzeros(time);
peaks = nonzeros(peaks);

% Refresh list with removed peaks
peaks = [time value];

% Initiliaze list for S1 and S2 peaks
s1 = [];
s2 = [];

% Loop for identifying and appending S1 and S2 peaks
for i = 3:(length(time))
    if time(i)-time(i-1) > avg_dist & time(i-1)-time(i-2) < avg_dist
        s1 = [s1; {time(i) value(i)}];
        s2 = [s2; {time(i+1) value(i+1)}];
    end
end

% Convert S1 and S2 lists from cells to array
s1 = cell2mat(s1);
s2 = cell2mat(s2);

s1_t = s1(:,1);
s1_v = s1(:,2);
s2_t = s2(:,1);
s2_v = s2(:,2);

% Find a good section of audio file with identifiable peaks
for i = 1:(length(s1)-1)
    if s1_t(i+1)-s1_t(i) > 2
        s1_t(i) = 0;
        s1_v(i) = 0;
        s2_t(i) = 0;
        s2_v(i) = 0;
    end
end
s1_t = nonzeros(s1_t);
s1_v = nonzeros(s1_v);
s2_t = nonzeros(s2_t);
s2_v = nonzeros(s2_v);

s1 = [s1_t s1_v];
s2 = [s2_t s2_v];

% start and end times in seconds for audio sample
t_start = ceil(s1_t(1));
t_end = ceil(s2_t(10));
sample = [t_start*Fs, t_end*Fs];

% Values and sample rate for cropped or adjusted audio file
[y, Fs] = audioread(audio,sample);

y = y.^2;

% Convert x values from number of samples to seconds
n = 1:length(y);
x = n ./ Fs;

% Find all peaks with minimum distance of 0.2 seconds apart (max 300 bpm)
[value time] = findpeaks(y, Fs, 'MinPeakDistance', 0.2, 'MinPeakProminence', one_percent);
peaks = [time, value];

% Find average peak distance to use to identify S1 and S2 peaks 
avg_peak = mean(value);
avg_dist = mean(diff(time(length(time)-10:length(time))));

% Remove non S1 and S2 peaks 
for i = 1:(length(time)-2)
    if time(i+1)-time(i) < avg_dist & time(i+2)-time(i+1) < avg_dist
        time(i+2) = 0;
        value(i+2) = 0;
    elseif time(i+1)-time(i) > avg_dist & time(i+2)-time(i+1) > avg_dist
        time(i+2) = 0;
        value(i+2) = 0;
    end
end
time = nonzeros(time);
value = nonzeros(value);

% Refresh list with removed peaks
peaks = [time value];

% Initiliaze list for S1 and S2 peaks
s1 = [];
s2 = [];

% Loop for identifying and appending S1 and S2 peaks
for i = 3:(length(time))
    if (time(i)-time(i-1) > avg_dist && time(i-1)-time(i-2) < avg_dist)
        s1 = [s1; {time(i) value(i)}];
        s2 = [s2; {time(i+1) value(i+1)}];
    end
end

% Convert S1 and S2 lists from cells to array
s1 = cell2mat(s1);
s2 = cell2mat(s2);

% Get name of plot from name of audio file
[filepath,name,ext] = fileparts(audio);

% plot audio data with peaks 
plot(x, y);
findpeaks(y, Fs, 'MinPeakDistance', 0.2, 'MinPeakProminence', one_percent);
hold on
plot(s1(:,1), s1(:,2), 'r.')
plot(s2(:,1), s2(:,2), '.')
titlename = strcat("Audio Peaks for ", name);
title(titlename, 'FontSize', 18, 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Relative Sound Amplitude');
ax = gca; 
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;
ax.FontWeight = 'bold';
hold off;
%}
end
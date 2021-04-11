% This plots the audio files and finds their peaks
close all; clear all;

figure(1)
subplot(3,1,1)
audioPeaks('Audio/Audio_s10mic.mp3');

subplot(3,1,2)
audioPeaks('Audio/s10-2.mp3');

subplot(3,1,3)
audioPeaks('Audio/s10-4.m4a');


% Call this function to plot audio files and find peaks
function [time, value] = audioPeaks(audio)

% Values (y) and sample rate (Fs) for file 
[y, Fs] = audioread(audio);

% Square the data to make peaks more prominent
y = y.^2;

% Find peaks of at least 0.2 seconds apart (max 300 bpm)
p = findpeaks(y, Fs, 'MinPeakDistance', 0.2);

% Histogram to find and remove bottom 1% of range in values (y) --> noise
h = histogram(p,100);
one_percent = h.BinWidth;
[value time] = findpeaks(y, Fs, 'MinPeakDistance', 0.2, 'MinPeakProminence', one_percent);

% Find average peak distance in third quartile range of audio to use to identify S1 and S2 peaks 
avg_peak = mean(value(ceil(0.5*length(value)):ceil(0.75*length(value))));
avg_dist = mean(diff(time(ceil(0.5*length(time)):ceil(0.75*length(time)))));

% Remove non S1 and S2 peaks
for i = 1:(length(time))
    if time(i+1)-time(i) < avg_dist & time(i+2)-time(i+1) < avg_dist
        time(i+2) = 0;
        value(i+2) = 0;
    end
end
time = nonzeros(time);
value = nonzeros(value);


%{
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

end
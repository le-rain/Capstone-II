clear all; close all;

audio = 'Audio/Audio_s10mic.mp3';

% Values (y_x) and sample rate (Fs_x) for file 
[y, Fs] = audioread(audio);

% start and end times in seconds for audio sample
t_start = 10;
t_end   = 25;
sample = [t_start*Fs, t_end*Fs];

% Clear previous y value to replace with new y value
clear y

% Values and sample rate for cropped or adjusted audio file
[y, Fs] = audioread(audio,sample);

% Square values to amplify signal
y = y.^2;

% Convert x values from number of samples to seconds
n = 1:numel(y);
x = n ./ Fs;

% Find all peaks with minimum distance of 0.2 seconds apart (max 300 bpm)
[value time] = findpeaks(y, Fs, 'MinPeakDistance', 0.2, 'MinPeakProminence', 0.001);
peaks = [time, value];

% Find average peak distance to use to identify S1 and S2 peaks 
average_peak = mean(value);
avg_dist = mean(diff(time));

%{
% Find peaks that are below 0.5*avg (too low) and above 1.5*avg (too high)
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
%}

% Initiliaze list for S1 and S2 peaks
s1 = [];
s2 = [];

% Remove S1 and S2 peaks and append to respective list
for i = 1:(numel(time)-2)
    if time(i+1)-time(i) < avg_dist & time(i+2)-time(i+1) < avg_dist
        time(i+2) = 0;
        value(i+2) = 0;
    end
end
time = nonzeros(time);
value = nonzeros(value);

% Refresh list with removed peaks
peaks = [time value];

% Loop for identifying and appending S1 and S2 peaks
for i = 1:(numel(time)-2)
    if time(i+1)-time(i) < avg_dist & time(i+2)-time(i+1) > avg_dist
        s1 = [s1; {time(i) value(i)}];
        s2 = [s2; {time(i+1) value(i+1)}];
    end
end

% Convert S1 and S2 lists from cells to array
s1 = cell2mat(s1);
s2 = cell2mat(s2);

% Get name of plot from name of audio file
m4a = contains(audio, 'mp3');
if m4a == 1 
    filename = extractBetween(audio, "Audio/", ".mp3");
end

% plot audio data with peaks 
plot(x, y, 'b');
findpeaks(y, Fs, 'MinPeakDistance', 0.2, 'MinPeakProminence', 0.001);
hold on
plot(s1(:,1), s1(:,2), '.')
plot(s2(:,1), s2(:,2), '.')
titlename = strcat("Audio Peaks for ",filename);
title(titlename, 'FontSize', 18, 'FontWeight', 'bold');
xlabel('Time (s)');
ylabel('Relative Sound Amplitude');
ax = gca; 
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;
ax.FontWeight = 'bold';
hold off;
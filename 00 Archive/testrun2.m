% This plots the audio files and finds their peaks
close all; clear all;

files = [%"01 Testing Videos/LK-B-1-122-70.mp4"; % s2 peaks good, s1 very quiet, also noisy
         %"01 Testing Videos/LK-B-2-116-64.mp4"; % very noisy, very bad
         %"01 Testing Videos/LK-B-3-90-60.mp4";  % very noisy, very bad
         %"01 Testing Videos/LK-B-4-90-60.mp4";  % good    
         %"01 Testing Videos/LK-B-5-100-70.mp4"; % very noisy, not good at all
         %"01 Testing Videos/LK-B-6-105-75.mp4"; % s2 peaks good, s1 might be quiet, also noisy
         %"01 Testing Videos/LK-B-7-90-70.mp4";  % peaks but cannot tell s1/s2
         %"01 Testing Videos/TP-B-1-130-82.mp4"; % quietly noisy
         %"01 Testing Videos/kc-b-1-90-58.mp4";  % s1 peaks are very quiet
         %"01 Testing Videos/kc-b-2-94-56.mp4";  % very quiet, peaks but cannot tell s1/s2
         %"01 Testing Videos/kc-b-3-95-65.mp4";  % very quiet and noisy, cannot tell s1/s2
         %"01 Testing Videos/kc-b-4-95-70.mp4";  
         %"01 Testing Videos/kc-b-5-90-70.mp4";  % good
         %"01 Testing Videos/kc-b-6-90-70.mp4";  % peaks but cannot tell s1/s2
         %"01 Testing Videos/kc-h-1-126-66.mp4"; % s2 peaks are very quiet
         %"01 Testing Videos/kc-h-2-108-72.mp4"; % very quiet, cannot tell s1/s2
         %"01 Testing Videos/LK-FHD-60.mp4", 2;     %
         %"01 Testing Videos/LK-B-10-102-96.mp4", 2;
         %"01 Testing Videos/LK-B-9-102-60.mp4", 2;
         "01 Testing Videos/KC-B-12-104-78.mp4", 2
         ];

size = size(files);
n_files = size(1);

section = cell(1,n_files);

for i = 1:n_files
    audio = convertStringsToChars(files(i,1));
    %bpm = str2double(files(i,2));
    plotOption = str2double(files(i,2));
    [sectionT, sectionI, Fs, audioData, time] = audioPulse(audio, plotOption);
    section{i} = sectionT;
end

function [sectionT, sectionI, Fs, audioData, time] = audioPulse(audio, plotOption)

% Read audio from video and find peaks
[audio, peaks, time, x, y, Fs, one_percent] = findAudioPeaks(audio);

% Find start and stop of good peak sections
[istart, iend] = findAudioSection(peaks, time);

[sectionI] = plotAudioSection(istart, iend, audio, x, y, Fs, plotOption, one_percent);

audioData = y;

end

% Call this function to plot audio files and find peaks
function [audio, peaks, nSample, y, Fs, onePercent] = findAudioPeaks(audio)

% Values (y) and sample rate (Fs) for file 
[y, Fs] = audioread(audio);
[~,name,~] = fileparts(audio);

% Use second channel/right channel and square data
y = y(:,2).^2;

% Find peaks of data and plot
figure()
hold on
subplot(3,1,1)
findpeaks(y);
titlename = strcat("Audio Data for ", name);
title(titlename, 'FontSize', 15, 'FontWeight', 'bold');
    
peaks = findpeaks(y);

% Histogram to find and remove bottom 1% of range in values (y) --> noise
subplot(3,1,2)
h = histogram(peaks,100);
onePercent = h.BinWidth;

% Set bpm to max (300 bpm = 0.2 s)
bpm = 0.2 * Fs;

subplot(3,1,3)
findpeaks(y, 'MinPeakDistance', bpm, 'MinPeakProminence', onePercent);
[peaks, nSample] = findpeaks(y, 'MinPeakDistance', bpm, 'MinPeakProminence', onePercent);
hold off

end

function [sectionI] = findAudioSection(peaks, nSample)

% Find average peak distance and upper and lower thresholds
avgPeak = mean(peaks);
upperPeaks = (peaks > avgPeak);

% Remove peaks that are above avgPeak
for i = 1:length(peaks)
    if upperPeaks(i) == 1
        peaks(i) = 0;
        nSample(i) = 0;
    end
end

% Remove zeros from peaks
peaks = nonzeros(peaks);
nSample = nonzeros(nSample);

% Find average peak distance and lower threshold
avgPeakDist = mean(diff(nSample));
upperDist = 1.25 * avgPeakDist;

% Initialize section lists
timeDiff = [];

% Append start and end times
for i = 1:length(nSample)-1
    timeDiff = [timeDiff; {nSample(i+1) - nSample(i)}];
end

timeDiff = cell2mat(timeDiff);

gap = (timeDiff > upperDist);
hasGap = (gap == 1);

tstart = [];
tend = [];

% If there are gaps in peak data, use those as section dividers
if any(gap == 1) == 1
    for i = 1:length(gap)
        if gap(i) == 1 
            tstart = [tstart; {nSample(i+1)}];
            tend = [tend; {nSample(i)}];
        end
    end
% If there are no gaps, then use entire audio    
else
    tstart = nSample(1);
    tend = nSample(length(nSample));
end    

% Reformat tstart and tend to matrices if they are cell arrays
if iscell(tstart) == 1 || iscell(tend) ==1
    tstart = cell2mat(tstart);
    tend = cell2mat(tend);
end

% If there is only one section and tstart value is later than tend value, 
% use audio before and after these timestaps as sections
if tstart > tend
    tstart = [tstart; {nSample(1)}];
    tend = [tend; {nSample(length(nSample))}];
    tstart = cell2mat(tstart);
    tend = cell2mat(tend);
    tstart = sort(tstart);
    tend = sort(tend);
% If there is more than 1 section, then remove first tend and last tstart
% values
elseif length(tstart) > 1
    tend(1) = 0;
    tstart(length(tstart)) = 0;
    tstart = nonzeros(tstart);
    tend = nonzeros(tend);
end

% Remove sections that have same start and end
for i = 1:length(tstart)
    if tstart(i) == tend(i)
        tstart(i) = 0;
        tend(i) = 0;
    end
end
tstart = nonzeros(tstart);
tend = nonzeros(tend);

% Remove sections that are less than 1.5 sec
for i = 1:length(tstart)
    if tend(i) - tstart(i) < 1.5
        tstart(i) = 0;
        tend(i) = 0;
    end
end
tstart = nonzeros(tstart);
tend = nonzeros(tend);

sectionT = [tstart, tend];

sectionI = sectionT.*Fs;

end
%{
function findS1S2peaks(x, y, Fs, one_percent, tstart, tend)
%{
for i = 1:length(tstart)
    % Find average peak distance in audio sections to identify S1 and S2 peaks
    [peaks, time] = findpeaks(y(tstart:tend), Fs, 'MinPeakProminence', one_percent, 'MinPeakDistance', 0.2)
    avg_dist = mean(diff(tstart(i):tend(i))));
end
%}
% Find average peak distance in audio sections to identify S1 and S2 peaks 
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

end
%}
function [sectionI] = plotAudioSection(istart, iend, audio, x, y, Fs, plotOption, one_percent)

[~,name,~] = fileparts(audio);

if plotOption == 1
 
    figure
    findpeaks(y, Fs, 'MinPeakDistance', 0.2)
    xlabel('Time (s)');
    ylabel('Relative Sound Amplitude');
    titlename = strcat("Audio Data for ", name);
    title(titlename, 'FontSize', 15, 'FontWeight', 'bold');
    ax = gca; 
    ax.XAxis.FontSize = 10;
    ax.YAxis.FontSize = 10;
    ax.FontWeight = 'bold';  
    
elseif plotOption == 2
 
    figure
    findpeaks(y, Fs, 'MinPeakDistance', 0.2)
    xlabel('Time (s)');
    ylabel('Relative Sound Amplitude');
    titlename = strcat("Audio Data for ", name);
    title(titlename, 'FontSize', 15, 'FontWeight', 'bold');
    ax = gca; 
    ax.XAxis.FontSize = 10;
    ax.YAxis.FontSize = 10;
    ax.FontWeight = 'bold';  
    
    for i = 1:length(istart) %for every section 
        figure %create new figure
        time = x(istart(i):iend(i));
        values = y(istart(i):iend(i));
        plot(time, values)
        findpeaks(values, Fs, 'MinPeakDistance', 0.2)
        xlabel('Time (s)');
        ylabel('Relative Sound Amplitude');
        titlename = strcat("Section ", int2str(i), " for ", name); %title "Section n"
        title(titlename, 'FontSize', 15, 'FontWeight', 'bold');
        ax = gca; 
        ax.XAxis.FontSize = 10;
        ax.YAxis.FontSize = 10;
        ax.FontWeight = 'bold';    
    end
   
end

end

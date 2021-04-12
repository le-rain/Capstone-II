% Call this function to find start and end incidces for best sections with
% consecutive peaks

function [sectionT] = findPeakSection(peaks, time)

% Find average peak distance and upper and lower thresholds
avgPeak1 = mean(peaks);
upperPeaks = (peaks > 2*avgPeak1);

for i = 1:length(peaks)
    if upperPeaks(i) == 1
        peaks(i) = 0;
        time(i) = 0;
    end
end

% Remove zeros from peaks
peaks = nonzeros(peaks);
time = nonzeros(time);

%{
% Find average peak distance and upper and lower thresholds
avgPeak2 = mean(peaks);
upperPeak = 5 * avgPeak2;

% Remove peaks that are greater than 5*avg
upperPeaks = (peaks > upperPeak);
for i = 1:length(peaks)
    if upperPeaks(i) == 1
        peaks(i) = 0;
        time(i) = 0;
    end
end

% Remove zeros from peaks
peaks = nonzeros(peaks);
time = nonzeros(time);
%}

% Find average peak distance and lower threshold
avgPeakDist = mean(diff(time));
upperDist = 1.25 * avgPeakDist;

% Initialize section lists
timeDiff = [];

% Append start and end times
for i = 1:length(time)-1
    timeDiff = [timeDiff; {time(i+1) - time(i)}];
end

timeDiff = cell2mat(timeDiff);

gap = (timeDiff > upperDist);
hasGap = (gap == 1);

tstart = [];
tend = [];

if any(gap == 1) == 1
    for i = 1:length(gap)
        if gap(i) == 1 
            tstart = [tstart; {time(i+1)}];
            tend = [tend; {time(i)}];
        end
    end
else
    tstart = time(1);
    tend = time(length(time));
end    

if iscell(tstart) == 1 || iscell(tend) ==1
    tstart = cell2mat(tstart);
    tend = cell2mat(tend);
end

if tstart > tend
    tstart = [tstart; {time(1)}];
    tend = [tend; {time(length(time))}];
    tstart = cell2mat(tstart);
    tend = cell2mat(tend);
    tstart = sort(tstart);
    tend = sort(tend);
elseif length(tstart) > 1
    tend(1) = 0;
    tstart(length(tstart)) = 0;
    tstart = nonzeros(tstart);
    tend = nonzeros(tend);
end

for i = 1:length(tstart)
    if tstart(i) == tend(i)
        tstart(i) = 0;
        tend(i) = 0;
    end
end

tstart = nonzeros(tstart);
tend = nonzeros(tend);

sectionT = [tstart, tend];
end
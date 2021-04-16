% Call this function to find start and end incidces for best sections with
% consecutive peaks

function [iStart, iEnd] = findAudioSection(peaks, nSamples, Fs)

% Find average peak distance and upper and lower thresholds
avgPeak = mean(peaks);
upperPeak = 10 * avgPeak;
upperPeaks = (peaks > upperPeak);

for i = 1:length(peaks)
    if upperPeaks(i) == 1
        peaks(i) = 0;
        nSamples(i) = 0;
    end
end

% Remove zeros from peaks
peaks = nonzeros(peaks);
nSamples = nonzeros(nSamples);

% Find average peak distance and lower threshold
avgPeakDist = mean(diff(nSamples));
upperDist = 1.45*avgPeakDist;

% Initialize section lists
timeDiff = [];

% Append start and end times
for i = 1:length(nSamples)-1
    timeDiff = [timeDiff; {nSamples(i+1) - nSamples(i)}];
end

timeDiff = cell2mat(timeDiff);

gap = (timeDiff > upperDist);

iStart = [];
iEnd = [];

if any(gap == 1)
    for i = 1:length(gap)
        if gap(i) == 1 
            iStart = [iStart; {nSamples(i+1)}];
            iEnd = [iEnd; {nSamples(i)}];
        end
    end
else
    iStart = nSamples(1);
    iEnd = nSamples(length(nSamples));
end    

if iscell(iStart) == 1 || iscell(iEnd) ==1
    iStart = cell2mat(iStart);
    iEnd = cell2mat(iEnd);
end

if iStart > iEnd
    iStart = [iStart; {nSamples(1)}];
    iEnd = [iEnd; {nSamples(length(nSamples))}];
    iStart = cell2mat(iStart);
    iEnd = cell2mat(iEnd);
    iStart = sort(iStart);
    iEnd = sort(iEnd);
elseif length(iStart) > 1
    iEnd(1) = 0;
    iStart(length(iStart)) = 0;
    iStart = nonzeros(iStart);
    iEnd = nonzeros(iEnd);
end

for i = 1:length(iStart)
    if iStart(i) == iEnd(i)
        iStart(i) = 0;
        iEnd(i) = 0;
    end
end

iStart = nonzeros(iStart);
iEnd = nonzeros(iEnd);

% Remove sections that are less than 1.5 sec
for i = 1:length(iStart)
    if iEnd(i) - iStart(i) < 1.5*Fs
        iStart(i) = 0;
        iEnd(i) = 0;
    end
end

iStart = nonzeros(iStart);
iEnd = nonzeros(iEnd);

end
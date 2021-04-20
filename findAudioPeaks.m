% Call this function to find peaks for audio files
function [name, peaks, nSamples, x, y, Fs, minDist] = findAudioPeaks(audio, channel)

% Values (y) and sample rate (Fs) for file 
[y, Fs] = audioread(audio);
[~,name,~] = fileparts(audio);

% Find minimum peak distance with bpm
minDist = (60/300 - 0.05) * Fs;

% Compare first and second channels
y1 = y(:,1).^2;
y2 = y(:,2).^2;

if channel == 0
    if mean(y1) > mean(y2)   
        y = y1;
    else 
        y = y2;
    end  
elseif channel == 1
    y = y1;
elseif channel == 2
    y = y2;
end

x = (1:length(y))';

% Find peaks with minimum distance of entered BPM
[peaks, nSamples] = findpeaks(y, 'MinPeakDistance', minDist);

end
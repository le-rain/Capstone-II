% Call this function to find peaks for audio files
function [audio, peaks, time, x, y, Fs, minDist] = findAudioPeaks(audio, bpm)

% Find minimum peak distance with bpm
minDist = 60/bpm - 0.05;

% Values (y) and sample rate (Fs) for file 
[y, Fs] = audioread(audio);

% Use second channel/right channel
y = y(:,2);

% Square audio values to make peaks more prominent
y = y.^2;

% Convert x values from number of samples to seconds
n = 1:length(y);
x = n' ./ Fs;

% Find peaks with minimum distance of entered BPM
[peaks, time] = findpeaks(y, Fs, 'MinPeakDistance', minDist);

end
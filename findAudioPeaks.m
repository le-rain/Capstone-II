% Call this function to find peaks for audio files
function [name, peaks, nSamples, x, y, Fs, minDist] = findAudioPeaks(audio)

% Values (y) and sample rate (Fs) for file 
[y, Fs] = audioread(audio);
[~,name,~] = fileparts(audio);

% Find minimum peak distance with bpm
minDist = (60/300 - 0.05) * Fs;

% Use second channel/right channel and square audio values
y = y(:,2).^2;
x = (1:length(y))';

% Find peaks with minimum distance of entered BPM
[peaks, nSamples] = findpeaks(y, 'MinPeakDistance', minDist);

end
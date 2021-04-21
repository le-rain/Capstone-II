% Call this function to find peaks for audio files
function [name, peaks, nSamples, x, y, Fs, minDist, channel] = findAudioPeaks(audio, channel)

% Values (y) and sample rate (Fs) for file 
[y, Fs] = audioread(audio);
[~,name,~] = fileparts(audio);

% Find minimum peak distance with bpm
minDist = round((60/300 - 0.05) * Fs);

% Compare first and second channels
y1 = y(:,1).^2;
y2 = y(:,2).^2;

% Find channel
if channel == 0
    if mean(y1) > 10*mean(y2)
        y = y1;
        channel = 1;
    elseif mean(y2) > 10*mean(y1)
        y = y2;
        channel = 2;
    elseif max(y1) > max(y2)
        y = y1;
        channel = '1; noisy data';
    elseif max(y2) > max(y1)
        y = y2;
        channel = '2; noisy data';
    end  
elseif channel == 1
    y = y1;
elseif channel == 2
    y = y2;
end

% Remove close to zero values
for i = 1:length(y)
    if y(i) < 1e-6 && y(i) > 0
        y(i) = 0;
        x(i) = 0;
    end
end    

% Find number of samples
x = (1:length(y))';

% Find peaks with minimum distance of entered BPM
[peaks, nSamples] = findpeaks(y, 'MinPeakDistance', minDist);

end
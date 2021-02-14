% Call this function to plot audio files and find peaks
function [time, value] = audioPeaks(audio)

% Values (y_x) and sample rate (Fs_x) for file 
[y, Fs] = audioread(audio);

% Start sample at 5 sec in and use the next 20 sec:
sample = [5*Fs, 25*Fs];

% Clear previous y value to replace with new y value
clear y

% Values and sample rate for adjusted audio file
[y, Fs] = audioread(audio,sample);

% Convert x values from number of samples to seconds
x = 1:numel(y);

% Get name of plot from name of audio file
m4a = contains(audio, 'm4a');
if m4a == 1 
    filename = extractBetween(audio, "Audio/", ".m4a");
end

% Plot audio values vs. time
plot(x,y)
findpeaks(y, Fs, 'MinPeakDistance', 0.6,'MinPeakProminence', 0.3);
titlename = strcat("Audio Peaks for ",filename);
title(titlename);
xlabel('Time (s)');

end
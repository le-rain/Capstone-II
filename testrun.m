audio = 'Audio/lorianne-iphone11.m4a'

% Values (y_x) and sample rate (Fs_x) for file 
[y, Fs] = audioread(audio);

% Start sample at 5 sec in and use the next 20 sec:
sample = [5*Fs, 25*Fs];

% Clear previous y value to replace with new y value
clear y

% Values and sample rate for adjusted audio file
[y, Fs] = audioread(audio,sample);

% highpass band filter
hps = highpass(y, 0.9);
%lps = lowpass(y, 0.00000000007);
%bps = bandpass(y, [0.5 0.7]);

% Convert x values from number of samples to seconds
% x = 1:numel(y);
n = 1:numel(y);
x = n ./ Fs;

% Get name of plot from name of audio file
m4a = contains(audio, 'm4a');
if m4a == 1 
    filename = extractBetween(audio, "Audio/", ".m4a");
end

% plot highpass
plot(x, y, 'g');
% findpeaks(lps, Fs, 'MinPeakDistance', 0.4,'MinPeakProminence', 0.2);
titlename = strcat("Audio Peaks for ",filename);
title(titlename);
xlabel('Time (s)');

hold on
plot(x, hps, 'r');
hold off
%}
table = [y lps];

%{ 
% Plot audio values vs. time
plot(x,y)
findpeaks(y, Fs, 'MinPeakDistance', 0.5,'MinPeakProminence', 0.3);
% findpeaks(y, Fs, 'MinPeakProminence', 0.1);
titlename = strcat("Audio Peaks for ",filename);
title(titlename);
xlabel('Time (s)');
%}
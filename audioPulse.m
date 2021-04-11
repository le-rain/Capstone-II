% Call this function to find sections in audio with good consecutive peaks%

% Inputs:
% audio is name of audio files in this format: 'File/filename.ext'
% bpm is estimated BPM

% Outputs:
% sectionT is sections of audio in seconds
% sectionI is sections of audio in sample#
% Fs is sampling frequency

function [sectionT, sectionI, Fs] = audioPulse(audio, bpm)

% Read audio from video and find peaks
[audio, peaks, time, x, y, Fs, minDist] = findAudioPeaks(audio, bpm);

% Find start and stop of good peak sections
[sectionT] = findPeakSection(peaks, time);

[sectionI] = plotAudioSection(sectionT, audio, x, y, Fs, minDist);
end

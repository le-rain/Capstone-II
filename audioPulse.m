% Call this function to find sections in audio with good consecutive peaks
function [sectionI] = audioPulse(audio, bpm)

% Read audio from video and find peaks
[audio, peaks, time, x, y, Fs, minDist] = findAudioPeaks(audio, bpm);

% Find start and stop of good peak sections
[sectionT] = findPeakSection(peaks, time);

[sectionI] = plotAudioSection(sectionT, audio, x, y, Fs, minDist);
end

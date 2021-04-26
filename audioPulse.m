% Call this function to find sections in audio with good consecutive peaks%

% Inputs:
% audio is name of audio files in this format: 'File/filename.ext'
% channel: 0 for auto-choose, 1 or 2 for manual
% plotWholeAudioOption: 1 for plot of entire audio file, 0 for no plot
% plotAudioSectionOption: 1 for plotting sections with s1 and s2, 0 for no plots

% Outputs:
% sectionS2 is a cell array containing the good sections' s2 peaks
% Fs is sampling frequency
% audioData is audio data that has been squared

function [sectionI, sectionS2, allS2, Fs, audioData] = audioPulse(audio, channel, plotWholeAudioOption, plotAudioSectionOption)

% Read audio from video and find peaks
[name, peaks, nSamples, x, y, Fs, minDist, channel] = findAudioPeaks(audio, channel);

audioData = y;

% Find start and stop of good peak sections
[sectionI, iStart, iEnd] = findAudioSection(peaks, nSamples, Fs);

% Find s1 and s2 peaks
[allS1, allS2, sectionS1, sectionS2] = findS1S2peaks(iStart, iEnd, x, y, minDist);

% Plot audio sections with s1 and s2 peaks
plotAudioSection(allS1, allS2, sectionS1, sectionS2, iStart, iEnd, name, channel, x, y, minDist, plotWholeAudioOption, plotAudioSectionOption);


end

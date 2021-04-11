clear all; close all;

files = ["01 Testing Videos/LK-122-70-B-1.mp4", 80, 1;
         %"01 Testing Videos/LK-90-60-B-3.mp4", 80, 1;
         "01 Testing Videos/TP-130-82-B-1.mp4", 80, 1;
         "01 Testing Videos/kc-90-58-b-1.mp4", 80, 1];

size = size(files);
n_files = size(1);

section = cell(1,n_files);

for i = 1:n_files
    audio = convertStringsToChars(files(i,1));
    bpm = str2double(files(i,2));
    plotOption = str2double(files(i,3));
    [~,name,~] = fileparts(audio);
    [sectionT, ~, ~, ~, ~] = audioPulse(audio, bpm, plotOption);
    section{i} = sectionT;
end
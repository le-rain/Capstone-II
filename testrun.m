clear all; close all;

files = [%"01 Testing Videos/LK-B-01-122-70.mp4", 100, 1;
         %"01 Testing Videos/LK-B-02-116-64.mp4", 100, 1;
         %"01 Testing Videos/LK-B-03-90-60.mp4", 100, 1;
         %"01 Testing Videos/LK-B-04-90-60.mp4", 100, 1;     
         %"01 Testing Videos/LK-B-05-100-70.mp4", 100, 1;
         %"01 Testing Videos/LK-B-06-105-75.mp4", 100, 1;
         %"01 Testing Videos/LK-B-07-90-70.mp4", 100, 1;
         %"01 Testing Videos/LK-B-08-90-72.mp4", 100, 2; % terrible audio
         %"01 Testing Videos/LK-B-09-102-60.mp4", 100, 2;
         %"01 Testing Videos/LK-B-10-102-96.mp4", 100, 1;
         %"01 Testing Videos/kc-b-01-90-58.mp4", 100, 1;
         %"01 Testing Videos/kc-b-02-94-56.mp4", 100, 1;
         %"01 Testing Videos/kc-b-03-95-65.mp4", 100, 1;
         %"01 Testing Videos/kc-b-05-90-70.mp4", 100, 1, 1;
         %"01 Testing Videos/kc-b-06-90-70.mp4", 100, 1;
         %"01 Testing Videos/KC-B-12-104-78.mp4", 300, 0, 1;
         "01 Testing Videos/KC-B-13-102-58.mp4", 300, 1, 1;
         %"01 Testing Videos/KC-B-14-100-66.mp4", 300, 1, 1;
         %"01 Testing Videos/kc-h-01-126-66.mp4", 120, 0, 0;
         %"01 Testing Videos/kc-h-02-108-72.mp4", 300, 0, 0;
         
         %"01 Testing Videos/TP-B-1-130-82.mp4", 100, 1;
         
         %"01 Testing Videos/TP-H-02-130-60.mp4", 300, 0, 1;
         ];

size = size(files);
n_files = size(1);

section = cell(1, n_files);

for i = 1:n_files
    audio = convertStringsToChars(files(i,1));
    plotWholeAudioOption = str2double(files(i,2));
    plotAudioSectionOption = str2double(files(i,3));
    [sectionS2, ~, ~] = audioPulse(audio, plotWholeAudioOption, plotAudioSectionOption);
    section{i} = sectionS2;
end
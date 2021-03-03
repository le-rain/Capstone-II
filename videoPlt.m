 clear all; close all;
% plots videos 
% katelyn height changes 11 pro
% figure(2)
% ppg('Video/katelyn-heightchanges-11pro-1.mov');
% figure(3)
% ppg('Video/katelyn-heightchanges-5-1.mov');

%  % back flash
%  figure(5)
%  ppg('Video/kristin-7-back-flash-1.MOV');
%  figure(6)
%  ppg('Video/lorianne-7-back-flash-1.mov');
% back flash - low to high on shelf 
figure 
ppg('Video/kc-shelf.mov');
 
%  back no flash - low to high
%  figure(7)
%  ppg('Video/kristin-7-back-noflash-1.mov');
%  ppg('Video/lorianne-7-back-noflash-1.mov');
% 
% front - low to high
% figure(8)
% ppg('Video/lorianne-7-front-1.mov');
% figure(9)
% [subj2, framerate2, phone_ppg2] = ppg('Video/kristin-7-front-1.mov');

% front no flash, held to neck
% figure(1)
% ppg('Video/lorianne-1.mp4');
% figure(2)
% ppg('Video/katelyn-1.mov');
%figure
% phone_ppg3 = plot_ppg('Video/steady-front-1.mov');
% [subj, framerate, phone_ppg3] = get_ppg('Video/steady-front-1.mov');
% figure
%[subj, framerate, phone_ppg] = ppg('Video/sim-A.mov');
% [y,Fs_audio] = audioread('Video/sim-A.mp4');
% audiowrite('Audio/sim-A.WAV',y,Fs_audio);
% audiopeaks('Audio/sim-A.wav');

% videoFReader = vision.VideoFileReader('Video/sim-A.mov', 'AudioOutputPort', true);
% videoPlayer = vision.VideoPlayer;

figure;
red_lp = bandpass(phone_ppg{1},[0.1 0.2]);
plot(red_lp);
hold on;
plot(phone_ppg{1});
legend;

figure()
Fs = 30; 
findpeaks(phone_ppg{1}, Fs, 'MinPeakDistance', 0.4,'MinPeakProminence', 0.1);
title('Front Camera PPG', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Red Value')
xlabel('Time (s)');

% Get handle to current axes.
ax = gca
% Set x and y font sizes.
ax.XAxis.FontSize = 15;
ax.YAxis.FontSize = 15;
% Bold all labels.
ax.FontWeight = 'bold';
hold off;

% phone_ppg = cell2mat(phone_ppg3);
% ppg_sum = sum(phone_ppg);
% ppg_sum = sum(phone_ppg, 2);
% plot(ppg_sum);

function [subj, framerate, phone_ppg] = get_ppg(vid)
workspace;

[subj, framerate] = readVideo(vid);

phone_ppg{1} = videoToPPG(subj{1}, framerate);
phone_ppg{2} = videoToPPG(subj{2}, framerate);
phone_ppg{3} = videoToPPG(subj{3}, framerate);

end

% plots ppg video with separate R,G,B plots
function [phone_ppg] = plot_ppg(vid)
[subj, framerate, phone_ppg] = get_ppg(vid);

mp4 = contains(vid, 'mp4');
if mp4 == 1 
    filename = extractBetween(vid, "Video/", ".mp4");
else
    filename = extractBetween(vid, "Video/", ".mov");
end

% plot ppg channels on different figure
% close all
Fs = 30;
samples = 1:length(phone_ppg{1});
t = samples/Fs;
% subplot(3,1,1)
plot(t, phone_ppg{1});
hold on;
titlename = strcat("Red Values for ",filename);
title(titlename);
xlabel('Time(s)');
ylabel('Norm. RGB Value');

% subplot(3,1,2)
plot(t, phone_ppg{2})
% titlename = strcat("Green Values for ",filename);
% title(titlename);
% xlabel('Time(s)');
% ylabel('Norm. RGB Value');

% subplot(3,1,3)
plot(t, phone_ppg{3})
% titlename = strcat("Blue Values for ",filename);
% title(titlename);
% xlabel('Time(s)');
% ylabel('Norm. RGB Value');
hold off
end

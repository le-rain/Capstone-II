close all;
% plots videos 
% katelyn height changes 11 pro
% figure(2)
% ppg('Video/katelyn-heightchanges-11pro-1.mov');
% figure(3)
% ppg('Video/katelyn-heightchanges-5-1.mov');

% front no flash, held to neck
% figure(1)
%ppg('Video/lorianne-1.mp4');
% figure(2)
% ppg('Video/katelyn-1.mov');
% figure
% [subj, framerate] = ppg('Video/steady-front-1.mov');
figure
Fs = 30;
[subj, framerate, phone_ppg] = ppg('Video/steady-front-3.mov');
findpeaks(phone_ppg{1}, Fs, 'MinPeakDistance', 0.6,'MinPeakProminence', 0.1);

%  % back flash
%  figure(5)
%  ppg('Video/kristin-7-back-flash-1.MOV');
%  figure(6)
%  ppg('Video/lorianne-7-back-flash-1.mov');
 
%  % back no flash
%  figure(7)
%  ppg('Video/kristin-7-back-noflash-1.mov');
%  ppg('Video/lorianne-7-back-noflash-1.mov');
% 
%  % front
%  figure(8)
%  ppg('Video/lorianne-7-front-1.mov');
%  figure(9)
%  ppg('Video/kristin-7-front-1.mov');

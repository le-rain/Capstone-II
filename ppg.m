% accepts string with video file name and returns framerate variable
function [subj, framerate, phone_ppg] = ppg(vid)
workspace;
mp4 = contains(vid, 'mp4');

[subj, framerate] = readVideo(vid);

if mp4 == 1 
    filename = extractBetween(vid, "Video/", ".mp4");
else
    filename = extractBetween(vid, "Video/", ".mov");
end

phone_ppg{1} = videoToPPG(subj{1}, framerate);
phone_ppg{2} = videoToPPG(subj{2}, framerate);
phone_ppg{3} = videoToPPG(subj{3}, framerate);

% plot ppg channels on different figure
% close all
Fs = 30;
samples = 1:length(phone_ppg{1});
t = samples/Fs;
subplot(3,1,1)
plot(t, phone_ppg{1});
titlename = strcat("Red Values for ",filename);
title(titlename);
xlabel('Time(s)');
ylabel('Norm. RGB Value');

subplot(3,1,2)
plot(t, phone_ppg{2})
titlename = strcat("Green Values for ",filename);
title(titlename);
xlabel('Time(s)');
ylabel('Norm. RGB Value');

subplot(3,1,3)
plot(t, phone_ppg{3})
titlename = strcat("Blue Values for ",filename);
title(titlename);
xlabel('Time(s)');
ylabel('Norm. RGB Value');

end 
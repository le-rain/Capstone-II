% accepts string with video file name and returns framerate variable

function framerate = ppg(vid)
mp4 = contains(vid, 'mp4');

if mp4 == 1 
    filename = extractBetween(vid, "Video/", ".mp4");
else
    filename = extractBetween(vid, "Video/", ".mov");
end

[subj, framerate] = readVideo(vid);

phone_ppg{1} = videoToPPG(subj{1}, framerate);
phone_ppg{2} = videoToPPG(subj{2}, framerate);
phone_ppg{3} = videoToPPG(subj{3}, framerate);

% plot ppg channels on different figure
% close all
subplot(3,1,1)
plot(phone_ppg{1})
titlename = strcat("Red Values for ",filename);
title(titlename);
xlabel('Sample #');
ylabel('RGB Value');

subplot(3,1,2)
plot(phone_ppg{2})
titlename = strcat("Green Values for ",filename);
title(titlename);
xlabel('Sample #');
ylabel('RGB Value');

subplot(3,1,3)
plot(phone_ppg{3})
titlename = strcat("Green Values for ",filename);
title(titlename);
xlabel('Sample #');
ylabel('RGB Value');

end 
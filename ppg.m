% kristin made a change

% accepts string with video file name and returns framerate variable
function framerate = ppg(vid)

[subj, framerate] = readVideo(vid);

phone_ppg{1} = videoToPPG(subj{1}, framerate);
phone_ppg{2} = videoToPPG(subj{2}, framerate);
phone_ppg{3} = videoToPPG(subj{3}, framerate);

% plot ppg channels on different figures
close all
plot(phone_ppg{1})
figure
plot(phone_ppg{2})
figure
plot(phone_ppg{3})

% lorianne made a change

%creates PPG with optimal ROI (determined by TD) from optimal channel
%(determined by TM); returns PPG and corresponding time vector in seconds
function [ppg_tm,time] = videoToPPGTM(video,channel,i,j,roiHeight,roiWidth,frameRate)
    video_roi = video{channel}(((i-1)*roiHeight+1):(i*roiHeight),((j-1)*roiWidth+1):(j*roiWidth),:);
    ppg_tm = squeeze(sum(sum(video_roi)));
    ppg_tm = ppg_tm - mean(ppg_tm);
    
    ppg_tm(abs(ppg_tm) > 4*std(ppg_tm)) = 0; %remove large values

    hF = 0.5 * frameRate;

    d = designfilt('bandpassiir', ... 
     'StopbandFrequency1',0.03*hF,'PassbandFrequency1', 0.05*hF, ...
     'PassbandFrequency2',0.5*hF,'StopbandFrequency2', 0.55*hF, ...
     'StopbandAttenuation1',1,'PassbandRipple', 0.5, ...
     'StopbandAttenuation2',1, ...
     'DesignMethod','butter','SampleRate', frameRate);
     ppg_tm = filtfilt(d, (ppg_tm - mean(ppg_tm))/std(ppg_tm));
     
     time = [1:length(ppg_tm)] ./ frameRate; %generate time vector

end
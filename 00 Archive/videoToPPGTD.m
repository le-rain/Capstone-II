%converts section of video where ROI was identified to PPG
function ppg = videoToPPGTD(video,roi,i,j,roiHeight,roiWidth,frameRate)
    video_roi = video{roi}(((i-1)*roiHeight+1):(i*roiHeight),((j-1)*roiWidth+1):(j*roiWidth),:);
    ppg = squeeze(sum(sum(video_roi)));
    ppg = ppg - mean(ppg);
    
    %ppg(find(abs(ppg) > 4*std(ppg))) = 0; %remove large values

    hF = 0.5 * frameRate;

    d = designfilt('bandpassiir', ... 
     'StopbandFrequency1',0.03*hF,'PassbandFrequency1', 0.05*hF, ...
     'PassbandFrequency2',0.5*hF,'StopbandFrequency2', 0.55*hF, ...
     'StopbandAttenuation1',1,'PassbandRipple', 0.5, ...
     'StopbandAttenuation2',1, ...
     'DesignMethod','butter','SampleRate', frameRate);
     ppg = filtfilt(d, (ppg - mean(ppg))/std(ppg));

end
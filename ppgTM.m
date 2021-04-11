%uses TM to identify the best channel (red or green)
%uses TD to identify optimal ROI from best channel
%uses TM to identify best sections of signal 
function [ppg_tm,height,width,time,frameRate,channel,template_type,template_resampled_scaled,template_resampled_rev_scaled,i,j,ppg_sections] = ppgTM(file)
    [video,fileName,height,width,roiHeight,roiWidth,frameRate] = readVideoTM(file); %read video
    [~,channel,template_type,template_resampled_scaled,template_resampled_rev_scaled] = selectSignalTM(video,frameRate); %choose best channel based on template matching
    TD = mapTM(video,channel,height,width,frameRate); %calculate temporal differences from best channel
    [splitTD,roiHeight,roiWidth] = splitVideoTM(TD,height,width,roiHeight,roiWidth); %split video into blocks
    [i,j] = selectROITM(splitTD); %choose best ROI using temporal differences
    [ppg_tm,time] = videoToPPGTM(video,channel,i,j,roiHeight,roiWidth,frameRate); %create PPG based on best section from best channel
    plotPPGTM(fileName,ppg_tm,time,channel,roiHeight,roiWidth) %plot PPG
    
    %find and plot best sections of PPG
    [istart,istop] = findWavesTM(ppg_tm,frameRate,channel,template_type,template_resampled_scaled,template_resampled_rev_scaled);
    [~,ppg_sections] = identifySectionsTM(istart,istop);
    %plotSectionsTM(time,ppg_tm,ppg_sections)
end
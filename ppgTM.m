function [ppg_tm, time, frameRate, channel, template_type, template_resampled, template_resampled_rev, i, j] = ppgTM(file, roiHeight, roiWidth)
    [video, height, width, frameRate] = readVideoTM(file); %read video
    [~,channel,template_type,template_resampled,template_resampled_rev] = selectSignalTM(video,frameRate);
    TD = mapTM(video, channel, height, width, frameRate);
    [splitTD, roiHeight, roiWidth] = splitVideoTM(TD, height, width, roiHeight, roiWidth);
    [i,j] = selectROITM(splitTD);
    ppg_tm = videoToPPGTM(video,channel,i,j,roiHeight,roiWidth,frameRate);
    
    %plot PPG
    time = [1:length(ppg_tm)] ./ frameRate; %generate time vector
    figure %create new figure
    plot(time,ppg_tm)
    title(file) 
    xlabel('Time (s)')
    if (channel == 1)
        ylabel('PPG (a.u.) - Red Values')
    elseif (channel == 2)
        ylabel('PPG (a.u.) - Green Values')
    end
end
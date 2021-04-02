function [ppg_tm, time, frameRate, channel, template_type, i, j] = ppgTM(file, roiHeight, roiWidth)
    [video, height, width, frameRate] = readVideoTM(file); %read video
    [~,channel,template_type,~,~] = selectSignalTM(video,frameRate);
    TD = mapTM(video, channel, height, width, frameRate);
    [splitTD, roiHeight, roiWidth] = splitVideoTM(TD, height, width, roiHeight, roiWidth);
    [i,j] = selectROITM(splitTD);
    ppg_tm = videoToPPGTM(video,channel,i,j,roiHeight,roiWidth,frameRate);
    
    %plot PPG
    time = [1:length(ppg_t)] ./ frameRate; %generate time vector
    figure %create new figure
    plot(time,ppg_tm)
    title(file) 
    xlabel('Time (s)')
    if (roi == 1)
        ylabel('PPG (a.u.) - Red Values')
    elseif (roi == 2)
        ylabel('PPG (a.u.) - Green Values')
    end
end
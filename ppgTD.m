function ppg_td = ppgTD(file, roiHeight, roiWidth)

    [video, height, width, frameRate] = readVideoTD(file);
    [redTD, greenTD] = mapTD(video, height, width, frameRate);
    [red, green, roiHeight, roiWidth] = splitVideoTD(redTD, greenTD, height, width, roiHeight, roiWidth);
    [roi,i,j] = selectRegionTD(red, green);
    ppg = videoToPPGTD(video,roi,i,j,roiHeight,roiWidth,frameRate);
    
    %plot PPG
    time = [1:length(ppg)] ./ frameRate; %generate time vector
    figure %create new figure
    plot(time,ppg)
    title(file) 
    xlabel('Time (s)')
    ylabel('PPG (a.u.)')
end
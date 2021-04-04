%plots PPG generated from combination of TM and TD 
%returns corresponding time vector in seconds
function time = plotPPGTM(fileName,ppg_tm,frameRate,channel,roiHeight,roiWidth)
    time = [1:length(ppg_tm)] ./ frameRate; %generate time vector
    figure %create new figure
    plot(time,ppg_tm)
    titleName = strcat(fileName, " - TM - ", int2str(roiHeight), "x", int2str(roiWidth), " ROI")
    title(titleName) 
    xlabel('Time (s)')
    if (channel == 1)
        ylabel('PPG (a.u.) - Red Values')
    elseif (channel == 2)
        ylabel('PPG (a.u.) - Green Values')
    end
end
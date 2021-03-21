%accepts video file and desired ROI height and width in pixels
%returns PPG, time vector, frame rate, ROI channel, and ROI indices with
%respect to original video frame
%roi = 1 for red channel and roi = 2 for green channel
function [ppg_td, time, frameRate, roi, i, j] = ppgTD(file, roiHeight, roiWidth)
    [video, height, width, frameRate] = readVideoTD(file); %read video
    [redTD, greenTD] = mapTD(video, height, width, frameRate); %calculate temporal differences
    [red, green, roiHeight, roiWidth] = splitVideoTD(redTD, greenTD, height, width, roiHeight, roiWidth); %split TD arrays into ROI blocks
    [roi,i,j] = selectRegionTD(red, green); %select best ROI
    ppg_td = videoToPPGTD(video,roi,i,j,roiHeight,roiWidth,frameRate); %plot ROI over duration of video
    
    %plot PPG
    time = [1:length(ppg_td)] ./ frameRate; %generate time vector
    figure %create new figure
    plot(time,ppg_td)
    title(file) 
    xlabel('Time (s)')
    if (roi == 1)
        ylabel('PPG (a.u.) - Red Values')
    elseif (roi == 2)
        ylabel('PPG (a.u.) - Green Values')
    end
end
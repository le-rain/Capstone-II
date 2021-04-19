%plots PPG generated from combination of TM and TD 
function plotPPGTM(fileName,ppg_tm,time,channel,roiHeight,roiWidth)
    figure %create new figure
    plot(time,ppg_tm)
    titleName = strcat(fileName, " - TM - ", int2str(roiHeight), "x", int2str(roiWidth), " ROI");
    title(titleName, 'FontSize', 18, 'FontWeight', 'bold') 
    xlabel('Time (s)')
    if (channel == 1)
        ylabel('PPG (a.u.) - Red Values')
    elseif (channel == 2)
        ylabel('PPG (a.u.) - Green Values')
    end
    ax = gca; 
    ax.XAxis.FontSize = 15;
    ax.YAxis.FontSize = 15;
end
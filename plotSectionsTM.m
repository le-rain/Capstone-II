%plot best sections of PPG as identified by identifySectionsTM
function plotSectionsTM(time,ppg_tm,section_indices)
    for i = 1:length(section_indices) %for every section 
        figure %create new figure
        plot(time(section_indices(i,1):section_indices(i,2)), ppg_tm(section_indices(i,1):section_indices(i,2)))
        xlabel('Time (s)')
        ylabel('PPG (a.u.)')
        titlename = strcat("Section ", int2str(i)); %title "Section n"
        title(titlename)
    end
end
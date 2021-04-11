%plot best sections of PPG as identified by identifySectionsTM only if they
%are at least 100 samples long; returns ppg_sections as the start and stop
%indices only of those sections at least 100 samples long
function plotSectionsTM(time,ppg_tm,ppg_sections) 
    for i = 1:length(ppg_sections) %for every section  
        figure %create new figure
        plot(time(ppg_sections(i,1):ppg_sections(i,2)), ppg_tm(ppg_sections(i,1):ppg_sections(i,2)))
        xlabel('Time (s)')
        ylabel('PPG (a.u.)')
        titlename = strcat("Section ", int2str(i)); %title "Section n"
        title(titlename)
    end
end
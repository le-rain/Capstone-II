%plot best sections of PPG as identified by identifySectionsTM only if they
%are at least 100 samples long; returns ppg_sections as the start and stop
%indices only of those sections at least 100 samples long
function ppg_sections = plotSectionsTM(time,ppg_tm,section_indices)
    ppg_sections = zeros(1,2);
    j = 1; 
    for i = 1:length(section_indices) %for every section 
        if abs(section_indices(i,2) - section_indices(i,1)) >= 100
            figure %create new figure
            plot(time(section_indices(i,1):section_indices(i,2)), ppg_tm(section_indices(i,1):section_indices(i,2)))
            xlabel('Time (s)')
            ylabel('PPG (a.u.)')
            titlename = strcat("Section ", int2str(i)); %title "Section n"
            title(titlename)
            %add to ppg_sections
            ppg_sections(j,1) = section_indices(i,1);
            ppg_sections(j,2) = section_indices(i,2);
            j = j + 1;
        end
    end
end
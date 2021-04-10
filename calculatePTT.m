%integrates ppgTM and audioPlot to calculate PTT from best sections of both
%signals
function section_overlap = calculatePTT(ppg_sections,audio_sections)
    section_overlap = zeros(1,2);
    k = 1;
    %find overlap between ppg_sections and audio_sections
    for i = 1:length(ppg_sections)
        for j = 1:length(audio_sections)
            if ppg_sections(i,2) > audio_sections(j,1) && ppg_sections(i,1) < audio_sections(j,1) && ppg_sections(i,2) <= audio_sections(j,2) 
                section_overlap(k,1) = audio_sections(j,1);
                section_overlap(k,2) = ppg_sections(i,2);
                k = k + 1;
            elseif audio_sections(j,2) > ppg_sections(i,1) && audio_sections(j,1) < ppg_sections(i,1) && audio_sections(j,2) <= ppg_sections(i,2) 
                section_overlap(k,1) = ppg_sections(i,1);
                section_overlap(k,2) = audio_sections(j,2);
                k = k + 1;     
            elseif ppg_sections(i,2) > audio_sections(j,1) && ppg_sections(i,1) < audio_sections(j,1) && ppg_sections(i,2) > audio_sections(j,2)
                section_overlap(k,1) = audio_sections(j,1);
                section_overlap(k,2) = audio_sections(j,2);
                k = k + 1;
            elseif audio_sections(j,2) > ppg_sections(i,1) && audio_sections(j,1) < ppg_sections(i,1) && audio_sections(j,2) > ppg_sections(i,2) 
                section_overlap(k,1) = ppg_sections(i,1);
                section_overlap(k,2) = ppg_sections(i,2);
                k = k + 1;     
            elseif ppg_sections(i,2) < audio_sections(j,2) && ppg_sections(i,1) > audio_sections(j,1)
                section_overlap(k,1) = ppg_sections(i,1);
                section_overlap(k,2) = ppg_sections(i,2);
                k = k + 1;
            elseif audio_sections(j,2) < ppg_sections(i,2) && audio_sections(j,1) > ppg_sections(i,1)
                section_overlap(k,1) = audio_sections(j,1);
                section_overlap(k,2) = audio_sections(j,2);
                k = k + 1;
            end
        end
    end
    %find locations of ppg peaks
    %find locations of audio peaks
    %calculate ptt
end
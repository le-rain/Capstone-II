%integrates ppgTM and audioPulse to calculate PTT from best sections of 
%both signals
function [section_overlap,ppg_locs,audio_locs,ptt] = calculatePTT(ppg_sections,sectionI,ppg_tm,audioData,frameRate,Fs)
    [p,q] = rat(frameRate/Fs); %factor for converting between video and audio sampling frequencies
    audio_sections = round(sectionI.*p./q); %resample audio indices 
    audio_data = resample(audioData,p,q); %resample audio data
    
    section_overlap = zeros(max(length(ppg_sections),length(audio_sections)),2);
    k = 0;
    %find indices of overlap(s) between ppg_sections and audio_sections
    for i = 1:size(ppg_sections,1)
        for j = 1:size(audio_sections,1)
            if ppg_sections(i,2) > audio_sections(j,1) && ppg_sections(i,1) < audio_sections(j,1) && ppg_sections(i,2) <= audio_sections(j,2) 
                k = k + 1;
                section_overlap(k,1) = audio_sections(j,1);
                section_overlap(k,2) = ppg_sections(i,2); 
            elseif audio_sections(j,2) > ppg_sections(i,1) && audio_sections(j,1) < ppg_sections(i,1) && audio_sections(j,2) <= ppg_sections(i,2) 
                k = k + 1;
                section_overlap(k,1) = ppg_sections(i,1);
                section_overlap(k,2) = audio_sections(j,2);
            elseif ppg_sections(i,2) > audio_sections(j,1) && ppg_sections(i,1) < audio_sections(j,1) && ppg_sections(i,2) > audio_sections(j,2)
                k = k + 1;
                section_overlap(k,1) = audio_sections(j,1);
                section_overlap(k,2) = audio_sections(j,2);
            elseif audio_sections(j,2) > ppg_sections(i,1) && audio_sections(j,1) < ppg_sections(i,1) && audio_sections(j,2) > ppg_sections(i,2) 
                k = k + 1;
                section_overlap(k,1) = ppg_sections(i,1);
                section_overlap(k,2) = ppg_sections(i,2);
            elseif ppg_sections(i,2) < audio_sections(j,2) && ppg_sections(i,1) > audio_sections(j,1)
                k = k + 1;
                section_overlap(k,1) = ppg_sections(i,1);
                section_overlap(k,2) = ppg_sections(i,2);
            elseif audio_sections(j,2) < ppg_sections(i,2) && audio_sections(j,1) > ppg_sections(i,1)
                k = k + 1;
                section_overlap(k,1) = audio_sections(j,1);
                section_overlap(k,2) = audio_sections(j,2);
            end
        end
    end
    
    ppg_locs = cell(1,1);
    audio_locs = cell(1,1);
    ptt = cell(1,1);
    for i = 1:length(section_overlap)
        %find locations of ppg peaks
        [~,ppg_locs{i,1}] = findpeaks(ppg_tm(section_overlap(i,1):(section_overlap(i,2))),'MinPeakDistance',15); 
        %find locations of audio peaks
        [~,audio_locs{i,1}] = findpeaks(audio_data(section_overlap(i,1):(section_overlap(i,2))),'MinPeakDistance',15); 
        %calculate ptt
        ptt{i,1} = mean(abs(ppg_locs{i} - audio_locs{i}))/frameRate;
    end
    ptt = mean(cell2mat(ptt)); %average all PTTs (if multiple were calculated)
end
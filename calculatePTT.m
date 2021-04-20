%integrates ppgTM and audioPulse to calculate PTT from best sections of 
%both signals
function [audio_sections,audio_data,section_overlap,ppg_locs,audio_locs,all_S2,ptt_calc,ppg_amp] = calculatePTT(ppg_tm,audioData,ppg_sections,sectionI,allS2,frameRate,Fs)
    [p,q] = rat(frameRate/Fs); %factor for converting between video and audio sampling frequencies
    audio_sections = round(sectionI.*p./q); %resample audio indices 
    audio_data = resample(audioData,p,q); %resample audio data
    allS2n_resampled = round(allS2(:,1).*p./q);
    all_S2 = [allS2n_resampled, allS2(:,2)];
    
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
    
    %remove overlaps less than 2 seconds
    for i = 1:length(section_overlap)
        if abs(section_overlap(i,2) - section_overlap(i,1)) < round(frameRate*2)
            section_overlap(i,:) = [0 0]; %set to zero   
        end
    end
    section_overlap = nonzeros(section_overlap); %get nonzero values
    section_overlap = reshape(section_overlap,[length(section_overlap)/2,2]); %reshape to nx2 matrix
    
    ppg_tm(abs(ppg_tm) > 4*std(ppg_tm)) = 0; %remove large values
    ppg_sorted = sort(ppg_tm); %sort ppg values from smallest to largest
    ppg_max = ppg_sorted(end-26:end-15); %values from large end
    ppg_min = ppg_sorted(15:25); %values from small end
    ppg_amp = mean(ppg_max) - mean(ppg_min); %estimate amplitude
    
    ppg_locs = cell(1,1);
    audio_locs = cell(1,1);
    ptt_calc = cell(1,1);
    
    for i = 1:size(section_overlap,1)
        %find locations of ppg peaks
        [~,ppg_locs{i,1}] = findpeaks(ppg_tm(section_overlap(i,1):(section_overlap(i,2))),'MinPeakDistance',15,'MinPeakHeight',ppg_amp*.25);
        ppg_locs{i,1} = ppg_locs{i,1} + section_overlap(i,1);
        %find locations of audio peaks
        audio_locs_indices = find(all_S2 >= section_overlap(i,1) & all_S2 <= section_overlap(i,2)); 
        audio_locs{i,1} = all_S2(audio_locs_indices);
        %calculate ptt
        if length(ppg_locs{i,1}) > length(audio_locs{i,1}) %if number of peaks are unequal 
            if ppg_locs{i,1}(1) - audio_locs{i,1}(1) < 0
                ppg_locs{i,1}(1) = [];
            else
                ppg_locs{i,1}(end) = [];
            end
        elseif length(ppg_locs{i,1}) < length(audio_locs{i,1})
            if ppg_locs{i,1}(1) - audio_locs{i,1}(1) < 0
                ppg_locs{i,1}(1) = [];
                audio_locs{i,1}(end) = [];
                audio_locs{i,1}(end) = [];
            else
                audio_locs{i,1}(end) = [];
            end
        else 
            if ppg_locs{i,1}(1) - audio_locs{i,1}(1) < 0
                ppg_locs{i,1}(1) = [];
                audio_locs{i,1}(end) = [];               
            end
        end
        ptt_calc{i,1} = mean(ppg_locs{i} - audio_locs{i})/frameRate;
    end
    %ptt = mean(cell2mat(ptt_calc)); %average all PTTs (if multiple were calculated)
end
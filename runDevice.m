function [ppg_tm,audio_data,time,ppg_sections,audio_sections,section_overlap,ppg_locs,audio_locs,ptt] = runDevice(file)
    [ppg_tm,~,~,time,frameRate,~,~,~,~,~,~,ppg_sections] = ppgTM(file);
    [~,sectionI,Fs,audioData,~] = audioPulse(file,100,1);
    [audio_sections,audio_data,section_overlap,ppg_locs,audio_locs,ptt] = calculatePTT(ppg_tm,audioData,ppg_sections,sectionI,frameRate,Fs);
end
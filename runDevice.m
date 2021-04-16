function [ppg_tm,audio_data,frameRate,time,ppg_sections,audio_sections,section_overlap,ppg_locs,audio_locs] = runDevice(file)
    [ppg_tm,~,~,time,frameRate,~,~,~,~,~,~,ppg_sections] = ppgTM(file);
    [sectionI, ~, Fs, audioData] = audioPulse(file, 1, 0);
    [audio_sections,audio_data,section_overlap,ppg_locs,audio_locs,~] = calculatePTT(ppg_tm,audioData,ppg_sections,sectionI,frameRate,Fs);
end
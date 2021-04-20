function [ppg_tm,audio_data,frameRate,time,ppg_sections,audio_sections,section_overlap,ppg_locs,audio_locs,all_S2,ptt_calc,ppg_amp] = runDevice(file)
    [ppg_tm,~,~,time,frameRate,~,~,~,~,~,~,ppg_sections] = ppgTM(file);
    [sectionI, ~, allS2, Fs, audioData] = audioPulse(file, 0, 0, 1);
    [audio_sections,audio_data,section_overlap,ppg_locs,audio_locs,all_S2,ptt_calc,ppg_amp] = calculatePTT(ppg_tm,audioData,ppg_sections,sectionI,allS2,frameRate,Fs)
end
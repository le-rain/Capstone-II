%applies findsignal to TM PPG using correct template type (normal or reversed)
%returns sorted istart and istop vectors after finding best MaxNumSegments number of waveforms
%TO DO: define MaxNumSegments based on length of signal 
function [istart,istop] = findWavesTM(ppg_tm,frameRate,channel,template_type,template_resampled,template_resampled_rev_scaled)
    duration = length(ppg_tm)/frameRate; %length of signal in seconds
    peak_estimate = (duration/60) * 80; %assume average heart rate of 80 for now
    num_segments = round(peak_estimate/2); %take best 50% of peaks
    if template_type == 1
        [istart,istop] = findsignal(ppg_tm,template_resampled{channel},'MaxNumSegments',num_segments);
    else
        [istart,istop] = findsignal(ppg_tm,template_resampled_rev_scaled{channel},'MaxNumSegments',num_segments);
    end
    
    istart = sort(istart);
    istop = sort(istop);
end
%applies findsignal to TM PPG using correct template type (normal or reversed)
%returns sorted istart and istop vectors after finding best MaxNumSegments number of waveforms
%TO DO: define MaxNumSegments based on length of signal 
function [istart,istop] = findWavesTM(ppg_tm,channel,template_type,template_resampled,template_resampled_rev_scaled)
    if template_type == 1
        [istart,istop] = findsignal(ppg_tm,template_resampled{channel},'MaxNumSegments',25);
    else
        [istart,istop] = findsignal(ppg_tm,template_resampled_rev_scaled{channel},'MaxNumSegments',25);
    end
    
    istart = sort(istart);
    istop = sort(istop);
end
function [istart,istop] = selectRegionTM(ppg_tm,template_type,template_resampled,template_resampled_rev)
    if template_type == 1
        [istart,istop] = findsignal(ppg_tm,template_resampled,'MaxNumSegments',25);
    else
        [istart,istop] = findsignal(ppg_tm,template_resampled_rev,'MaxNumSegments',25);
    end
    
    istart = sort(istart);
    istop = sort(istop);
end
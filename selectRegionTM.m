function [istart,istop] = selectRegionTM(ppg,channel,template_type,template_resampled,template_resampled_rev)
    if template_type == 1
        [istart,istop] = findsignal(ppg{channel},template_resampled,'MaxNumSegments',10);
    else
        [istart,istop] = findsignal(ppg{channel},template_resampled_rev,'MaxNumSegments',10);
    end
end
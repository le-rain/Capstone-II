%receives video and converts to red and green PPG
%returns PPG with optimal channel and template type
%channel = 1 for red channel, 2 for green channel
%template_type = 1 for regular template, 2 for reversed template
%TO DO: adjust template based on heart rate, amplitude
function [ppg,channel,template_type,template_resampled_scaled,template_resampled_rev_scaled] = selectSignalTM(video,frameRate)
    template = readmatrix('ppg_template.csv');
    template = template + abs(min(template)); %make it all positive
    template_rev = template(end:-1:1);
    
    Fs_template = 300; %template is from CapnoBase with 300 Hz sampling frequency
    Fs_ppg = frameRate; %phone sampling frequency
    [p,q] = rat(Fs_ppg/Fs_template);
    template_resampled = resample(template,p,q); %resample template
    template_resampled_rev = template_resampled(end:-1:1);
    
    ppg{1} = squeeze(sum(sum(video{1})));
    ppg{2} = squeeze(sum(sum(video{2})));
    
    %preliminary filter so PPG channels can be analyzed better
    hF = 0.5 * frameRate;
    d = designfilt('bandpassiir', ... 
     'StopbandFrequency1',0.03*hF,'PassbandFrequency1', 0.05*hF, ...
     'PassbandFrequency2',0.5*hF,'StopbandFrequency2', 0.55*hF, ...
     'StopbandAttenuation1',1,'PassbandRipple', 0.5, ...
     'StopbandAttenuation2',1, ...
     'DesignMethod','butter','SampleRate', frameRate);
 
    dist = cell(2,2); %preallocate space for cell array
    template_resampled_scaled = cell(2,1);
    template_resampled_rev_scaled = cell(2,1);
    for i = [1 2] %for both red and green PPG channels
        ppg{i} = ppg{i} - mean(ppg{i}); %center values
        ppg{i}(abs(ppg{i}) > 4*std(ppg{i})) = 0; %remove large values
        ppg{i} = filtfilt(d, (ppg{i} - mean(ppg{i}))/std(ppg{i})); %apply filter
        ppg_sorted = sort(ppg{i}); %sort ppg values from smallest to largest
        ppg_max = ppg_sorted(end-5:end); %largest 6 values
        ppg_min = ppg_sorted(1:6); %smallest 6 values
        ppg_amp = mean(ppg_max) - mean(ppg_min); %estimate amplitude
        template_resampled_scaled{i} = template_resampled * (ppg_amp / max(template_resampled));  %scale template based on estimated amplitude
        template_resampled_rev_scaled{i} = template_resampled_scaled{i}(end:-1:1); %reverse resampled and scaled template
        [~,~,dist{i,1}] = findsignal(ppg{i},template_resampled_scaled{i},'MaxNumSegments',5); %find 5 best matches for template
        [~,~,dist{i,2}] = findsignal(ppg{i},template_resampled_rev_scaled{i},'MaxNumSegments',5); %find 5 best matches for reversed template
        dist{i,1} = mean(dist{i,1}); %replace dist vector returned from findsignal with mean of distances
        dist{i,2} = mean(dist{i,2}); %replace dist vector with mean
    end
    
    dist = cell2mat(dist); %convert to matrix
    min_dist = min(min(dist)); %find smallest mean aka most similar match between channels and templates
    [channel,template_type] = find(dist==min_dist); %get indices which correspond to most similar channel, template type
end

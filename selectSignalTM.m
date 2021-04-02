%channel = 1 for red channel, 2 for green channel
%template_type = 1 for regular template, 2 for reversed template
function [ppg,channel,template_type,template_resampled,template_resampled_rev] = selectSignalTM(video,frameRate)
    template = readmatrix('ppg_template.csv');
    template_rev = template(end:-1:1);
    
    Fs_template = 300;
    Fs_ppg = frameRate;
    [p,q] = rat(Fs_ppg/Fs_template);
    template_resampled = resample(template,p,q);
    template_resampled_rev = template_resampled(end:-1:1);
    
    ppg{1} = squeeze(sum(sum(video{1})));
    ppg{2} = squeeze(sum(sum(video{2})));
    
    hF = 0.5 * frameRate;

    d = designfilt('bandpassiir', ... 
     'StopbandFrequency1',0.03*hF,'PassbandFrequency1', 0.05*hF, ...
     'PassbandFrequency2',0.5*hF,'StopbandFrequency2', 0.55*hF, ...
     'StopbandAttenuation1',1,'PassbandRipple', 0.5, ...
     'StopbandAttenuation2',1, ...
     'DesignMethod','butter','SampleRate', frameRate);
    
    for i = [1 2]
        ppg{i} = ppg{i} - mean(ppg{i}); %center values
        %ppg{i}(find(abs(ppg{i}) > 4*std(ppg{i}))) = 0; %remove large values
        ppg{i} = filtfilt(d, (ppg{i} - mean(ppg{i}))/std(ppg{i}));
        [~,~,dist{i,1}] = findsignal(ppg{i},template_resampled,'MaxNumSegments',5);
        [~,~,dist{i,2}] = findsignal(ppg{i},template_resampled_rev,'MaxNumSegments',5);
        dist{i,1} = mean(dist{i,1}); %replace with mean of distances
        dist{i,2} = mean(dist{i,2}); %replace with mean of distances
    end
    
    dist = cell2mat(dist); %convert to matrix
    min_dist = min(min(dist)); 
    [channel,template_type] = find(dist==min_dist); %get indices of most similar
end

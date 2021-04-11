function [sectionI] = plotAudioSection(sectionT, audio, x, y, Fs, minDist)

[~,name,~] = fileparts(audio);

sectionI = sectionT.*Fs;
istart = round(sectionI(:,1));
iend = round(sectionI(:,2));

if numel(sectionI) == 2
    time = x(istart:iend);
    values = y(istart:iend);
    plot(time, values)
    findpeaks(values, Fs, 'MinPeakDistance', minDist)
    xlabel('Time (s)');
    ylabel('Relative Sound Amplitude');
    titlename = strcat("Section for ", name);
    title(titlename, 'FontSize', 15, 'FontWeight', 'bold');
    ax = gca; 
    ax.XAxis.FontSize = 10;
    ax.YAxis.FontSize = 10;
    ax.FontWeight = 'bold';   
elseif numel(sectionI) > 2
    for i = 1:length(sectionI) %for every section 
            figure %create new figure
            time = x(istart(i):iend(i));
            values = y(istart(i):iend(i));
            plot(time, values)
            findpeaks(values, Fs, 'MinPeakDistance', minDist)
            xlabel('Time (s)');
            ylabel('Relative Sound Amplitude');
            titlename = strcat("Section ", int2str(i), " for ", name); %title "Section n"
            title(titlename, 'FontSize', 15, 'FontWeight', 'bold');
            ax = gca; 
            ax.XAxis.FontSize = 10;
            ax.YAxis.FontSize = 10;
            ax.FontWeight = 'bold';    
     end
end

end

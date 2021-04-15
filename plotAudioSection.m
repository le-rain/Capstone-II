function plotAudioSection(sectionS1, sectionS2, iStart, iEnd, name, y, Fs, minDist, plotWholeAudioOption, plotAudioSectionOption)

minDist = minDist / Fs;

if plotWholeAudioOption == 1 % choose this option to plot the whole audio file 
    
    sectionValue = y;
    binOne = findBinOne(y, 100);
    plotSection(sectionValue, Fs, minDist, binOne);
    titlename = strcat("Audio Data for ", name);
    title(titlename, 'FontSize', 18, 'FontWeight', 'bold');

end
        
if plotAudioSectionOption == 1 % choose this option to plot audio sections 
    
    for i = 1:length(iStart) %for every section 
                
        sectionValue = y(iStart(i):iEnd(i));
        binOne = findBinOne(sectionValue, 100);
        plotSection(sectionValue, Fs, minDist, binOne);
        hold on
        
        s1 = sectionS1{1,i};
        s2 = sectionS2{1,i};
        
        % Convert S1 and S2 lists from cells to array        
        s1 = cell2mat(s1);
        s2 = cell2mat(s2);
        
        s1s = (s1(:,1));
        s1p = (s1(:,2));
        s2s = (s2(:,1));
        s2p = (s2(:,2));
        
        s1t = s1s / Fs;
        s2t = s2s / Fs;
        
        plot(s1t, s1p, 'r.')
        plot(s2t, s2p, '.')
                
        titlename = strcat("Section ", int2str(i), " for ", name); %title "Section n"
        title(titlename, 'FontSize', 18, 'FontWeight', 'bold');
        
        hold off
        
        legend('Audio Data','Detected Peaks', 'S1', 'S2')

    end
   
end

end

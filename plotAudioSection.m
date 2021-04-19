function plotAudioSection(allS1, allS2, sectionS1, sectionS2, iStart, iEnd, name, x, y, Fs, minDist, plotWholeAudioOption, plotAudioSectionOption)

if plotWholeAudioOption == 1 % choose this option to plot the whole audio file 
    
    sectionValue = y;
    sectionSample = x;
    binOne = findBinOne(y, 100);
    
    S1n = allS1(:,1);
    S1p = allS1(:,2);
    S2n = allS2(:,1);
    S2p = allS2(:,2);
    
    plotSection(sectionValue, sectionSample, minDist, binOne);
    hold on
    plot(S1n, S1p, 'r.', 'MarkerSize', 15)
    plot(S2n, S2p, '.', 'MarkerSize', 15)
    hold off
    titlename = strcat("Audio Data for ", name);
    title(titlename, 'FontSize', 18, 'FontWeight', 'bold');

    legend('Audio Data','Detected Peaks', 'S1', 'S2')

end
        
if plotAudioSectionOption == 1 % choose this option to plot audio sections 
    
    for i = 1:length(iStart) %for every section 
        
        sectionValue = y(iStart(i):iEnd(i));
        sectionSample = x(iStart(i):iEnd(i));
        binOne = findBinOne(sectionValue, 100);
        plotSection(sectionValue, sectionSample, minDist, binOne);
        hold on
        
        s1 = sectionS1{1,i};
        s2 = sectionS2{1,i};
        
        s1 = cell2mat(s1);
        s2 = cell2mat(s2);
        
        s1n = (s1(:,1));
        s1p = (s1(:,2));
        s2n = (s2(:,1));
        s2p = (s2(:,2));
        
        plot(s1n, s1p, 'r.', 'MarkerSize', 20)
        plot(s2n, s2p, '.', 'MarkerSize', 20)
                
        titlename = strcat("Section ", int2str(i), " for ", name); %title "Section n"
        title(titlename, 'FontSize', 18, 'FontWeight', 'bold');
        
        hold off
        
        legend('Audio Data','Detected Peaks', 'S1', 'S2')

    end
   
end

end

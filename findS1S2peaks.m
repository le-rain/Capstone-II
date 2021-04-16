function [sectionS1, sectionS2] = findS1S2peaks(iStart, iEnd, y, minDist)

sectionS1 = cell(1, length(iStart));
sectionS2 = cell(1, length(iStart));


for i = 1:length(iStart) %for every section 

    sectionValue = y(iStart(i):iEnd(i));
    binOne = findBinOne(sectionValue, 100);
    [peaks, sampleN] = findpeaks(sectionValue, 'MinPeakDistance', minDist, 'MinPeakProminence', binOne);
    
    % Find average peak distance in audio sections to identify S1 and S2 peaks 
    avg_dist = mean(diff(sampleN));
    
    % Remove non S1 and S2 peaks
    for j = 1:(length(sampleN)-2)
        if sampleN(j+1)-sampleN(j) < avg_dist && sampleN(j+2)-sampleN(j+1) < avg_dist
            sampleN(j+2) = 0;
            peaks(j+2) = 0;
        end
    end
    sampleN = nonzeros(sampleN);
    peaks = nonzeros(peaks);

    % Initiliaze list for S1 and S2 peaks
    s1 = [];
    s2 = [];
    
    % Loop for identifying and appending S1 and S2 peaks
    for k = 3:(length(sampleN))-1
        if sampleN(k)-sampleN(k-1) > avg_dist && sampleN(k-1)-sampleN(k-2) < avg_dist
            s1 = [s1; {sampleN(k) peaks(k)}];
            s2 = [s2; {sampleN(k+1) peaks(k+1)}];
        end
        if sampleN(k)-sampleN(k-1) > avg_dist && sampleN(k-1)-sampleN(k-2) < avg_dist
            s1 = [s1; {sampleN(k-2) peaks(k-2)}];
            s2 = [s2; {sampleN(k-1) peaks(k-1)}];
        end                
    end
    
    s1 = cell2mat(s1);    
    s2 = cell2mat(s2);    
    
    S1(:,1) = unique(s1(:,1), 'stable');
    S1(:,2) = unique(s1(:,2), 'stable');
    S2(:,1) = unique(s2(:,1), 'stable');
    S2(:,2) = unique(s2(:,2), 'stable');
    
    sectionS1{1, i} = S1;
    sectionS2{1, i} = S2;

end

end

function [sectionS1, sectionS2] = findS1S2peaks(iStart, iEnd, y, Fs, minDist)

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
    for k = 3:(length(sampleN))
        if sampleN(k)-sampleN(k-1) > avg_dist && sampleN(k-1)-sampleN(k-2) < avg_dist
            s1 = [s1; {sampleN(k) peaks(k)}];
            s2 = [s2; {sampleN(k+1) peaks(k+1)}];
        end
    end
    
    sectionS1{1, i} = s1;
    sectionS2{1, i} = s2;

end

end

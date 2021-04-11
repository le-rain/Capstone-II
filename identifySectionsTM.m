%accepts sorted istart and istop vectors from findWavesTM 
%returns indices of sections with consecutive good waves
%each row is a different section
%colummn 1 is start index, column 2 is end index of individual section
function [section_indices,ppg_sections] = identifySectionsTM(istart,istop)

    %identify indices of "good" waveforms close in proximity 
    consec = zeros(1,2); %initialize array to store indices 
    for i = 1:(length(istart) - 1)
        if abs(istop(i) - istart(i+1)) < 30 %if difference between end of one wave and start of the next wave is small enough
            consec = vertcat(consec,[istart(i) istop(i)]);
        end
    end
    
    %count number of individual sections with consecutive good waveforms
    num_sections = 1; %initialize counter
    for i = 2:(length(consec) - 1) %starts at 2 to ignore first row of consec [0 0]
        if abs(consec(i,2) - consec(i+1,1)) > 30 %if difference between end of one wave and start of next wave is large
            num_sections = num_sections + 1; %increment number of individual sections found
        end
    end
    
    %split consecutive good waveforms into different cells
    sections = cell(num_sections,1); %preallocate cell array 
    j = 1; %initialize counter for section number
    k = 1; %initialize counter for indices within each section 
    for i = 2:(length(consec) - 1) 
        sections{j}(k,1) = consec(i,1);
        sections{j}(k,2) = consec(i,2);
        k = k + 1; %increment internal index
        if abs(consec(i,2) - consec(i+1,1)) > 30
            j = j + 1; %move to next section
            k = 1; %reset internal index 
        end
    end
    %add last row of consec to last section because it gets missed in the for loop
    sections{j}(k,1) = consec(end,1);
    sections{j}(k,2) = consec(end,2);
   
    section_indices = zeros(num_sections,2); %preallocate space
    for i = 1:num_sections
        section_indices(i,1) = sections{i}(1,1); %start index
        section_indices(i,2) = sections{i}(end,2); %end index
    end
    
    ppg_sections = zeros(1,2);
    j = 1; 
    for i = 1:length(section_indices) %for every section 
        if abs(section_indices(i,2) - section_indices(i,1)) >= 100
            ppg_sections(j,1) = section_indices(i,1);
            ppg_sections(j,2) = section_indices(i,2);
            j = j + 1;
        end
    end
end
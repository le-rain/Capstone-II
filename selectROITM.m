%determines optimal ROI from split TD array after using template matching
%to identify best channel
%returns coordinates of optimal ROI with respect to split TD 
function [i,j] = selectROITM(splitTD)
   splitTD_mean = zeros(size(splitTD,1),size(splitTD,2)); %preallocate space
   
   for m = 1:size(splitTD,1) %loop through rows
        for n = 1:size(splitTD,2) %loop through columns
            splitTD_mean(m,n) = mean(splitTD{m,n},'all'); %calculate mean TD for each block
        end
   end
   
   TD_max = max(splitTD_mean,[],'all'); %determine max TD sum 
   
   [i,j] = find(splitTD_mean == TD_max); %return coordinates of block corresponding to max TD
end


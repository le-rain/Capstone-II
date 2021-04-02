%returns coordinates of optimal ROI determined using TD after TM
function [i,j] = selectROITM(splitTD)
   splitTD_mean = zeros(size(splitTD,1),size(splitTD,2));
   
   for m = 1:size(splitTD,1) %loop through rows
        for n = 1:size(splitTD,2) %loop through columns
            splitTD_mean(m,n) = mean(splitTD{m,n},'all');
        end
   end
   
   TD_max = max(splitTD_mean,[],'all');
   
   [i,j] = find(splitTD_mean == TD_max);
end


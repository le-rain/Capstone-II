%selects the optimal ROI by finding the block where average pixel intensity 
%is largest, returning channel and indices where ROI is found
%roi = 1 if in red channel, roi = 2 if in green channel
function [roi,i,j] = selectRegionTD(red, green)
   red_mean = zeros(size(red,1),size(red,2));
   green_mean = zeros(size(red,1),size(red,2));
   
   for m = 1:size(red,1) %loop through rows
        for n = 1:size(red,2) %loop through columns
            red_mean(m,n) = mean(red{m,n},'all');
            green_mean(m,n) = mean(green{m,n},'all');
        end
   end
   
   red_max = max(red_mean,[],'all');
   green_max = max(green_mean,[],'all');
   overall_max = max([red_max,green_max]);
   
   [i_r,j_r] = find(red_mean == overall_max);
   [i_g,j_g] = find(green_mean == overall_max);
   
   if isempty(i_r) == 0
       roi = 1;
       i = i_r(1);
       j = j_r(1);
   elseif isempty(i_g) == 0
       roi = 2;
       i = i_g(1);
       j = j_g(1);
   end
end

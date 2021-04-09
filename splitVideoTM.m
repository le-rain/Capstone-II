%splits TD array into blocks that are roiHeight x roiWidth in size
%if height and width are not divisible by roiHeight and roiWidth, the
%remainder is ignored, so right and bottom edges may be overlooked
function [splitTD,roiHeight,roiWidth] = splitVideoTM(TD,height,width,roiHeight,roiWidth)
    splitTD{floor(height/roiHeight),floor(width/roiWidth)} = zeros(roiHeight,roiWidth,'uint8'); %preallocate space
    
    for i = 1:floor(height/roiHeight) 
        for j = 1:floor(width/roiWidth)
            splitTD{i,j}(:,:) = TD(((i-1)*roiHeight+1):(i*roiHeight),((j-1)*roiWidth+1):(j*roiWidth));
        end
    end
end
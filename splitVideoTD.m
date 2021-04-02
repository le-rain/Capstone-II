%splits frames into blocks roiHeight x roiWidth in size
%it's best to specify roiHeight and roiWidth so height and width are
%divisible by them, otherwise the function floors to an integer and some
%edges of the video don't get analyzed
function [red, green, roiHeight, roiWidth] = splitVideoTD(redTD, greenTD, height, width, roiHeight, roiWidth)
    red{floor(height/roiHeight),floor(width/roiWidth)} = zeros(roiHeight,roiWidth,'uint8');
    green{floor(height/roiHeight),floor(width/roiWidth)} = zeros(roiHeight,roiWidth,'uint8');
    
    for i = 1:floor(height/roiHeight) 
        for j = 1:floor(width/roiWidth)
            red{i,j}(:,:) = redTD(((i-1)*roiHeight+1):(i*roiHeight),((j-1)*roiWidth+1):(j*roiWidth));
            green{i,j}(:,:) = greenTD(((i-1)*roiHeight+1):(i*roiHeight),((j-1)*roiWidth+1):(j*roiWidth));
        end
    end
end

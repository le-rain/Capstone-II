%calculates difference in intensity of pixels between adjacent frames for 
%a specified amount of time and sums them, returning arrays the same size
%as the original video with each value representing the sum of intensity
%differences for that pixel over the specified time period 
function [redTD, greenTD] = mapTD(video, height, width, frameRate)
    redTD = zeros(height,width,'uint8');
    greenTD = zeros(height,width,'uint8');
    %blueTD = zeros(height,width,'uint8');
    
%     redVideo = video{1}(:,:,1:round(frameRate*5));
%     greenVideo = video{2}(:,:,1:round(frameRate*5));
    
%     red_med = median(median(median((single(redVideo)))));
%     green_med = median(median(median((single(greenVideo)))));
%     
%     redVideo(find(redVideo(:,:,:) > 2*red_med)) = 0; 
%     greenVideo(find(greenVideo(:,:,:) > 2*green_med)) = 0; 
    
    for t = (round(frameRate*5)):(round(frameRate*10)-1) %for t = 5 - t = 10
        for i = 1:height
            for j = 1:width
                redTD(i,j) = redTD(i,j) + abs(video{1}(i,j,t+1) - video{1}(i,j,t));
                greenTD(i,j) = greenTD(i,j) + abs(video{2}(i,j,t+1) - video{2}(i,j,t));
                %blueTD(i,j) = blueTD(i,j) + abs(video{3}(i,j,t+1) - video{3}(i,j,t));
            end
        end
    end
end
 
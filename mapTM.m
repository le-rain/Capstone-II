%calculates temporal difference between each video frame from previously 
%identified optimal channel for specified time frame
%returns TD, a matrix containing the sum of temporal differences for every
%pixel in the video over the duration of the time frame
%TO DO: explore better options for determining which time frame to analyze 
function TD = mapTM(video,channel,height,width,frameRate)
    TD = zeros(height,width,'uint8'); %preallocate space
    
    for t = (round(frameRate*5)):(round(frameRate*10)-1) %for t = 5 - t = 10
        for i = 1:height
            for j = 1:width
                TD(i,j) = TD(i,j) + abs(video{channel}(i,j,t+1) - video{channel}(i,j,t));
            end
        end
    end
end
 
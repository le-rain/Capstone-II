function TD = mapTM(video, channel, height, width, frameRate)
    TD = zeros(height,width,'uint8');
    
    for t = (round(frameRate*5)):(round(frameRate*10)-1) %for t = 5 - t = 10
        for i = 1:height
            for j = 1:width
                TD(i,j) = TD(i,j) + abs(video{channel}(i,j,t+1) - video{channel}(i,j,t));
            end
        end
    end
end
 
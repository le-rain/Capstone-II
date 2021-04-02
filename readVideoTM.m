function [video, height, width, frameRate] = readVideoTM(file)
    obj = VideoReader(file); %read video
    height = obj.Height; %video height 
    width = obj.Width; %video width
    frameRate = obj.FrameRate; %frame rate
    frames = round(obj.Duration * frameRate); %number of frames
    
    video{1} = zeros(height,width,'uint8');
    video{2} = zeros(height,width,'uint8');
    k = 1;
    
    while hasFrame(obj) 
        frame = readFrame(obj,'native');
        video{1}(:,:,k) = frame(1:end,1:end,1); %red channel
        video{2}(:,:,k) = frame(1:end,1:end,2); %green channel
        k = k + 1;
        disp(['Progress: ' num2str(100 * k/frames, 2) '%'])
    end
end
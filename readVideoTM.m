%reads video file and returns red and green channels, file name, video
%height, video width, and frame rate
%TO DO: implement reduction coefficient to make processing faster
function [video,fileName,height,width,roiHeight,roiWidth,frameRate] = readVideoTM(file)
    obj = VideoReader(file); %read video
    reduction_coeff = 4;
    height = obj.Height/reduction_coeff; %video height 
    width = obj.Width/reduction_coeff; %video width
    roiHeight = round(height/2);
    roiWidth = round(width/2);
    frameRate = obj.FrameRate; %frame rate
    frames = obj.NumFrames; %number of frames
    fileName = file;
    
    video{1} = zeros(height,width,'uint8');
    video{2} = zeros(height,width,'uint8');
    k = 1;
    
    while hasFrame(obj) 
        frame = readFrame(obj,'native');
        video{1}(:,:,k) = frame(1:reduction_coeff:end,1:reduction_coeff:end,1); %red channel
        video{2}(:,:,k) = frame(1:reduction_coeff:end,1:reduction_coeff:end,2); %green channel
        k = k + 1;
        disp(['Progress: ' num2str(100 * k/frames, 2) '%'])
    end
end
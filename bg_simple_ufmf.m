
function [Ibg,Shist] = bg_simple_ufmf(header,inputFile,frameIndices,histScale,outputFile, bgThresh, sbfmf_info,displayTracking)
% function [Ibg,Shist] = bg_simple(inputFile,frameIndices,histScale,outputFile, bgThresh, sbfmf_info)
%
% compute the background image by taking the median value for each pixel
% across 100 randomly chosen frames
%
% inputs:
%   inputFile is the file to process
%   frameIndices is the subset of frames to use
%   histScale decimates the pixel values
%   outputFile is where to write the background image
%   bgThresh is the +/- range around the background image beyond which to
%      consider the pixel in the foreground
% outputs:
%    Ibg is the calculated backbround image
%    Shist is the histogramed pixel values on which Ibg is based
% for example:
%    [Ibg,Shist] = bg_simple('my_great_video.avi',1:1000,1,'my_great_video.bg.bmp',3,[]);

% updated by MBR to include waitbars
% supports sbfmf files, and bg_sub is made simpler

numFrames = length(frameIndices);

if isempty(sbfmf_info) % then compute a new bg image

    image = ufmf_load_image_test(header,inputFile, frameIndices(1), sbfmf_info); 
    [rows,cols] = size((image));

    %%% if there are lots of frames, use only first 10000 frames 
    %%% for bg estimation
    if( numFrames > 10000 )
        frameIndices = frameIndices(1:10000);
        numFrames = 10000;
    end

    %%%% go over 100 random images and generate histogram 
    %%%% for each pixel location
    num_images = min(numFrames,100);
    imIndices = ceil(rand(num_images,1) * numFrames-1)+1;
    imIndices = frameIndices(imIndices);
    binNumber = 256/histScale;
    Shist = uint8(zeros(rows,cols,binNumber));
%      h1 = waitbar(0,'Computing background image');

    for f=1:length(imIndices),
        image = ufmf_load_image_test(header,inputFile, imIndices(f), sbfmf_info); 
        image = floor(double((image))/histScale)+1;
        %%% output to a cxx (tried with sub2ind and it was slower)
        for r=1:rows,
            for c=1:cols,
                Shist(r,c,image(r,c)) = uint8(double(Shist(r,c,image(r,c))) + 1);
            end
        end 
%         waitbar(f/length(imIndices), h1);
    end
%     close(h1);

    %%% background gets the value with highest probability
    [max_val,max_ind] = max(Shist,[],3);
    Ibg = max_ind*histScale;
else
    sbfmf_info.fid = fopen(inputFile, 'r' ); %this is where we put in handle to sbfmf
    Ibg = sbfmf_info.bgcenter'; % need transpose on bg stored in sbfmf
end

Ibg=cast(Ibg, 'uint8');

imwrite(Ibg,outputFile);

Ibg_top = round(Ibg + bgThresh);
Ibg_top(Ibg_top > 255) = 255;

Ibg_bottom = round(Ibg - bgThresh);
%better to be safe...
Ibg_bottom(Ibg_bottom < 0) = 0;

% save these to disk
imwrite(uint8(Ibg_top) , [outputFile(1:end-4) '_top.bmp']);
imwrite(uint8(Ibg_bottom) , [outputFile(1:end-4) '_bottom.bmp']);         


if isempty(sbfmf_info)
    % just a placehodler, do nothing...
else % if necessary, close the movie file
   fclose(sbfmf_info.fid);
   sbfmf_info.fid = [];
end


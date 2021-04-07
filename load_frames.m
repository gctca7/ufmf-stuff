%% Load frames
function[images] = load_frames(start_frame, chunk_size, header, PathName)
    images = [];
    for frame_n = start_frame:start_frame + chunk_size - 1
        image = ufmf_load_image_test(header, PathName, frame_n, []);
        images = cat(3, images, image);
    end
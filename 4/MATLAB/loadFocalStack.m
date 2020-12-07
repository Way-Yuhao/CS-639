function [rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir)
    files = dir(fullfile(focal_stack_dir,'*.jpg')); % pattern to match filenames.
    k = size(files, 1);  % number of images
    rgb_stack = [];
    gray_stack = [];
    for k = 1:numel(files)
        fname = fullfile(focal_stack_dir, "frame" + k + ".jpg");
        img = imread(fname);
        % files(k).data = I; % optional, save data.
        rgb_stack = cat(3, rgb_stack, img);
        gray_stack = cat(3, gray_stack, rgb2gray(img));
    end
end
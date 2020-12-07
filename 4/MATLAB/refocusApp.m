function refocusApp(rgb_stack, depth_map)
    % display an image in the focal stack 
    t = uint8(1);  %display the first image by default
    img = rgb_stack(:, :, (t-1)*3+1: t*3);
    figure();
    imshow(img);
    
    % asking input for a scene point
    [y, x] =ginput(1);
    
    % refocus
    
    idx_in_focus = depth_map(uint16(y), uint16(x));
    disp(idx_in_focus)
    for i=1:idx_in_focus
        img = rgb_stack(:, :, (i-1)*3+1: i*3);
        imshow(img);
    end
end
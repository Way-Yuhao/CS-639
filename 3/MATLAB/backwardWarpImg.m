function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
                                              dest_canvas_width_height)
	src_height = size(src_img, 1);
	src_width = size(src_img, 2);
    src_channels = size(src_img, 3);
    dest_width = dest_canvas_width_height(1);
	dest_height	= dest_canvas_width_height(2);
    
    result_img = zeros(dest_height, dest_width, src_channels);
%     mask = false(dest_height, dest_width);
    
    % this is the overall region covered by result_img
    [dest_X, dest_Y] = meshgrid(1:dest_width, 1:dest_height);
    
    % map result_img region to src_img coordinate system using the given
    % homography.
    src_pts = applyHomography(resultToSrc_H, [dest_X(:), dest_Y(:)]);
    src_X = reshape(src_pts(:,1), dest_height, dest_width);
    src_Y = reshape(src_pts(:,2), dest_height, dest_width);
    
    % ---------------------------
    % START ADDING YOUR CODE HERE
    % ---------------------------
    
    % Set 'mask' to the correct values based on src_pts.
    mask = true(dest_height, dest_width);
    mask = mask & src_X > 0 & src_X < src_width;
    mask = mask & src_Y > 0 & src_Y < src_height;
    
    % fill the right region in 'result_img' with the src_img
    
    result_img(:, :, 1) = interp2(src_img(:,:, 1),src_X,src_Y);
    result_img(:, :, 2) = interp2(src_img(:,:, 2),src_X,src_Y);
    result_img(:, :, 3) = interp2(src_img(:,:, 3),src_X,src_Y);
    
    result_img(isnan(result_img)) = 0;
    
%     imshow(mask);
    
    
    % ---------------------------
    % END YOUR CODE HERE    
    % ---------------------------
end
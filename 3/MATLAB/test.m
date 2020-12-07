imgc = im2single(imread('mountain_center.png'));
imgl = im2single(imread('mountain_left.png'));
imgr = im2single(imread('mountain_right.png'));

% You are free to change the order of input arguments
% stitched_img = stitchImg(imgc, imgl, imgr);
stitched_img = stitchImg(imgl, imgc, imgr);
orig_img = imread('hough_1.png');
hough_img = imread('accumulator_hough_1.png');
hough_threashold = 85;

img = lineSegmentFinder(orig_img, hough_img, hough_threashold);
imwrite(im2double(img), 'hi.png');

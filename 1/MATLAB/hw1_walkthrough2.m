% -------------------------------------------------------------------------
% Part 2 - Create a Vincent van Gogh collage
% -------------------------------------------------------------------------

% Load the image "Vincent_van_Gogh.png" into memory
img = imread("Vincent_van_Gogh.png");

% Note the image is of the type uint8, 
% and the maximum pixel value of the image is 255.
class(img)
max(img(:))

% uint8 is memory efficient. Since we will perform some arithmetic operations
% on the image, uint8 needs to be used with caution. Let's cast the image
% to double.
img = im2double(img);

class(img)
max(img(:))


% Display the image
figure, imshow(img);

% Separate the image into three color channels and store each channel into
% a new image

red_channel = img(:, :, 1); figure, imshow(red_channel);
red_image = zeros(size(img)); red_image(:, :, 1) = red_channel; figure, imshow(red_image);

%
% Similarly extract green_channel and blue_channel and create green_image
% and blue_image

green_channel = img(:, :, 2);
green_image = zeros(size(img)); 
green_image(:, :, 2) = green_channel;

blue_channel = img(:, :, 3);
blue_image = zeros(size(img)); 
blue_image(:, :, 3) = blue_channel;

% Create a 1 x 4 image collage in the following arrangement
% 
% original image | red channel | green channel  | blue channel
collage_1x4 = [img, red_image, green_image, blue_image]; 
imshow(collage_1x4);

% Create a 2 x 2 image collage in the following arrangement
% 
% original image | red channel
% green channel  | blue channel
figure;
collage_2x2 = [img, red_image; green_image, blue_image]; 
imshow(collage_2x2);

% Save the collage as collage.png
imwrite(collage_2x2, "collage.png");


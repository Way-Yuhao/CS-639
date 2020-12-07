% --------------------------------------------------------------------------------------------------
% NOTE: it might be better to not run the whole script directly, but to step through it using the
% debugger (even though there shouldn't be any bugs here).
% --------------------------------------------------------------------------------------------------
%
% you will be able to follow the code more closely this way.
% 
% just set the breakpoint to the 'clearvars' line by clicking the '-' on its left.
% or set it anywhere else by clicking the '-' next to the line you want.
%
% to run the script, use the 'Run' button near the top of the UI, in the 'Editor' tab.
% it will pause at the breakpoint.
% 
% then to step through the code, use the 'Step' button in the 'Editor' tab.
%
% for the parts which also measure time (have tic and toc around them), the easiest way to run them
% is to select the relevant code (including the tic and toc statements), and run them using the
% "Evaluate Selection" option which shows up when you right-click the selected code. You can also
% use the keyboard shortcut F9 after selecting the code, instead of the right-click menu.
% --------------------------------------------------------------------------------------------------

%% Remove all existing variables from the workspace
%
% this can be necessary if they already take up too much memory and cramp the upcoming code.
% sometimes your script will have bugs if it doesn't start with a clean slate.
% 
% you can also clear individual variables from the workspace -- we have an example of that later.
clearvars;

%% Simple I/O
%
% fprintf works kind of like C
% First argument can be a file descriptor (obtained by fopen)
% or one of these two values:
%   1: standard output
%   2: standard error
% We do not deal with fopen much in this class. But if you face trouble with it during the class, 
% reach out to us!
fprintf(1, "hello world!\n");   % prints to stdout (command window here)
fprintf(1, 'hello world!\n');   % single quotes create 'character arrays' -- should work the same 
                                % as strings. you can use them interchangeably as far as i know.
                                % the rest of this script uses double quotes.

% You can skip the first argument -- it goes to stdout by default
fprintf("i say, ""let's learn MATLAB!""\n"); % use two double quotes to escape double quotes

% An alternative is disp.
disp("hi!");
% It's a more useful function when you want to print an array.
disp([1, 2, 3]);                    % horizontal
disp([1 2 3]);                      % also horizontal
disp([1; 2; 3]);                    % vertical
disp([1, 2, 3; 4, 5, 6; 7, 8, 9]);  % square
disp([1 2 3; 4 5 6; 7 8 9]);        % this is the same thing as 'square'

%% Load image
fname = "cameraman.tif";    % a grayscale image
cameraman_img = imread(fname);

% display an image
figure;         % creates a new UI window
imshow(cameraman_img);  % display image in latest UI window
colorbar;       % show range of values visually

min_intensity = min(cameraman_img(:));          % min of all values in the array -- (:) flattens the array
max_intensity = max(cameraman_img, [], "all");  % same effect as above, see "help max" for details
height = size(cameraman_img, 1);
width = size(cameraman_img, 2);

% format strings work like in C
fprintf("printing details of image %s...\n", fname);                                % %s: string
fprintf("image intensity range: %d to %d.\n", min_intensity, max_intensity);        % %d: integer
fprintf("image size: (%d rows, %d columns)\n", height, width);

% Clear unnecessary variables -- less clutter in workspace when debugging other code
clear min_intensity max_intensity fname;

%% Scale uint8 image to [0, 1]

% variables don't have to be allocated separately at all, technically
tic;    % start measuring time
for i = 1:height
    for j = 1:width
        % just start filling them up as you need
        cameraman_img_scaled_v1(i, j) = double(cameraman_img(i, j)) / 255.0;
    end
end
toc;    % end measuring time

% but this is discouraged, because repeated re-allocation can get expensive.
% also, it's hard to keep track of the variables in longer scripts.
% pre-allocate the result instead.
tic;
cameraman_img_scaled_v2 = zeros(height, width);
for i = 1:height
    for j = 1:width
        cameraman_img_scaled_v2(i, j) = double(cameraman_img(i, j)) / 255.0;
    end
end
toc;

% this is nice, but we can go one better.
% arrays are really easy to work with in MATLAB -- you rarely need loops!
tic;
cameraman_img_scaled_v3 = double(cameraman_img) / 255.0;    % convert to double and scale -- all elements at once!
toc;

% MATLAB has an inbuilt function for this
% NOTE: MATLAB has lots of inbuilt functions.
%       while we'd like you to implement many things by yourself for your homeworks, you are allowed
%       to use any functionality available for your projects (if you choose to use MATLAB for them).
tic;
cameraman_img_scaled_v4 = im2double(cameraman_img);
toc;

% look at each variable in the workspace to see they hold the same values

% imshow adjusts for double arrays internally
figure;                     % to create a new window for the new image, otherwise the original plot 
                            % will be overwritten.
imshow(cameraman_img_scaled_v4);
colorbar;                   % compare between Figure 1 and Figure 2

clear cameraman_img_scaled_v1 cameraman_img_scaled_v2 cameraman_img_scaled_v3 i j;

%% Copying
copy_1 = cameraman_img; % this works as a full copy of the array, not just a pointer copy 
                        % like in C. MATLAB doesn't have pointers like C does.
copy_1(:) = 0;          % set all pixels to black in the copied image (original stays unchanged).

% This is equivalent to the following:
copy_2 = cameraman_img;
for i = 1:size(cameraman_img, 1)
    for j = 1:size(cameraman_img, 2)
        copy_2(i, j) = 0;
    end
end

figure;
imshow([cameraman_img, copy_1, copy_2]);    % cameraman_img should look the same as before
colorbar;
% we used horizontal concatenation here. for vertical you'd do [img_1; img_1_copy_1; img_1_copy_2].
% it works okay for 1D and 2D arrays.
% for 3D and onwards, you'll need to use a function like cat.

clear copy_1 copy_2 i j;

%% Cropping

% copy out a part of the image separately
crop = cameraman_img(17:192, 33:224);

figure;
imshow(crop);

% set a particular part of the image
copy_1 = cameraman_img;             % make a copy because i need the original later
copy_1(17:64, 33:96) = 0;   % make a region of the image fully black
figure;
imshow(copy_1);

% the following code is equivalent
copy_2 = cameraman_img;
for i = 17:64
    for j = 33:96
        copy_2(i, j) = 0;
    end
end
figure;
imshow(copy_2);

clear copy_1 copy_2 crop i j;

%% Invert image
inverted_1 = 1 - cameraman_img_scaled_v4;
figure;
imshow(inverted_1);

% this is equivalent to:
inverted_2 = zeros(size(cameraman_img_scaled_v4), "double");
for i = 1:height
    for j = 1:width
        inverted_2(i, j) = 1 - cameraman_img_scaled_v4(i, j);
    end
end

disp(sum(abs(inverted_1 - inverted_2), "all")); % should be zero

clear inverted_1 inverted_2 i j;

%% Increase brightness of image
brighter = min(1, cameraman_img_scaled_v4 + 0.2);     % shouldn't cross 1 (maximum display value).
figure;
imshow([cameraman_img_scaled_v4, brighter]);

clear brighter;

%% Increase contrast
cameraman_img_scaled_v4_rescaled = 2 * cameraman_img_scaled_v4 - 1; % scaled to [-1, 1]
factor = 1.2;
% * factor scales to [-factor, factor], then we bring it back to [0, 2 * factor]
highcontrast = (cameraman_img_scaled_v4_rescaled * factor) + factor;
% value shouldn't go above 1.
highcontrast = min(highcontrast, 1);
figure;
imshow([cameraman_img_scaled_v4, highcontrast]);

clear highcontrast cameraman_img_scaled_v4_rescaled;

%% Try something stupid
rice = imread("rice.png");
rice_scaled = im2double(rice);

figure;
imshow(rice_scaled);

elwise_product = cameraman_img_scaled_v4 .* rice_scaled;   % a.k.a. Hadamard product
figure;
imshow(elwise_product);
colorbar;

% save an image
imwrite(elwise_product, "cameraman_dotx_rice.png");

% you probably don't want to do this with images directly,
% so be careful when you are writing your code!
matrix_product = cameraman_img_scaled_v4 * rice_scaled;
figure;
imshow(matrix_product, [0 width]);  % you can give a range of values to imshow,
                                    % for it to display your data appropriately.
                                    % this is needed if your data has a non-standard range.
                                    % the standard ranges are:
                                    %       uint8:          0 - 255
                                    %       uint16:         0 - 65535
                                    %       float/double:   0 - 1
                                    %
                                    % in this case, i knew the right range because i've used the
                                    % matrix product intentionally.
                                    %
                                    % in general, you might have to investigate your variables
                                    % manually if you're seeing unexpected results.
colorbar;

clear elwise_product matrix_product;

%% Do what we did earlier, but with color images
san_fran = im2double(imread("foggysf1.jpg"));
foosball = im2double(imread("foosball.jpg"));   % has the same size as san_fran

height = size(san_fran, 1);
width = size(san_fran, 2);
channels = size(san_fran, 3);
assert(channels == 3);                  % can verify pre-conditions with 'assert'

figure;
imshow(san_fran);

figure;
imshow(foosball);

clear channels;

%% Crop color image
crop = san_fran(2001:2333, 1574:1892, :);     % this will simply crop all three channels the same
figure;
imshow(crop);

% extract the channels individually
r_crop = san_fran(2001:2333, 1574:1892, 1);   % red channel only
g_crop = san_fran(2001:2333, 1574:1892, 2);   % green channel only
b_crop = san_fran(2001:2333, 1574:1892, 3);   % blue channel only

figure;
imshow([r_crop, g_crop, b_crop]); % show side-by-side -- it's not just all green!
colorbar;

clear crop r_crop g_crop b_crop;

%% Invert color image
inverted = 1 - san_fran;        % MATLAB broadcasts to the 3rd dimension automatically!

figure;
imshow(inverted);

% these images are bigger (and have 3 channels)
% so we can really see the effect of vectorization here
tic;
inverted_vec = 1 - san_fran;    % doing this again just to measure the time taken.
toc;

% and now for the loop version
tic;
inverted_loop = zeros(size(san_fran), "double");    % you don't really need the 'double'
                                                    % i'm just making this explicit
for c = 1:3
    for i = 1:height
        for j = 1:width
            inverted_loop(i, j, c) = 1 - san_fran(i, j, c);
        end
    end
end
toc;

% both arrays hold exactly the same values -- we can verify!
assert(sum(abs(inverted_vec - inverted_loop), "all") == 0);

clear inverted inverted_vec inverted_loop c i j;

%% Element-wise multiplication
elwise_product_1 = san_fran .* foosball;
figure;
imshow(elwise_product_1);

imwrite(elwise_product_1, "foggysf1_dotx_foosball.png");

% the above code is equivalent to the following:
r_out = san_fran(:,:,1) .* foosball(:,:,1);
g_out = san_fran(:,:,2) .* foosball(:,:,2);
b_out = san_fran(:,:,3) .* foosball(:,:,3);
elwise_product_2 = cat(3, r_out, g_out, b_out);
assert(sum(abs(elwise_product_1 - elwise_product_2), "all") == 0);

% you can do something weirder too -- try your own operations!
%
% takes the higher value for each pixel in the red channel
r_out = max(san_fran(:,:,1), foosball(:,:,1));  % you will notice that the output will have a red tinge
%
% you can use logical indexing to selectively fill in elements
%
g1 = san_fran(:,:,2);
g2 = foosball(:,:,2);   
g_out = g1;             % all pixels take from san_fran first
random_idx = rand(height, width) < 0.1;     % will be 'true' for around 10% of the pixels
                                            % (try a different kind of mask here?)
% take values from 'foosball' instead for those 10%
g_out(random_idx) = g2(random_idx);
%
% +1 in denominator to keep the output in range [0, 1]
%
b_out = san_fran(:,:,3) ./ (1 + foosball(:,:,3));
img_color_combo = cat(3, r_out, g_out, b_out);
figure;
imshow(img_color_combo);
imwrite(img_color_combo, "foggysf1_combo_foosball.png");
imwrite(random_idx, "random_idx.png");

clear elwise_product_1 elwise_product_2 r_out g_out b_out g1 g2 random_idx img_color_combo;

%% Cleanup
fprintf('Done!\n');
close all;  % to close all figures automatically
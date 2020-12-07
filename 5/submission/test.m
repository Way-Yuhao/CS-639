img1 = imread('simple1.png');
img2 = imread('simple2.png');

search_radius = 21;     % Half size of the search window
template_radius = 5;   % Half size of the template window
grid_MN = [12, 10];        % Number of rows and cols in the grid

result = computeFlow(img1, img2, search_radius, template_radius, grid_MN);
imwrite(result, 'simpleresult.png');
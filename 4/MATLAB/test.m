focal_stack_dir = 'stack';
[rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir);

index_map = imread('index_map.png');
refocusApp(rgb_stack, index_map);
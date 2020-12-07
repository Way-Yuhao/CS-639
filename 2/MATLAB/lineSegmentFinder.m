function cropped_line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold)
    orig_imsetting = iptgetpref('ImshowBorder');
    iptsetpref('ImshowBorder', 'tight');
    temp1 = onCleanup(@()iptsetpref('ImshowBorder', orig_imsetting));
    line_img = lineFinder(orig_img, hough_img, hough_threshold);
    edge_img = edge(orig_img);
    cropped_line_img = line_img;
    for y=1: size(cropped_line_img, 1)
        for x=1: size(cropped_line_img, 2)
            if ~edge_img(y, x)
                for c=1: 3
                    cropped_line_img(y, x, c) = orig_img(y, x);
                end
            end
        end
    end
end

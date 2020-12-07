function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)
    pts = [];
    theta_num_bins = size(hough_img, 2);
    rho_num_bins = size(hough_img, 1);
    
    x_l = 1;
    x_r = size(orig_img, 2);
    y_u = 1;
    y_l = size(orig_img, 1);
%     aa_step_size = pi / theta_num_bins;
    for theta_idx=1:size(hough_img,2)
        for rho_idx=1:size(hough_img,1)
            if hough_img(rho_idx, theta_idx) >= hough_threshold
                theta = (theta_idx) / theta_num_bins * pi;
                rho = rho_idx - rho_num_bins/2;
                save_pts = [];
                % intersection with left boundary 
                x_pt = 1;
                y_pt = round((x_l * sin(theta) + rho) / cos(theta), 0);
                if y_pt >= 1 && y_pt <= size(orig_img, 1)
                    save_pts = [save_pts; [x_pt y_pt]];
                end
                % intersection with right boundary 
                x_pt = size(orig_img, 2);
                y_pt = round((x_r * sin(theta) + rho) / cos(theta), 0);
                if y_pt >= 1 && y_pt <= size(orig_img, 1)
                    save_pts = [save_pts; [x_pt y_pt]];
                end
                % intersection with upper boundary 
                y_pt = 1;
                x_pt = round((y_u * cos(theta) - rho) / sin(theta), 0);
                if x_pt >= 1 && x_pt <= size(orig_img, 2)
                    save_pts = [save_pts; [x_pt y_pt]];
                end
                % intersection with lower boundary 
                y_pt = size(orig_img, 1);
                x_pt = round((y_l * cos(theta) - rho) / sin(theta), 0);
                if x_pt >= 1 && x_pt <= size(orig_img, 2)
                    save_pts = [save_pts; [x_pt y_pt]];
                end
                cur_pts = [save_pts(1, 1) save_pts(2, 1) save_pts(1, 2) save_pts(2, 2)];
                pts = [pts; cur_pts];
            end
        end
    end

    f = figure();
%     hold on;
    imshow(orig_img);
    for i=1: size(pts, 1)
        x1 = pts(i, 1);
        x2 = pts(i, 2);
        y1 = pts(i, 3);
        y2 = pts(i, 4);
        line([x1 x2], [y1 y2]);
    end
    line_detected_img = saveAnnotatedImg(f);
%     delete(f);
%     saveas(line_detected_img, 'myboi.png');
end

function annotated_img = saveAnnotatedImg(fh)
    figure(fh); % Shift the focus back to the figure fh

    % The figure needs to be undocked
    set(fh, 'WindowStyle', 'normal');

    % The following two lines just to make the figure true size to the
    % displayed image. The reason will become clear later.
    img = getimage(fh);
    truesize(fh, [size(img, 1), size(img, 2)]);

    % getframe does a screen capture of the figure window, as a result, the
    % displayed figure has to be in true size. 
    frame = getframe(fh);
    frame = getframe(fh);
    pause(0.5); 
    % Because getframe tries to perform a screen capture. it somehow 
    % has some platform depend issues. we should calling
    % getframe twice in a row and adding a pause afterwards make getframe work
    % as expected. This is just a walkaround. 
    annotated_img = frame.cdata;
end



%                 cur_pts = [0 0 0 0];
%                 y1 = round((x_l * sin(theta) + rho) / cos(theta), 0);
%                 if y1 > 0 && y1 <= size(orig_img, 1)
%                     cur_pts(1) = x_l;
%                     cur_pts(3) = y1;
%                 else
%                     cur_pts(1) = round((y_u * cos(theta) - rho) / sin(theta), 0);
%                     cur_pts(3) = y_u;
%                 end
%                 y2 = round((x_r * sin(theta) + rho) / cos(theta), 0);
%                 if y2 > 0 && y2 <= size(orig_img, 1)
%                     cur_pts(2) = x_r;
%                     cur_pts(4) = y2;
%                 else 
%                     cur_pts(2) = round((y_l * cos(theta) - rho) / sin(theta), 0);
%                     cur_pts(4) = y_l;
%                 end
%                 pts = [pts; cur_pts];
%                 if (theta < .25 * pi) | (theta > .75 * pi) 
%                     y1 = round((x_l * sin(theta) + rho) / cos(theta), 0);
%                     y2 = round((x_r * sin(theta) + rho) / cos(theta), 0);
%                     pts = [pts; [x_l x_r y1 y2]];
%                 else
%                     x1 = round((y_u * cos(theta) - rho) / sin(theta), 0);
%                     x2 = round((y_l * cos(theta) - rho) / sin(theta), 0);
%                     pts = [pts; [x1 x2 y_u y_l]];
%                 end
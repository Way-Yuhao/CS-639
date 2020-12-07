function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)
    AA = zeros(rho_num_bins, theta_num_bins);
    for y=1:size(img,1)
        for x=1:size(img,2)
              if img(y, x) ~= 0
                  for theta_idx=1:theta_num_bins
                      theta = theta_idx / theta_num_bins * pi;
                      rho = round(-(x * sin(theta)) + y * cos(theta), 0); % round to nearest digit
                      AA(rho+ rho_num_bins/2, theta_idx) = AA(rho+ rho_num_bins/2, theta_idx) + 1;             
                  end
              end
          end
    end
    hough_img = uint8(255 * mat2gray(AA));
end
function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
%RUNRANSAC
    num_pts = size(Xs, 1);
    pts_id = 1:num_pts;
    inliers_id = [];
    max_count = 0;
    H = zeros(3, 3);
    
    
    for iter = 1:ransac_n
        % ---------------------------
        % START ADDING YOUR CODE HERE
        % ---------------------------
        % randomly selecting 4 points
        rand_id = randperm(num_pts, 4);
        src_pts = [];
        dest_pts = [];
        for i = 1:4
            src_pts = [src_pts; Xs(rand_id(i), :)];
            dest_pts = [dest_pts; Xd(rand_id(i), :)];
        end
        H_3x3 = computeHomography(src_pts, dest_pts);
%         H_3x3 = computeHomography((src_pts(1:3, :)).', (dest_pts(1:3, :)).');
        Xdc = applyHomography(H_3x3, Xs);
        dist = sqrt(sum((Xd.' - Xdc.').^2));
        count = sum(dist < eps);
        if count > max_count
            max_count = count;
            inliers_id = dist < eps;
            H = H_3x3;
        end
        % ---------------------------
        % END ADDING YOUR CODE HERE
        % ---------------------------
    end    
end

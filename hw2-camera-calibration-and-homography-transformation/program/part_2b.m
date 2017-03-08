%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 0;

%% Perform Part 2-B

% read image
img = im2double(imread('debate.jpg'));

if QUICK_DEMO == 1
    % load part 2-B result
    load('part_2b_result');
else
    % load Hillary and Trump's four 2D points
    load('part_2_input');
    % load homography such that left(hillary) = H * right(trump)
    load('part_2a_result');
    % copy image
    img_new = repmat(img, 1);
    % create maskes for hilliary and trump
    hillary_mask = zeros(size(img,1), size(img,2));
    hillary_mask = roipoly(hillary_mask, hillaryPoint2D(:,1), hillaryPoint2D(:,2));
    trump_mask = zeros(size(img,1), size(img,2));
    trump_mask = roipoly(trump_mask, trumpPoint2D(:,1), trumpPoint2D(:,2));
    % find all pixels' position in hillary/trump region, and convert to homogeneuos coord. 
    [cols, rows] = find(hillary_mask == 1);
    left_points = [rows'; cols']';
    left_points(:,3) = 1;
    [cols, rows] = find(trump_mask == 1);
    right_points = [rows'; cols']';
    right_points(:,3) = 1;
    % compute left = H * right
    % replace right image region (trump) with left image region (hillary)
    left_projected_points = (H * right_points')';
    left_projected_points(:,1) = left_projected_points(:,1) ./ left_projected_points(:,3);
    left_projected_points(:,2) = left_projected_points(:,2) ./ left_projected_points(:,3);
    left_projected_points(:,3) = 1;
    % compute right = inv(H) * left
    % replace left image region (hillary) with right image region (trump)
    right_projected_points = (inv(H) * left_points')';
    right_projected_points(:,1) = right_projected_points(:,1) ./ right_projected_points(:,3);
    right_projected_points(:,2) = right_projected_points(:,2) ./ right_projected_points(:,3);
    right_projected_points(:,3) = 1;
    % perform backward wrapping using bilinear interpolation to get left
    % image region's new pixel value
    img_new = backwardWrap(img, img_new, right_projected_points, left_points);
    % perform backward wrapping using bilinear interpolation to get right
    % image region's new pixel value
    img_new = backwardWrap(img, img_new, left_projected_points, right_points);
    % save results
    save('part_2b_result', 'hillary_mask');
    save('part_2b_result', 'trump_mask', '-append');
    save('part_2b_result', 'img_new', '-append');
end

% show results
imshow(img_new);
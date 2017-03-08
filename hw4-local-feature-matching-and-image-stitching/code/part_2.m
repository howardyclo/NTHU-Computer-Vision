%% Clear all the histories
clc;clear;close all;

im_left = imread('left.jpg');
im_center = imread('center.jpg');
im_right = imread('right.jpg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute homography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[l_f_points, r_f_points] = find_matches(im_left, im_center, 0.07);
[H_l2c, inlier_indexs, outlier_indexs] = ransacHomography(l_f_points, r_f_points, 30, 1000);

[l_f_points, r_f_points] = find_matches(im_right, im_center, 0.07);
[H_r2c, inlier_indexs, outlier_indexs] = ransacHomography(l_f_points, r_f_points, 30, 1000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute shift amount for left image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Apply the homography to four boundary points of left padded image.
% The reason why calculate image boundaries on padded image is because we want to prevent
% projected points from the mask contain negative coordinates during performing backward wrapping.
padsize = 5;
left_bound = [1,1; size(im_left,2),1; size(im_left,2),size(im_left,1); 1,size(im_left,1)];
left_bound = left_bound + padsize;
left_bound(:,3) = 1;
proj_bound = (inv(H_l2c) * left_bound')';
proj_bound(:,1) = proj_bound(:,1) ./ proj_bound(:,3);
proj_bound(:,2) = proj_bound(:,2) ./ proj_bound(:,3);
proj_bound(:,3) = 1;

% Handle negative coordinates of projected boundaries
% by shifting the coordinates to proper ranges (1,1) – (H,W)
left_shift_proj_bound = proj_bound;
shift_x = 0;
shift_y = 0;
if min(left_shift_proj_bound(:,1)) < 1
  shift_x = -min(left_shift_proj_bound(:,1)) + 1;
end
if min(left_shift_proj_bound(:,2)) < 1
  shift_y = -min(left_shift_proj_bound(:,2)) + 1;
end
% We save this to shift center image and right image
left_shift_x = shift_x;
left_shift_y = shift_y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute shift amount for right image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Apply the homography to four boundary points of right padded image.
% The reason why calculate image boundaries on padded image is because we want to prevent
% projected points from the mask contain negative coordinates during performing backward wrapping.
padsize = 5;
right_bound = [1,1; size(im_right,2),1; size(im_right,2),size(im_right,1); 1,size(im_right,1)];
right_bound = right_bound + padsize;
right_bound(:,3) = 1;
proj_bound = (inv(H_r2c) * right_bound')';
proj_bound(:,1) = proj_bound(:,1) ./ proj_bound(:,3);
proj_bound(:,2) = proj_bound(:,2) ./ proj_bound(:,3);
proj_bound(:,3) = 1;

% Handle negative coordinates of projected boundaries
% by shifting the coordinates to proper ranges (1,1) – (H,W)
right_shift_proj_bound = proj_bound;

% Since we've shift the left image, we need to shift right image, too.
right_shift_x = left_shift_x;

shift_y = 0;
if min(right_shift_proj_bound(:,2)) < 1
  shift_y = -min(right_shift_proj_bound(:,2)) + 1;
end
% Select the biggest shift amount to shift all images in y-direction.
if shift_y > left_shift_y
  right_shift_y = shift_y;
  left_shift_y = right_shift_y;
else
  right_shift_y = left_shift_y
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute shift amount for center image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Shift four boundary points of center padded image to align transformed left image.
padsize = 5;
center_bound = [1,1; size(im_center,2),1; size(im_center,2),size(im_center,1); 1,size(im_center,1)];
center_bound = center_bound + padsize;
center_bound(:,3) = 1;
% No need to apply homography to center image.
center_shift_proj_bound = center_bound
% Since we've shift the center image, we need to shift right image, too.
center_shift_x = left_shift_x;
center_shift_y = left_shift_y; % also equal to right_shift_y

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shift projected bound for all images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left_shift_proj_bound(:,1) = left_shift_proj_bound(:,1) + left_shift_x;
left_shift_proj_bound(:,2) = left_shift_proj_bound(:,2) + left_shift_y;

center_shift_proj_bound(:,1) = center_shift_proj_bound(:,1) + center_shift_x;
center_shift_proj_bound(:,2) = center_shift_proj_bound(:,2) + center_shift_y;

right_shift_proj_bound(:,1) = right_shift_proj_bound(:,1) + right_shift_x;
right_shift_proj_bound(:,2) = right_shift_proj_bound(:,2) + right_shift_y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute projected points (color source)
% and target points (wrapping target) for left
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use poly2mask() to get transformed "meshgrid" point.
mask = poly2mask(left_shift_proj_bound(:,1), left_shift_proj_bound(:,2), ceil(max(left_shift_proj_bound(:,2))), ceil(max(left_shift_proj_bound(:,1))));
% Find all pixels' position in mask, and convert to homogeneuos coord.
[cols, rows] = find(mask == 1);
left_shift_target = [rows'; cols']';
left_shift_target(:,3) = 1;

% Use shifted target points to retrieve un-shifed target points
% in order to get projected points on original image.
target = left_shift_target;
target(:,1) = left_shift_target(:,1) - left_shift_x;
target(:,2) = left_shift_target(:,2) - left_shift_y;

% Find all pixel's projected points on original image (prepare to perform backward wrapping)
% Note that we use un-shifed target points to find projected points on original image.
proj_left = (H_l2c * target')';
proj_left(:,1) = proj_left(:,1) ./ proj_left(:,3);
proj_left(:,2) = proj_left(:,2) ./ proj_left(:,3);
proj_left(:,3) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute projected points (color source)
% and target points (wrapping target) for center
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use poly2mask() to get transformed "meshgrid" point.
mask = poly2mask(center_shift_proj_bound(:,1), center_shift_proj_bound(:,2), ceil(max(center_shift_proj_bound(:,2))), ceil(max(center_shift_proj_bound(:,1))));
% Find all pixels' position in mask, and convert to homogeneuos coord.
[cols, rows] = find(mask == 1);
center_shift_target = [rows'; cols']';
center_shift_target(:,3) = 1;

% Use shifted target points to retrieve un-shifed target points
% in order to get projected points on original image.
target = center_shift_target;
target(:,1) = center_shift_target(:,1) - center_shift_x;
target(:,2) = center_shift_target(:,2) - center_shift_y;

% Find all pixel's projected points on original image (prepare to perform backward wrapping)
% Note that we use un-shifed target points to find projected points on original image.
proj_center = target;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute projected points (color source)
% and target points (wrapping target) for center
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use poly2mask() to get transformed "meshgrid" point.
mask = poly2mask(right_shift_proj_bound(:,1), right_shift_proj_bound(:,2), ceil(max(right_shift_proj_bound(:,2))), ceil(max(right_shift_proj_bound(:,1))));
% Find all pixels' position in mask, and convert to homogeneuos coord.
[cols, rows] = find(mask == 1);
right_shift_target = [rows'; cols']';
right_shift_target(:,3) = 1;

% Use shifted target points to retrieve un-shifed target points
% in order to get projected points on original image.
target = right_shift_target;
target(:,1) = right_shift_target(:,1) - right_shift_x;
target(:,2) = right_shift_target(:,2) - right_shift_y;

% Find all pixel's projected points on original image (prepare to perform backward wrapping)
% Note that we use un-shifed target points to find projected points on original image.
proj_right = (H_r2c * target')';
proj_right(:,1) = proj_right(:,1) ./ proj_right(:,3);
proj_right(:,2) = proj_right(:,2) ./ proj_right(:,3);
proj_right(:,3) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Wrapping
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Pre-defined image size. Should be larger than expected stitched image size.
im_result = zeros([500, 500, 3]);

% Peform backward wrapping, wrap color from im_left(proj_left) to target points("meshgrid") in im_result
im_result = backwardWrap(padarray(im_left, [padsize, padsize]), im_result, proj_left, left_shift_target);
im_result = uint8(im_result);

% Peform backward wrapping, wrap color from im_center(proj_center) to target points("meshgrid") in im_result
im_result = backwardWrap(padarray(im_center, [padsize, padsize]), im_result, proj_center, center_shift_target);
im_result = uint8(im_result);

% Peform backward wrapping, wrap color from im_right(proj_right) to target points("meshgrid") in im_result
im_result = backwardWrap(padarray(im_right, [padsize, padsize]), im_result, proj_right, right_shift_target);
im_result = uint8(im_result);

% Show result
figure;
imshow(im_result);

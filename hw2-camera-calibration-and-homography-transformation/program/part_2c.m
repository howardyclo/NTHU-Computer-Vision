%% Clear all the histories
clc;clear;close all;

%% Constant for control
% if QUICK_DEMO == 1(true), load results from mat file instead of computing
% else, compute result again.
QUICK_DEMO = 0;

%% Perform Part 2-C

if QUICK_DEMO == 1
    % load part 2-C result
    load('part_2c_result');
else
    % load 2 walls' clicked points
    load('part_2c_input');
    % load result image, trump and hillary mask from part 2b
    load('part_2b_result');

    % save original image
    img = repmat(img_new, 1);

    % read texture and pick 4 points
    texture = im2double(imresize(imread('texture.jpg'),1.2));
    num_row = size(texture,1);
    num_col = size(texture,2);
    texturePoint2D = [1,1; num_col,1; num_col,num_row; 1,num_row];

    % compute homography
    H1 = computeHomography(leftWallPoint2D, texturePoint2D);
    H2 = computeHomography(rightWallPoint2D, texturePoint2D);

    % compute points projected from texture to wall
    [cols, rows] = find(zeros(num_row, num_col) == 0);
    texture_points = [rows'; cols']';
    texture_points(:,3) = 1;

    % compute left = H * right
    % save left wall projected points to projected_points(1)
    projected_points(1,:,:) = (H1 * texture_points')';
    projected_points(1,:,1) = projected_points(1,:,1) ./ projected_points(1,:,3);
    projected_points(1,:,2) = projected_points(1,:,2) ./ projected_points(1,:,3);
    projected_points(1,:,3) = 1;
    % save right wall projected points to projected_points(2)
    projected_points(2,:,:) = (H2 * texture_points')';
    projected_points(2,:,1) = projected_points(2,:,1) ./ projected_points(2,:,3);
    projected_points(2,:,2) = projected_points(2,:,2) ./ projected_points(2,:,3);
    projected_points(2,:,3) = 1;

    % matrix for recording interpolated colors of 2 walls
    wall = zeros(size(img));
    % matrix for recording summed weights for interpolated colors of 2 walls
    W = ones(size(img,1), size(img,2));
    % wall mask (wall region: 1; other: 0)
    wall_mask = zeros(size(img,1), size(img,2));

    % interpolating 2 walls using forward wrapping with bilinear interpolation
    for i=1:size(projected_points, 2)
        sprintf('Interpolation: %d / %d', i, size(projected_points, 2)) % just print index to show progress
        % get 4 neightbors' positions (left wall)
        x = projected_points(1,i,1);
        y = projected_points(1,i,2);
        top_left_x = floor(x);
        top_left_y = floor(y);
        top_right_x = ceil(x);
        top_right_y = top_left_y;
        bottom_left_x = top_left_x;
        bottom_left_y = ceil(y);
        bottom_right_x = top_right_x;
        bottom_right_y = bottom_left_y;
        % record left wall points
        wall_mask(top_left_y, top_left_x) = 1;
        wall_mask(top_right_y, top_right_x) = 1;
        wall_mask(bottom_left_y, bottom_left_x) = 1;
        wall_mask(bottom_right_y, bottom_right_x) = 1;
        % get corresponding texture color
        texture_x = texture_points(i,1);
        texture_y = texture_points(i,2);
        color = texture(texture_y, texture_x, :);
        % calculate weights (w=1, h=1)
        top_left_weight = (ceil(x)-x) * (ceil(y)-y);
        top_right_weight = (x-floor(x)) * (ceil(y)-y);
        bottom_left_weight = (ceil(x)-x) * (y-floor(y));
        bottom_right_weight = (x-floor(x)) * (y-floor(y));
        % assign color to 4 neighbor
        wall(top_left_y, top_left_x, :) = wall(top_left_y, top_left_x, :) + top_left_weight*color;
        wall(top_right_y, top_right_x, :) = wall(top_right_y, top_right_x, :) + top_right_weight*color;
        wall(bottom_left_y, bottom_left_x, :) = wall(bottom_left_y, bottom_left_x, :) + bottom_left_weight*color;
        wall(bottom_right_y, bottom_right_x, :) = wall(bottom_right_y, bottom_right_x, :) + bottom_right_weight*color;
        % record weights
        W(top_left_y, top_left_x) = W(top_left_y, top_left_x) + top_left_weight;
        W(top_right_y, top_right_x) = W(top_right_y, top_right_x) + top_right_weight;
        W(bottom_left_y, bottom_left_x) = W(bottom_left_y, bottom_left_x) + bottom_left_weight;
        W(bottom_right_y, bottom_right_x) = W(bottom_right_y, bottom_right_x) + bottom_right_weight;
        %===========================================================================================
        % get 4 neightbors' positions (right wall)
        x = projected_points(2,i,1);
        y = projected_points(2,i,2);
        top_left_x = floor(x);
        top_left_y = floor(y);
        top_right_x = ceil(x);
        top_right_y = top_left_y;
        bottom_left_x = top_left_x;
        bottom_left_y = ceil(y);
        bottom_right_x = top_right_x;
        bottom_right_y = bottom_left_y;
        % record left wall points
        wall_mask(top_left_y, top_left_x) = 1;
        wall_mask(top_right_y, top_right_x) = 1;
        wall_mask(bottom_left_y, bottom_left_x) = 1;
        wall_mask(bottom_right_y, bottom_right_x) = 1;
        % get corresponding texture color
        texture_x = texture_points(i,1);
        texture_y = texture_points(i,2);
        color = texture(texture_y, texture_x, :);
        % calculate weights (w=1, h=1)
        top_left_weight = (ceil(x)-x) * (ceil(y)-y);
        top_right_weight = (x-floor(x)) * (ceil(y)-y);
        bottom_left_weight = (ceil(x)-x) * (y-floor(y));
        bottom_right_weight = (x-floor(x)) * (y-floor(y));
        % assign color to 4 neighbors
        wall(top_left_y, top_left_x, :) = wall(top_left_y, top_left_x, :) + top_left_weight*color;
        wall(top_right_y, top_right_x, :) = wall(top_right_y, top_right_x, :) + top_right_weight*color;
        wall(bottom_left_y, bottom_left_x, :) = wall(bottom_left_y, bottom_left_x, :) + bottom_left_weight*color;
        wall(bottom_right_y, bottom_right_x, :) = wall(bottom_right_y, bottom_right_x, :) + bottom_right_weight*color;
        % record weights
        W(top_left_y, top_left_x) = W(top_left_y, top_left_x) + top_left_weight;
        W(top_right_y, top_right_x) = W(top_right_y, top_right_x) + top_right_weight;
        W(bottom_left_y, bottom_left_x) = W(bottom_left_y, bottom_left_x) + bottom_left_weight;
        W(bottom_right_y, bottom_right_x) = W(bottom_right_y, bottom_right_x) + bottom_right_weight;
    end

    % normalize wall interpolated colors by dividing recorded summed weights
    wall(:,:,1) = wall(:,:,1) ./ W;
    wall(:,:,2) = wall(:,:,2) ./ W;
    wall(:,:,3) = wall(:,:,3) ./ W;

    % remove orginal 2 wall from image
    img_new = img_new.*repmat(~wall_mask,[1,1,3]);
    % overlay interpolated colors of 2 walls (matrix C) on image
    img_new = img_new + wall;
    % remove hillary, trump from image
    img_new = img_new.*repmat(~hillary_mask,[1,1,3]);
    img_new = img_new.*repmat(~trump_mask,[1,1,3]);
    % extract hillary, trump from original image
    hillary = img.*repmat(trump_mask,[1,1,3]);
    trump = img.*repmat(hillary_mask,[1,1,3]);
    % overlay interpolated colors of hillary and trump
    img_new = img_new + hillary;
    img_new = img_new + trump;
    % save results
    save('part_2c_result', 'img_new');
end

% show result
imshow(img_new);

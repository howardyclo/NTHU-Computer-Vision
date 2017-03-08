%% Clear all the histories
clc;clear;close all;

%% Perform Part 1-B
im_scene = imread('scene.jpg');
im_book1 = imread('book1.jpg');
im_book2 = imread('book2.jpg');
im_book3 = imread('book3.jpg');

% Human labeled boundary for each books (from top-left, clockwise direction)
book1_points = [36.187, 50.786; 611.3, 49.311; 618.68, 434.2; 37.661, 444.52];
book2_points = [45.035, 22.767; 600.98, 22.767; 624.57, 469.59; 46.509, 476.96];
book3_points = [25.869, 69.956; 608.35, 64.508; 627.52, 457.79; 19.965, 466.64];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Book1 Result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im_book = im_book1;
book_points = book1_points;

% Get a group of matches
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.07);

% Use ransac to compute homography with inlier distance threshold = 30, max iteration = 1000
[H, inlier_indexs, outlier_indexs] = ransacHomography(l_f_points, r_f_points, 30, 1000);

%% Copy book1 image and scene image to result image
im_book_large = zeros(size(im_scene));
im_book_large(1:size(im_book,1), 1:size(im_book, 2), :) = im_book;
im_result = [im_book_large, im_scene];

% Start plotting inliers and outliers
figure('Name', 'Inliers(red); Outliers(green)');
imshow(im_result);
hold on;

% Plot matching points
plot(l_f_points(:,1), l_f_points(:,2), '*', 'Color', 'b');
plot(r_f_points(:,1)+size(im_scene,2), r_f_points(:,2), '*', 'Color', 'b');

% Plot outliers
for j=outlier_indexs
  plot([l_f_points(j,1), r_f_points(j,1)+size(im_scene,2)], [l_f_points(j,2), r_f_points(j,2)], 'Color', 'g');
end

% Plot inliers
for i=inlier_indexs'
  plot([l_f_points(i,1), r_f_points(i,1)+size(im_scene,2)], [l_f_points(i,2), r_f_points(i,2)], 'Color', 'r');
end

hold off;

% Start plotting the original human labeled boundary of book image
% and transformed human labeled boundary in the scene image

% Compute transformed human labeled boundary with homography from ransac
left = book_points;
left(:,3) = 1;
proj_right = (inv(H) * left')';
proj_right(:,1) = proj_right(:,1) ./ proj_right(:,3);
proj_right(:,2) = proj_right(:,2) ./ proj_right(:,3);
proj_right(:,3) = 1;

% Plot matching boundaries
figure('Name', 'Boundary matching for book1');
imshow(im_result);
hold on;
% book boundary
plot([left(1,1), left(2,1)], [left(1,2), left(2,2)], 'Color', 'g', 'LineWidth', 4); % top boundary
plot([left(2,1), left(3,1)], [left(2,2), left(3,2)], 'Color', 'b', 'LineWidth', 4); % right boundary
plot([left(3,1), left(4,1)], [left(3,2), left(4,2)], 'Color', 'y', 'LineWidth', 4); % bottom boundary
plot([left(4,1), left(1,1)], [left(4,2), left(1,2)], 'Color', 'r', 'LineWidth', 4); % left boundary
% projected book boundary in scene
plot([proj_right(1,1)+size(im_scene,2), proj_right(2,1)+size(im_scene,2)], [proj_right(1,2), proj_right(2,2)], 'Color', 'g', 'LineWidth', 4); % top boundary
plot([proj_right(2,1)+size(im_scene,2), proj_right(3,1)+size(im_scene,2)], [proj_right(2,2), proj_right(3,2)], 'Color', 'b', 'LineWidth', 4); % right boundary
plot([proj_right(3,1)+size(im_scene,2), proj_right(4,1)+size(im_scene,2)], [proj_right(3,2), proj_right(4,2)], 'Color', 'y', 'LineWidth', 4); % bottom boundary
plot([proj_right(4,1)+size(im_scene,2), proj_right(1,1)+size(im_scene,2)], [proj_right(4,2), proj_right(1,2)], 'Color', 'r', 'LineWidth', 4); % left boundary
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Book2 Result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im_book = im_book2;
book_points = book2_points;

% Get a group of matches
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.07);

% Use ransac to compute homography with inlier distance threshold = 30, max iteration = 1000
[H, inlier_indexs, outlier_indexs] = ransacHomography(l_f_points, r_f_points, 30, 1000);

%% Copy book1 image and scene image to result image
im_book_large = zeros(size(im_scene));
im_book_large(1:size(im_book,1), 1:size(im_book, 2), :) = im_book;
im_result = [im_book_large, im_scene];

% Start plotting inliers and outliers
figure('Name', 'Inliers(red); Outliers(green)');
imshow(im_result);
hold on;

% Plot matching points
plot(l_f_points(:,1), l_f_points(:,2), '*', 'Color', 'b');
plot(r_f_points(:,1)+size(im_scene,2), r_f_points(:,2), '*', 'Color', 'b');

% Plot outliers
for j=outlier_indexs
  plot([l_f_points(j,1), r_f_points(j,1)+size(im_scene,2)], [l_f_points(j,2), r_f_points(j,2)], 'Color', 'g');
end

% Plot inliers
for i=inlier_indexs'
  plot([l_f_points(i,1), r_f_points(i,1)+size(im_scene,2)], [l_f_points(i,2), r_f_points(i,2)], 'Color', 'r');
end

hold off;

% Start plotting the original human labeled boundary of book image
% and transformed human labeled boundary in the scene image

% Compute transformed human labeled boundary with homography from ransac
left = book_points;
left(:,3) = 1;
proj_right = (inv(H) * left')';
proj_right(:,1) = proj_right(:,1) ./ proj_right(:,3);
proj_right(:,2) = proj_right(:,2) ./ proj_right(:,3);
proj_right(:,3) = 1;

% Plot matching boundaries
figure('Name', 'Boundary matching for book1');
imshow(im_result);
hold on;
% book boundary
plot([left(1,1), left(2,1)], [left(1,2), left(2,2)], 'Color', 'g', 'LineWidth', 4); % top boundary
plot([left(2,1), left(3,1)], [left(2,2), left(3,2)], 'Color', 'b', 'LineWidth', 4); % right boundary
plot([left(3,1), left(4,1)], [left(3,2), left(4,2)], 'Color', 'y', 'LineWidth', 4); % bottom boundary
plot([left(4,1), left(1,1)], [left(4,2), left(1,2)], 'Color', 'r', 'LineWidth', 4); % left boundary
% projected book boundary in scene
plot([proj_right(1,1)+size(im_scene,2), proj_right(2,1)+size(im_scene,2)], [proj_right(1,2), proj_right(2,2)], 'Color', 'g', 'LineWidth', 4); % top boundary
plot([proj_right(2,1)+size(im_scene,2), proj_right(3,1)+size(im_scene,2)], [proj_right(2,2), proj_right(3,2)], 'Color', 'b', 'LineWidth', 4); % right boundary
plot([proj_right(3,1)+size(im_scene,2), proj_right(4,1)+size(im_scene,2)], [proj_right(3,2), proj_right(4,2)], 'Color', 'y', 'LineWidth', 4); % bottom boundary
plot([proj_right(4,1)+size(im_scene,2), proj_right(1,1)+size(im_scene,2)], [proj_right(4,2), proj_right(1,2)], 'Color', 'r', 'LineWidth', 4); % left boundary
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Book3 Result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im_book = im_book3;
book_points = book3_points;

% Get a group of matches
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.07);

% Use ransac to compute homography with inlier distance threshold = 30, max iteration = 1000
[H, inlier_indexs, outlier_indexs] = ransacHomography(l_f_points, r_f_points, 30, 1000);

%% Copy book1 image and scene image to result image
im_book_large = zeros(size(im_scene));
im_book_large(1:size(im_book,1), 1:size(im_book, 2), :) = im_book;
im_result = [im_book_large, im_scene];

% Start plotting inliers and outliers
figure('Name', 'Inliers(red); Outliers(green)');
imshow(im_result);
hold on;

% Plot matching points
plot(l_f_points(:,1), l_f_points(:,2), '*', 'Color', 'b');
plot(r_f_points(:,1)+size(im_scene,2), r_f_points(:,2), '*', 'Color', 'b');

% Plot outliers
for j=outlier_indexs
  plot([l_f_points(j,1), r_f_points(j,1)+size(im_scene,2)], [l_f_points(j,2), r_f_points(j,2)], 'Color', 'g');
end

% Plot inliers
for i=inlier_indexs'
  plot([l_f_points(i,1), r_f_points(i,1)+size(im_scene,2)], [l_f_points(i,2), r_f_points(i,2)], 'Color', 'r');
end

hold off;

% Start plotting the original human labeled boundary of book image
% and transformed human labeled boundary in the scene image

% Compute transformed human labeled boundary with homography from ransac
left = book_points;
left(:,3) = 1;
proj_right = (inv(H) * left')';
proj_right(:,1) = proj_right(:,1) ./ proj_right(:,3);
proj_right(:,2) = proj_right(:,2) ./ proj_right(:,3);
proj_right(:,3) = 1;

% Plot matching boundaries
figure('Name', 'Boundary matching for book1');
imshow(im_result);
hold on;
% book boundary
plot([left(1,1), left(2,1)], [left(1,2), left(2,2)], 'Color', 'g', 'LineWidth', 4); % top boundary
plot([left(2,1), left(3,1)], [left(2,2), left(3,2)], 'Color', 'b', 'LineWidth', 4); % right boundary
plot([left(3,1), left(4,1)], [left(3,2), left(4,2)], 'Color', 'y', 'LineWidth', 4); % bottom boundary
plot([left(4,1), left(1,1)], [left(4,2), left(1,2)], 'Color', 'r', 'LineWidth', 4); % left boundary
% projected book boundary in scene
plot([proj_right(1,1)+size(im_scene,2), proj_right(2,1)+size(im_scene,2)], [proj_right(1,2), proj_right(2,2)], 'Color', 'g', 'LineWidth', 4); % top boundary
plot([proj_right(2,1)+size(im_scene,2), proj_right(3,1)+size(im_scene,2)], [proj_right(2,2), proj_right(3,2)], 'Color', 'b', 'LineWidth', 4); % right boundary
plot([proj_right(3,1)+size(im_scene,2), proj_right(4,1)+size(im_scene,2)], [proj_right(3,2), proj_right(4,2)], 'Color', 'y', 'LineWidth', 4); % bottom boundary
plot([proj_right(4,1)+size(im_scene,2), proj_right(1,1)+size(im_scene,2)], [proj_right(4,2), proj_right(1,2)], 'Color', 'r', 'LineWidth', 4); % left boundary
hold off;

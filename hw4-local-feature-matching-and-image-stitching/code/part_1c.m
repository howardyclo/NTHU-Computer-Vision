%% Clear all the histories
clc;clear;close all;

%% Perform Part 1-C
im_scene = imread('scene.jpg');
im_book1 = imread('book1.jpg');
im_book2 = imread('book2.jpg');
im_book3 = imread('book3.jpg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Book1 Result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im_book = im_book1;

% Get a group of matches
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.07);

% Use ransac to compute homography with inlier distance threshold = 30, max iteration = 1000
[H, inlier_indexs, outlier_indexs] = ransacHomography(l_f_points, r_f_points, 30, 1000);

% Compute inlier correspondences.
left = l_f_points(inlier_indexs,1:2);
left(:,3) = 1;
proj_right = (inv(H) * left')';
proj_right(:,1) = proj_right(:,1) ./ proj_right(:,3);
proj_right(:,2) = proj_right(:,2) ./ proj_right(:,3);
proj_right(:,3) = 1;
right = r_f_points(inlier_indexs,1:2);

% Start plotting target feature points and transformed inlier feature points.
figure('Name', 'Book1 (blue: target; green: projected)');
imshow(im_scene);
hold on;

% Plot matching points
plot(right(:,1), right(:,2), 'ob', 'MarkerSize', 10);
plot(proj_right(:,1), proj_right(:,2), 'og', 'MarkerSize', 10);
plot(right(:,1), right(:,2), '.r', 'MarkerSize', 5);
plot(proj_right(:,1), proj_right(:,2), '.r', 'MarkerSize', 5);

% Plot deviation vector between matching points
for i=1:size(inlier_indexs, 1)
  plot([right(i,1), proj_right(i,1)], [right(i,2), proj_right(i,2)], 'Color', 'r');
end

hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Book2 Result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im_book = im_book2;

% Get a group of matches
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.07);

% Use ransac to compute homography with inlier distance threshold = 30, max iteration = 1000
[H, inlier_indexs, outlier_indexs] = ransacHomography(l_f_points, r_f_points, 30, 1000);

% Compute inlier correspondences.
left = l_f_points(inlier_indexs,1:2);
left(:,3) = 1;
proj_right = (inv(H) * left')';
proj_right(:,1) = proj_right(:,1) ./ proj_right(:,3);
proj_right(:,2) = proj_right(:,2) ./ proj_right(:,3);
proj_right(:,3) = 1;
right = r_f_points(inlier_indexs,1:2);

% Start plotting target feature points and transformed inlier feature points.
figure('Name', 'Book2 (blue: target; green: projected)');
imshow(im_scene);
hold on;

% Plot matching points
plot(right(:,1), right(:,2), 'ob', 'MarkerSize', 10);
plot(proj_right(:,1), proj_right(:,2), 'og', 'MarkerSize', 10);
plot(right(:,1), right(:,2), '.r', 'MarkerSize', 5);
plot(proj_right(:,1), proj_right(:,2), '.r', 'MarkerSize', 5);

% Plot deviation vector between matching points
for i=1:size(inlier_indexs, 1)
  plot([right(i,1), proj_right(i,1)], [right(i,2), proj_right(i,2)], 'Color', 'r');
end

hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Book3 Result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
im_book = im_book3;

% Get a group of matches
[l_f_points, r_f_points] = find_matches(im_book, im_scene, 0.07);

% Use ransac to compute homography with inlier distance threshold = 30, max iteration = 1000
[H, inlier_indexs, outlier_indexs] = ransacHomography(l_f_points, r_f_points, 30, 1000);

% Compute inlier correspondences.
left = l_f_points(inlier_indexs,1:2);
left(:,3) = 1;
proj_right = (inv(H) * left')';
proj_right(:,1) = proj_right(:,1) ./ proj_right(:,3);
proj_right(:,2) = proj_right(:,2) ./ proj_right(:,3);
proj_right(:,3) = 1;
right = r_f_points(inlier_indexs,1:2);

% Start plotting target feature points and transformed inlier feature points.
figure('Name', 'Book3 (blue: target; green: projected)');
imshow(im_scene);
hold on;

% Plot matching points
plot(right(:,1), right(:,2), 'ob', 'MarkerSize', 10);
plot(proj_right(:,1), proj_right(:,2), 'og', 'MarkerSize', 10);
plot(right(:,1), right(:,2), '.r', 'MarkerSize', 5);
plot(proj_right(:,1), proj_right(:,2), '.r', 'MarkerSize', 5);

% Plot deviation vector between matching points
for i=1:size(inlier_indexs, 1)
  plot([right(i,1), proj_right(i,1)], [right(i,2), proj_right(i,2)], 'Color', 'r');
end

hold off;

%% Clear all the histories
clc;clear;close all;

%% Perform Part 3-A

% resize image for quick experiment
img = im2double(imresize(imread('AmumuPoro.jpg'),1));

color_bandwidth = 0.01;
[centroids, cluster_indexs] = Segment.mean_shift(img, color_bandwidth);

img_segmented = Segment.recreateImage(img, centroids, cluster_indexs);
color_bar = Segment.createColorBar(centroids);

% show result
figure;
subplot(4,5,[1:12]);
imshow(img_segmented);
subplot(4,4,[13:16]);
imshow(color_bar);

disp('Drawing Pixel distribution before cluster. Please wait a moment');
points = reshape(img, [size(img,1)*size(img,2), size(img,3)]);
figure('Name', 'Pixel distribution before cluster');
scatter3(points(:,1), points(:,2), points(:,3), [], points, 'filled');

disp('Drawing Pixel distribution after cluster. Please wait a moment');
points_segmented = reshape(img_segmented, [size(img,1)*size(img,2), size(img,3)]);
figure('Name', 'Pixel distribution after cluster');
scatter3(points_segmented(:,1), points_segmented(:,2), points_segmented(:,3), [], points_segmented, 'filled');

disp('Done');
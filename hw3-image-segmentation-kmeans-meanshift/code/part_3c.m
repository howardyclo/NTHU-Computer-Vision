%% Clear all the histories
clc;clear;close all;

%% Perform Part 3-A

% resize image for quick experiment
img = im2double(imresize(imread('AmumuPoro.jpg'),1));

color_bandwidth = 100;
spatial_bandwidth = 1000;

% color
[centroids, cluster_indexs] = Segment.mean_shift(RGB2Luv(img), color_bandwidth);
img_segmented1 = Segment.recreateImage(img, centroids, cluster_indexs);
color_bar1 = Segment.createColorBar(centroids);

% color & spatial
% add position (x,y) to img dimension
num_row = size(img,1);
num_col = size(img,2);
R = repmat((1:num_row)',[1,num_col]);
C = repmat((1:num_col),[num_row,1]);
luvimg = RGB2Luv(img);
luvimg(:,:,4) = R;
luvimg(:,:,5) = C;

[centroids, cluster_indexs] = Segment.mean_shift(luvimg, color_bandwidth, spatial_bandwidth);
img_segmented2 = Segment.recreateImage(img, centroids, cluster_indexs);
color_bar2 = Segment.createColorBar(centroids);

% show result
figure('Name', 'Image segmentation (color)');
subplot(4,5,[1:12]);
imshow(img_segmented1);
subplot(4,4,[13:16]);
imshow(color_bar1);

figure('Name', 'Image segmentation (color & spatial)');
subplot(4,5,[1:12]);
imshow(img_segmented2);
subplot(4,4,[13:16]);
imshow(color_bar2);

disp('Drawing Pixel distribution after cluster (color). Please wait a moment');
points_segmented = reshape(img_segmented1, [size(img,1)*size(img,2), size(img,3)]);
figure('Name', 'Pixel distribution before cluster (color)');
scatter3(points_segmented(:,1), points_segmented(:,2), points_segmented(:,3), [], points_segmented, 'filled');

disp('Drawing Pixel distribution after cluster (color & space). Please wait a moment');
points_segmented = reshape(img_segmented2, [size(img,1)*size(img,2), size(img,3)]);
figure('Name', 'Pixel distribution after cluster (color & space)');
scatter3(points_segmented(:,1), points_segmented(:,2), points_segmented(:,3), [], points_segmented, 'filled');

disp('Done');
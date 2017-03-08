%% Clear all the histories
clc;clear;close all;

%% Perform Part 3-D

% resize image for quick experiment
img = im2double(imresize(imread('AmumuPoro.jpg'),1));

% add position (x,y) to img dimension
num_row = size(img,1);
num_col = size(img,2);
R = repmat((1:num_row)',[1,num_col]);
C = repmat((1:num_col),[num_row,1]);
img(:,:,4) = R;
img(:,:,5) = C;

color_bandwidth = 0.01;
spatial_bandwidth = 1000;
[centroids, cluster_indexs] = Segment.mean_shift(img, color_bandwidth, spatial_bandwidth);
img_segmented1 = Segment.recreateImage(img(:,:,1:3), centroids(:,1:3), cluster_indexs);
color_bar1 = Segment.createColorBar(centroids(:,1:3));

color_bandwidth = 0.01;
spatial_bandwidth = 5000;
[centroids, cluster_indexs] = Segment.mean_shift(img, color_bandwidth, spatial_bandwidth);
img_segmented2 = Segment.recreateImage(img(:,:,1:3), centroids(:,1:3), cluster_indexs);
color_bar2 = Segment.createColorBar(centroids(:,1:3));

color_bandwidth = 0.02;
spatial_bandwidth = 1000;
[centroids, cluster_indexs] = Segment.mean_shift(img, color_bandwidth, spatial_bandwidth);
img_segmented3 = Segment.recreateImage(img(:,:,1:3), centroids(:,1:3), cluster_indexs);
color_bar3 = Segment.createColorBar(centroids(:,1:3));

% show result
figure('Name', 'Bandwidth(Color: 0.01, Space: 1000)');
subplot(4,5,[1:12]);
imshow(img_segmented1);
subplot(4,4,[13:16]);
imshow(color_bar1);

figure('Name', 'Bandwidth(Color: 0.01, Space: 5000)');
subplot(4,5,[1:12]);
imshow(img_segmented2);
subplot(4,4,[13:16]);
imshow(color_bar2);

figure('Name', 'Bandwidth(Color: 0.02, Space: 1000)');
subplot(4,5,[1:12]);
imshow(img_segmented3);
subplot(4,4,[13:16]);
imshow(color_bar3);

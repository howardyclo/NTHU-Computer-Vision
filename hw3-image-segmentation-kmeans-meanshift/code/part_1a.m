%% Clear all the histories
clc;clear;close all;

%% Perform Part 1-A

img = im2double(imread('CaitlinPoro.jpg'));

[img_segmented1, color_bar1] = Segment.optimize_kmeans(img, 3, 50);
[img_segmented2, color_bar2] = Segment.optimize_kmeans(img, 7, 50);
[img_segmented3, color_bar3] = Segment.optimize_kmeans(img, 11, 50);

% show results
% k = 3
figure;
subplot(4,5,[1:12]);
imshow(img_segmented1);
subplot(4,4,[13:16]);
imshow(color_bar1);
% k = 7
figure;
subplot(4,5,[1:12]);
imshow(img_segmented2);
subplot(4,4,[13:16]);
imshow(color_bar2);
% k = 11
figure;
subplot(4,5,[1:12]);
imshow(img_segmented3);
subplot(4,4,[13:16]);
imshow(color_bar3);

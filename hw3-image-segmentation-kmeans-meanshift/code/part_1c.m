%% Clear all the histories
clc;clear;close all;

%% Perform Part 1-C

img = im2double(imread('CaitlinPoro.jpg'));

% hand-picked initial centroid colors from image 
white = [0.98, 0.976, 0.855];
red = [0.945, 0.459, 0.31];
pink = [0.82, 0.729, 0.667];
purple = [0.318, 0.196, 0.318];
light_blue = [0.702, 0.933, 0.965];
dark_blue = [0.208, 0.439, 0.51];
light_yellow = [1, 0.835, 0.322];
dark_yellow = [0.749, 0.439, 0.0784];
light_brown = [0.494, 0.192, 0.122];
dark_brown = [0.165, 0.145, 0.133];
gray = [0.373, 0.439, 0.416];

centroids1 = [light_blue; gray; dark_brown];
centroids2 = [white; red; purple; light_yellow; light_blue; light_brown; dark_brown];
centroids3 = [white; red; pink; purple; light_yellow; dark_yellow; light_blue; dark_blue; gray; light_brown; dark_brown];

% convert centroid's color space to luv;
centroids1 = reshape(RGB2Luv(reshape(centroids1, [3,1,3])), [3,3]);
centroids2 = reshape(RGB2Luv(reshape(centroids2, [7,1,3])), [7,3]);
centroids3 = reshape(RGB2Luv(reshape(centroids3, [11,1,3])), [11,3]);

% use LUV color space to run same task in part 1-A
[img_segmented1a, color_bar1a] = Segment.optimize_kmeans(RGB2Luv(img), 3, 50);
[img_segmented2a, color_bar2a] = Segment.optimize_kmeans(RGB2Luv(img), 7, 50);
[img_segmented3a, color_bar3a] = Segment.optimize_kmeans(RGB2Luv(img), 11, 50);

% use LUV color space to run same task in part 1-B
[img_segmented1b, color_bar1b] = Segment.optimize_kmeans(RGB2Luv(img), 3, 1, centroids1);
[img_segmented2b, color_bar2b] = Segment.optimize_kmeans(RGB2Luv(img), 7, 1, centroids2);
[img_segmented3b, color_bar3b] = Segment.optimize_kmeans(RGB2Luv(img), 11, 1, centroids3);

% show results for task in part 1-A
% k = 3
figure('Name', '[50 random initialize] k=3');
subplot(4,5,[1:12]);
imshow(img_segmented1a);
subplot(4,4,[13:16]);
imshow(color_bar1a);
% k = 7
figure('Name', '[50 random initialize] k=7');
subplot(4,5,[1:12]);
imshow(img_segmented2a);
subplot(4,4,[13:16]);
imshow(color_bar2a);
% k = 11
figure('Name', '[50 random initialize] k=11');
subplot(4,5,[1:12]);
imshow(img_segmented3a);
subplot(4,4,[13:16]);
imshow(color_bar3a);

% show results for task in part 1-B
% k = 3
figure('Name', '[manual initialize] k=3');
subplot(4,5,[1:12]);
imshow(img_segmented1b);
subplot(4,4,[13:16]);
imshow(color_bar1b);
% k = 7
figure('Name', '[manual initialize] k=7');
subplot(4,5,[1:12]);
imshow(img_segmented2b);
subplot(4,4,[13:16]);
imshow(color_bar2b);
% k = 11
figure('Name', '[manual initialize] k=11');
subplot(4,5,[1:12]);
imshow(img_segmented3b);
subplot(4,4,[13:16]);
imshow(color_bar3b);
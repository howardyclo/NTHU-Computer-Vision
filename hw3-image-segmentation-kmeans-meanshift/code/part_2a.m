%% Clear all the histories
clc;clear;close all;clear mex;

%% Perform Part 2-A

% new background
bg = im2double(imread('taipei101.jpg'));

% read video
obj = mmreader('jaguar.avi');
vid = read(obj);
num_frame = obj.NumberOfFrames;

% hand-picked centroids
foreground = [0.67, 0.451, 0.35];
background = [0.00726, 0.389, 0.799];
% cluster index => foreground: 1; background: 2
centroids = [foreground; background];

% create a avi file
aviobj = avifile('part_2a_result');
% read images from video
for i=1:num_frame
    sprintf('processing frames: %d/%d', i, num_frame)
    img = im2double(vid(:,:,:,i));
    [centroids, cluster_indexs, min_distances] = Segment.kmeans(img, 2, centroids);
    mask = Segment.recreateImage(img, [1,1,1; 0,0,0], cluster_indexs);
    frame = im2frame(mask.*img + ~mask.*bg);
    aviobj = addframe(aviobj,frame);
end
aviobj = close(aviobj);

disp('Done, please checkout "part_2a_result.avi"')

% non-vecterized implementation, TOO SLOW DON'T USE
% vecterized implementation is in Segment.kmeans
function [centroids, cluster_indexs, min_distances] = slow_kmeans(img, num_cluster)
    [num_row, num_col, num_dim] = size(img);
    num_data = num_row*num_col;
    points = reshape(img, [num_data, num_dim]);
    
    % step 1. initialize centroids
    centroids = initCentroids(points, num_cluster);
    
    % min_distances(i) = distance between point(i) to its cluster
    % cluster_index(i) = cluster index that point(i) belongs to 
    min_distances = zeros([num_data, 1]);
    cluster_indexs = zeros([num_data, 1]);
    
    iteration = 1;
    centroid_changed = true;
    
    while centroid_changed
        centroid_changed = false;
        
        % for each data point
        for i=1:num_data
            min_distance = 999999;
            cluster_index = 1;
            % step 2. for each centroid, find closest centroid to point
            for j=1:num_cluster
                distance = computeDistance(points(i,:), centroids(j,:));
                if distance < min_distance
                    min_distance = distance;
                    cluster_index = j;
                end
            end
            % step 2 (continue). put data point into cluster j
            if cluster_indexs(i) ~= cluster_index
                centroid_changed = true;
                cluster_indexs(i) = cluster_index;
                min_distances(i) = min_distance;
            end
        end
        
        % step 3. update centroids to be the mean of all data points in cluster j
        for j=1:num_cluster
            points_in_cluster = points(find(cluster_indexs == j),:);
            centroids(j,:) = mean(points_in_cluster);
        end
        
        cost = sum(min_distances);
        cost, iteration % show progress
        iteration = iteration + 1;
    end
end

% randomly initialize centroids
function centroids = initCentroids(points, k)
    num_data = size(points, 1);
    centroids = points(randsample(num_data, k),:);
end

% calculate squared euclidean distance (|| vector1 - vector2 ||)^2
function euclidean_distance = computeDistance(vector1, vector2)
    euclidean_distance = sum((vector1-vector2).^2);
end
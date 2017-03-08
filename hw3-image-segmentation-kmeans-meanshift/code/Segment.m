classdef Segment
    methods (Static)
        function [img_segmented, color_bar] = optimize_kmeans(img, num_cluster, num_epoch, init_centroids)
            
            img_segmented = zeros(size(img));
            [num_row, num_col, num_dim] = size(img);
            num_data = num_row*num_col;
            points = reshape(img, [num_data, num_dim]);
            
            % start running kmeans for <num_epoch> times
            cost = 99999999999999;
            centroids = zeros([num_cluster, num_dim]);
            cluster_indexs = ones([num_data, 1]);
            for epoch=1:num_epoch
                temp_centroids = zeros([num_cluster, num_dim]);
                % if no givin centroids, random initialize centroids
                if nargin < 4
                    temp_centroids = Segment.initCentroids(points, num_cluster);
                % error handling
                elseif size(centroids, 1) ~= num_cluster
                    sprintf('[optimize_kmeans] centroids num_cluster: %d != %d', size(centroids, 1));
                    return;
                elseif size(centroids, 2) ~= 3
                    sprintf('[optimize_kmeans] centroids dimension: %d != 3', size(centroids, 2));
                    return;
                else
                    temp_centroids = init_centroids;
                end
                
                [new_centroids, new_cluster_indexs, new_min_distances] = Segment.kmeans(img, num_cluster, temp_centroids);
                new_cost = sum(new_min_distances);
                if new_cost < cost
                    centroids = new_centroids;
                    cluster_indexs = new_cluster_indexs;
                    cost = new_cost;
                end
                sprintf('num_cluster: %d, epoch: %d, cost: %f', num_cluster, epoch, cost/num_data) % print progress
            end
        
            % recreate image
            img_segmented = Segment.recreateImage(img, centroids, cluster_indexs);

            % visualize centroids
            color_bar = Segment.createColorBar(centroids);
        end

        function [centroids, cluster_indexs, min_distances] = kmeans(img, num_cluster, init_centroids)
            [num_row, num_col, num_dim] = size(img);
            num_data = num_row*num_col;
            points = reshape(img, [num_data, num_dim]);
            centroids = zeros([num_cluster, num_dim]);

            % step 1. initialize centroids
            % if no givin centroids, random initialize centroids
            if nargin < 3
                centroids = Segment.initCentroids(points, num_cluster);
            % error handling
            elseif size(centroids, 1) ~= num_cluster
                sprintf('[kmeans] centroids num_cluster: %d != %d', size(centroids, 1));
                return;
            elseif size(centroids, 2) ~= 3
                sprintf('[kmeans] centroids dimension: %d != 3', size(centroids, 2));
                return;
            else
                centroids = init_centroids;
            end

            % min_distances(i) = distance between point(i) to its cluster
            % cluster_index(i) = cluster index that point(i) belongs to 
            min_distances = ones([num_data, 1])*999999;
            cluster_indexs = ones([num_data, 1]);

            iteration = 1;
            centroid_changed = true;

            while centroid_changed
                % reset centroid changed condition
                centroid_changed = false;

                D = [];
                % compute distance D. D(i,j): distance between point(i) to centroid(j)
                % distance: squared eulicdean distance: (|| P - C(j) ||)^2
                for j=1:num_cluster
                    distances = points - repmat(centroids(j,:), [num_data, 1]);
                    distances = sum(distances.^2, 2);
                    D = [D distances];
                end

                % for each row in D, find its closest(min distance) centroid
                % new_min_distances(i) = distance between point(i) to its closest centroid
                % new_cluster_index(i) = cluster index that point(i) belongs to 
                [new_min_distances, new_cluster_indexs] = min(D, [], 2);

                % if new minimum distance is smaller, update point(i)'s new minimum distance and
                % reassign its new cluster index
                % mask(need update: 1; remain: 0)
                mask = (new_min_distances < min_distances);
                if ~isempty(find(mask == 1))
                    % use mask to update
                    min_distances = (mask.*new_min_distances) + (~mask.*min_distances);
                    cluster_indexs = (mask.*new_cluster_indexs) + (~mask.*cluster_indexs);
                    centroid_changed = true;
                end

                % update centroids to be the mean of all data points in cluster j
                for j=1:num_cluster
                    points_in_cluster = points(find(cluster_indexs == j),:);
                    centroids(j,:) = mean(points_in_cluster);
                end

                cost = sum(min_distances);
                iteration = iteration + 1;
            end
        end

        % randomly initialize centroids
        function centroids = initCentroids(points, k)
            num_data = size(points, 1);
            centroids = points(randsample(num_data, k),:);
        end
        
        % fast mean shift
        function [centroids, cluster_indexs] = mean_shift(img, color_bandwidth, spatial_bandwidth)
            % reshape img to size(row*col, dim) data points
            [num_row, num_col, num_dim] = size(img);
            num_data = num_row*num_col;
            points = reshape(img, num_data, num_dim);

            % initialize parameters for mean-shift
            visit_flags = zeros(num_data, 1);
            visit_counts = [];
            num_cluster = 0;
            centroids = [];

            % for every unvisited points, do mean shift
            while ~isempty(find(visit_flags == 0)) % if all point got visited, stop
                % randomly select a point from unvisited points to be an initial centroid
                unvisited_indexs = find(visit_flags == 0);
                if length(unvisited_indexs) > 1
                    rand_index = randsample(unvisited_indexs, 1);
                else
                    rand_index = unvisited_indexs;
                end
                visit_flags(rand_index) = 1;
                centroid = points(rand_index, :);
                
                % initialize visit count of points visited during this cluster
                visit_count = zeros(num_data, 1);

                iteration = 1;
                centroid_changed = true;
                % start mean shift
                % max iteration = 50 (mostly can converge within 50 iterations)
                while centroid_changed && iteration <= 50
                    centroid_changed = false;
                    % find inner points that their distances between centroid are in the range of bandwidth
                    color_distances = points(:,1:3) - repmat(centroid(1:3), [num_data, 1]);
                    color_distances = sum(color_distances.^2, 2);
                    
                    % if only consider color bandwidth
                    if nargin < 3
                        inner_point_indexs = find(color_distances <= color_bandwidth);
                    % else, consider spatial bandwidth, too
                    else
                        spatial_distances = points(:,4:5) - repmat(centroid(4:5), [num_data, 1]);
                        spatial_distances = sum(spatial_distances.^2, 2);
                        inner_point_indexs = find(color_distances <= color_bandwidth & spatial_distances <= spatial_bandwidth);
                    end
                    
                    % record inner points as visited points
                    visit_flags(inner_point_indexs) = 1;
                    % accumulate visit count
                    visit_count(inner_point_indexs) = visit_count(inner_point_indexs) + 1;
                    % update centroid
                    inner_points = points(inner_point_indexs, :);
                    if size(inner_points, 1) > 1
                        new_centroid = mean(inner_points);
                    else
                        new_centroid = inner_points;
                    end
                   
                    % converge condition
                    shift_distance = sum((new_centroid-centroid).^2, 2);
                    if (shift_distance ~= 0)
                        centroid = mean(inner_points);
                        centroid_changed = true;
                    end

                    sprintf('unvisited points: %d/%d\nfor cluster %d, iteration: %d, shift_distance: %d', length(find(visit_flags == 0)), num_data, num_cluster+1, iteration, shift_distance)
                    iteration = iteration + 1;
                end

                % if new centroid is close to another centroid => merge
                similar_cluster_index = 0;
                for j=1:num_cluster
                    color_distance = centroid(1:3) - centroids(j,1:3);
                    color_distance = sum(color_distance.^2, 2);
                    % if only consider color bandwidth
                    if nargin < 3
                        if color_distance <= color_bandwidth
                            similar_cluster_index = j;
                            break;
                        end
                    % else, consider spatial bandwidth, too
                    else
                        spatial_distance = centroid(4:5) - centroids(j,4:5);
                        spatial_distance = sum(spatial_distance.^2, 2);
                        if color_distance <= color_bandwidth & spatial_distance <= spatial_bandwidth
                            similar_cluster_index = j;
                            break;
                        end
                    end
                end
                
                % if no need to merge
                if similar_cluster_index == 0
                    num_cluster = num_cluster + 1;
                    centroids(num_cluster,:) = centroid;
                    visit_counts(:, num_cluster) = visit_count;
                % if need to merge, average 2 similar centroids
                else
                    centroids(similar_cluster_index, :) = 0.5 * (centroid + centroids(similar_cluster_index, :));
                    visit_counts(:, similar_cluster_index) = visit_count + visit_counts(:, similar_cluster_index);
                end
            end

            % choose cluster index for data points based on visit count
            [max_visit_counts, cluster_indexs] = max(visit_counts, [], 2);
        end

        % recreate image (non-vectorized implementation, not used)
        function img_segmented = slow_recreateImage(img, centroids, cluster_indexs)
            img_segmented = zeros(size(img));
            num_row = size(img_segmented, 1);
            num_col = size(img_segmented, 2);
            % recreate image
            for x=1:num_row
                for y=1:num_col
                    index_2D_to_1D = num_row*(y-1)+x;
                    cluster_index = cluster_indexs(index_2D_to_1D);
                    img_segmented(x,y,:) = centroids(cluster_index,:);
                end
            end
        end

        % recreate image (vectorized implementation)
        function img_segmented = recreateImage(img, centroids, cluster_indexs)
            % check dimension only contains R,G,B
            % we don't need spatial informations
            if size(centroids, 2) > 3
                centroids = centroids(:,1:3);
            end
            
            % check centroids color space is RGB, if not, convert to RGB
            if ~isempty(find(~(centroids >= 0 & centroids <= 1)))
                centroids = reshape(Luv2RGB(reshape(centroids, [size(centroids,1),1,3])), [size(centroids,1),3]);
            end
            
            img_segmented = zeros(size(img));
            num_row = size(img_segmented,1);
            num_col = size(img_segmented,2);
            % map pixel 2D index to points 1D index
            % ex: img(x,y) represents points(num_row*(y-1)+x); points = reshape(img, [num_pixels, dimension])
            R = repmat((1:num_row)',[1,num_col]);
            C = repmat((1:num_col),[num_row,1]);
            Idx = num_row*(C-1)+R;
            % map point index to cluster index
            ClusterIdx = cluster_indexs(Idx);
            centroids_R = centroids(:,1);
            centroids_G = centroids(:,2);
            centroids_B = centroids(:,3);
            % map cluster index to its RGB color
            img_segmented(:,:,1) = centroids_R(ClusterIdx);
            img_segmented(:,:,2) = centroids_G(ClusterIdx);
            img_segmented(:,:,3) = centroids_B(ClusterIdx);
        end
        
        % visualize centroids
        function color_bar = createColorBar(centroids)
            % check dimension only contains R,G,B
            % we don't need spatial informations
            if size(centroids, 2) > 3
                centroids = centroids(:,1:3);
            end
            
            % check centroids color space is RGB, if not, convert to RGB
            if length(find(~(centroids >= 0 & centroids <= 1)))
                centroids = reshape(Luv2RGB(reshape(centroids, [size(centroids,1),1,3])), [size(centroids,1),3]);
            end
            
            color_bar = [];
            for j=1:size(centroids, 1)
                color_square = ones([10,10,3]);
                color_square(:,:,1) = color_square(:,:,1) * centroids(j,1);
                color_square(:,:,2) = color_square(:,:,2) * centroids(j,2);
                color_square(:,:,3) = color_square(:,:,3) * centroids(j,3);
                color_bar = [color_bar color_square];
            end
        end
        
    end
end


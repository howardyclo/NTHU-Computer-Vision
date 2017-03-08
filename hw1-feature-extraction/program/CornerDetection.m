classdef CornerDetection
    methods (Static)
        % Apply guassian smoothing to image
        function result = gaussianFilter(img, kernel_size, sigma)
            gaussian = fspecial('gaussian', kernel_size, sigma);
            result = imfilter(img, gaussian);
        end
        
        % Compute gradient of image
        function [grad_x, grad_y] = imgradientxy(img)
            sy = fspecial('sobel');
            sx = sy';
            grad_x = conv2(img, sx, 'same');
            grad_y = conv2(img, sy, 'same');
        end
        
        % Compute magnitude and direction of gradient of image
        % @param img: must be converted to grayscale and gaussian smoothed and normalized to [0-1]
        function [grad_mag, grad_dir] = imgradient(img)
            [grad_x, grad_y] = CornerDetection.imgradientxy(img);
            grad_mag = sqrt((grad_x.^2) + (grad_y.^2));
            grad_dir = ((atan2(grad_y,grad_x) * (180/pi)) + 180) / 360;
        end
        
        % corner detection
        % @param img: must be converted to grayscale and gaussian smoothed and normalized to [0-1]
        % @return Ieig: smallest eigenvalues of every pixel's tensor structure H
        function Ieig = detectCorner(img, window_size)
            % apply sobel on magitude to compute Ix, Iy
            [Ix, Iy] = CornerDetection.imgradientxy(img);
            % compute Ix^2, Ix*Iy, Iy^2
            Ixx = Ix.^2;
            Ixy = Ix.*Iy;
            Iyy = Iy.^2;
            % compute components of structure tensor H = [H11, H12; H21, H22]
            window = ones(window_size);
            H11 = conv2(Ixx, window, 'same');
            H12 = conv2(Ixy, window, 'same');
            H22 = conv2(Iyy, window, 'same');
            % for every pixel, compute pixel's eigenvalue of H
            [num_row, num_col] = size(img);
            Ieig = zeros(num_row, num_col);
            for x=1:num_row
                for y=1:num_col
                    % form pixel's tensor structure H by its components
                    H = [H11(x,y), H12(x,y); H12(x,y), H22(x,y)];
                    % compute smallest eignvalue of H and save to Ieig(x,y)
                    Ieig(x,y) = min(eig(H));
                end
            end
        end
        
        % perform non-maximum suppression for results from detectCorner()
        function Ieig_filtered = nonMaximumSuppression(Ieig, threshold)
            [num_row, num_col] = size(Ieig);
            Ieig_filtered = zeros(num_row, num_col);
            % preform non-maximum suppresion
            for x = 2:num_row-1
                for y = 2:num_col-1
                    % label current position as corner 
                    % if eignvalue is larger then threshold and neighbors'eigenvals
                    if Ieig(x,y) > threshold...
                        && Ieig(x,y) > Ieig(x-1,y-1)...
                        && Ieig(x,y) > Ieig(x-1,y)...
                        && Ieig(x,y) > Ieig(x-1,y+1)... 
                        && Ieig(x,y) > Ieig(x,y-1)... 
                        && Ieig(x,y) > Ieig(x,y+1)... 
                        && Ieig(x,y) > Ieig(x+1,y-1)... 
                        && Ieig(x,y) > Ieig(x+1,y)... 
                        && Ieig(x,y) > Ieig(x+1,y+1)
                        Ieig_filtered(x,y) = 1;
                    end
                end
            end
        end
        
    end
end
clear all; clc;
bDrawDebug = true;
bShouldNormalizePts = true;
bAssumeTrueMatches = true; % Whether or not to assume all matches are true

% load images 
I1 = imread('house1.jpg');
I2 = imread('house2.jpg');
%I1 = imread('library1.jpg');
%I2 = imread('library2.jpg');

%Load match files for the first example
% This is a N x 4 file where the first two numbers of each row
% are coordinates of corners in the first image and the last two
% are coordinates of corresponding corners in the second image: 
% matches(i,1:2) is a point in the first image
% matches(i,3:4) is a corresponding point in the second image
matches = load('house_matches.txt'); 
%matches = generate_matches(I1,I2, 100, false);
%matches = load('library_matches.txt');
%matches = generate_matches(I1,I2, 200, bDrawDebug);

numMatches = size(matches,1);

if(bDrawDebug)
    %display an overlay of the features ontop of the image
    figure; imshow([I1 I2]); hold on; title('Overlay detected features (corners)');
    hold on; plot(matches(:,1),matches(:,2),'ys'); plot(matches(:,3) + size(I1,2), matches(:,4), 'ys'); 
    
    % display two images side-by-side with matches
    % this code is to help you visualize the matches, you don't need
    % to use it to produce the results for the assignment
    figure; imshow([I1 I2]); hold on;
    plot(matches(:,1), matches(:,2), '+r');
    plot(matches(:,3)+size(I1,2), matches(:,4), '+r');
    line([matches(:,1) matches(:,3) + size(I1,2)]', matches(:,[2 4])', 'Color', 'r');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fit a Fundamental Matrix using the matches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (bAssumeTrueMatches)  
    display('Assuming all matches are true and fitting to all');
    F = fit_fundamental(matches, bShouldNormalizePts); % this is a function that you should write
else
    display('Estimating the fundamental matrix');
    %If the matches cannot be assumed to be ground truth, then estimate the
    %fundamental matrix using RANSAC
    F = estimate_fundamental(matches, bShouldNormalizePts);
end
residuals = calc_residuals(F,matches);
display(['Mean residual is: ' , num2str(mean(residuals))]);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% display second image with epipolar lines reprojected 
% from the first image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transform points from the 1st img to get epipolar lines in the 2nd image
L = (F * [matches(:,1:2) ones(numMatches,1)]')'; 

% find points on epipolar lines L closest to matches(:,3:4)
L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
pt_line_dist = sum(L .* [matches(:,3:4) ones(numMatches,1)],2);
closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);

% find endpoints of segment on epipolar line (for display purposes)
pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

% display points and segments of corresponding epipolar lines
figure;
imshow(I2); hold on;
plot(matches(:,3), matches(:,4), '+r');
line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Triangulate the position of the points in 3d world space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%load the camera matrices and determine the camera centers
camMatrix1 = load('house1_camera.txt');
camCenter1 = get_cam_center(camMatrix1);

camMatrix2 = load('house2_camera.txt');
camCenter2 = get_cam_center(camMatrix2);

%homogenize the coordinates
x1 = cart_2_homo(matches(:,1:2));
x2 = cart_2_homo(matches(:,3:4));
numMatches = size(x1,1);
triangPoints = zeros(numMatches, 3);
projPointsImg1 = zeros(numMatches, 2);
projPointsImg2 = zeros(numMatches, 2);

%calcualte the triangulated points, + their projections onto each img plane
for i = 1:numMatches
    pt1 = x1(i,:);
    pt2 = x2(i,:);
    crossProductMat1 = [  0   -pt1(3)  pt1(2); pt1(3)   0   -pt1(1); -pt1(2)  pt1(1)   0  ];
    crossProductMat2 = [  0   -pt2(3)  pt2(2); pt2(3)   0   -pt2(1); -pt2(2)  pt2(1)   0  ];    
    Eqns = [ crossProductMat1*camMatrix1; crossProductMat2*camMatrix2 ];
    
    [~,~,V] = svd(Eqns);
    triangPointHomo = V(:,end)'; %4 dim (3 dimensions + homo coord)
    %save the triangulated 3d point
    triangPoints(i,:) = homo_2_cart(triangPointHomo);
    
    %project the triangulated point using both camera matrices for later
    %residual calculations
    projPointsImg1(i,:) = homo_2_cart((camMatrix1 * triangPointHomo')');
    projPointsImg2(i,:) = homo_2_cart((camMatrix2 * triangPointHomo')');
    
end

% plot the triangulated points and the camera centers
plot_triangulation(triangPoints, camCenter1, camCenter2);

%calculate the error distance between the triangulated point projected onto
%the image plane and the actual location of the point on the image plane
distances1 = diag(dist2(matches(:,1:2), projPointsImg1));
distances2 = diag(dist2(matches(:,3:4), projPointsImg2));
display(['Mean Residual 1: ', num2str(mean(distances1))]);
display(['Mean Residual 2: ', num2str(mean(distances2))]);




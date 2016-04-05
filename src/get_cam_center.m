function [ cameraCenter ] = get_cam_center( cameraMatrix )
%GET_CAM_CENTER Summary of this function goes here
%   Detailed explanation goes here

    [~, ~, V] = svd(cameraMatrix);
    cameraCenter = V(:,end);
    cameraCenter = homo_2_cart(cameraCenter'); %unhomogenize the point
end


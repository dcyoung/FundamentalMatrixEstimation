function [ transform, normCoord ] = normalize_coordinates( coordinates )
%NORMALIZE_COORDINATES Summary of this function goes here
%   Detailed explanation goes here
    
    center = mean(coordinates(:,1:2));
    %centerVecs = repmat(centers, numCoord,1);
    
    %1 x numCoord matrix where jth entry is squared dist between center
    %point and the jth coordinate
    squaredDistances = dist2(center, coordinates(:,1:2));
    meanSquaredDistance = mean( squaredDistances );
    scale = 2/meanSquaredDistance;
    
    transform = [scale,     0,      -scale*center(1);...
                    0,      scale,  -scale*center(2);...
                    0,      0,      1];
                
    normCoord = (transform * coordinates')';
end


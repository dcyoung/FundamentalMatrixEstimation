function [ homogenousCoordinates ] = homogenize_coordinates( coordinates )
%HOMOGENIZE_COORDINATES Summary of this function goes here
%   Detailed explanation goes here

    [numCoordinates, dimension] = size(coordinates);
    homogenousCoordinates = ones(numCoordinates, dimension+1);
    homogenousCoordinates(:,1 : dimension) = coordinates(:,1:dimension);
    
end
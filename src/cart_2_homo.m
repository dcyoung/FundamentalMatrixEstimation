function [ homoCoord ] = cart_2_homo( cartCoord )
%HOMOGENIZE_COORDINATES Summary of this function goes here
%   Detailed explanation goes here

    [numCoordinates, dimension] = size(cartCoord);
    homoCoord = ones(numCoordinates, dimension+1);
    homoCoord(:,1 : dimension) = cartCoord(:,1:dimension);
    
end
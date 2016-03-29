function [coordinates] = unhomogenize_coordinates(homogenousCoordinates)
%UNHOMOGENIZE_COORDINATES Summary of this function goes here
%   Detailed explanation goes here

    dimension = size(coordinates, 2) - 1;
    coordinates = homogenousCoordinates(:,1:dimension);
end


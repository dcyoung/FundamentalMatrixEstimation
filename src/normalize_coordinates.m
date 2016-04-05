function [ transform, normCoord ] = normalize_coordinates( homoCoord )
%NORMALIZE_COORDINATES Summary of this function goes here
%   Detailed explanation goes here

    center = mean(homoCoord(:,1:2)); 
    
    offset = eye(3);
    offset(1,3) = -center(1); %-mu_x
    offset(2,3) = -center(2); %-mu_y

    sX= max(abs(homoCoord(:,1)));
    sY= max(abs(homoCoord(:,2)));
    
    scale = eye(3);
    scale(1,1)=1/sX;
    scale(2,2)=1/sY;          
                
    transform = scale * offset;
    normCoord = (transform * homoCoord')';
end


function [cartCoord] = homo_2_cart(homoCoord)
%UNHOMOGENIZE_COORDINATES Summary of this function goes here
%   Detailed explanation goes here

    dimension = size(homoCoord, 2) - 1;
        
    %divide every row by the last entry in that row
    normCoord = bsxfun(@rdivide,homoCoord,homoCoord(:,end));
    cartCoord = normCoord(:,1:dimension);
end


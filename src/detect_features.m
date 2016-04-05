function [ r, c ] = detect_features( grayImg, discountPadSize )
%DETECT_FEATURES Summary of this function goes here
%   Detailed explanation goes here


  
    %use harris corner detector
    points = detectHarrisFeatures(grayImg);
   

    %extract the pixel locations from the features
    [r, c] = deal( zeros(length(points),1) );
    
    
    
    [h, w] = size(grayImg);
    indicesToRemove = [];
    for i = 1: length(points)
        cornerLoc = points(i).Location;
        r(i) = round(cornerLoc(2));
        c(i) = round(cornerLoc(1));
        if(check_edge_proximity(r(i), c(i), h, w, discountPadSize) == 1)
            indicesToRemove = [indicesToRemove; i];
        end
    end
    r = r(~ismember(1:size(r, 1), indicesToRemove), :);
    c = c(~ismember(1:size(c, 1), indicesToRemove), :);
end




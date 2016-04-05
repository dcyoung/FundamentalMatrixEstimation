function [ img1Feature_idx, img2Feature_idx ] = match_features( numMatches, featDescriptions_1, featDescriptions_2)
%MATCH_FEATURES Summary of this function goes here
%   Detailed explanation goes here

    %determine the dist between every pair of features between images
    %(ie: every combination of 1 feature from img1 and 1 feature from img2)
    distances = dist2(featDescriptions_1, featDescriptions_2);
    %sort these distances
    [~,distance_idx] = sort(distances(:), 'ascend');
    %select the smallest distances as the best matches
    bestMatches = distance_idx(1:numMatches);
    % Determine the row,col indices in the distances matrix containing the best
    % matches, as they'll be used to determine which feature pair produced that 
    % distance. The distances matrix is m x n where m = numFeaturesImg1 and 
    % n = numFeaturesImg2... so we access img1 feature as the row and img2
    % feature as the col
    [rowIdx_inDistMatrix, colIdx_inDistMatrix] = ind2sub(size(distances), bestMatches);
    img1Feature_idx = rowIdx_inDistMatrix;
    img2Feature_idx = colIdx_inDistMatrix;
end


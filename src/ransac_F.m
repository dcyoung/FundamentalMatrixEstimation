function [ bestFitModel, inlierIndices ] = ransac_F( parameters, matches, fitModelFxn, errorFxn )
%RANSAC_F Summary of this function goes here
%   Detailed explanation goes here


    [numMatches, ~] = size(matches);
    numInliersEachIteration = zeros(parameters.numIterations,1);
    storedModels = {};%zeros(parameters.numIterations,3,3);
    
    for i = 1 : parameters.numIterations;
        %display(['Running ransac Iteration: ', num2str(i)]);
        
        %select a random subset of points
        subsetIndices = randsample(numMatches, parameters.subsetSize);
        matches_subset = matches(subsetIndices, :);
            
        %fit a model to that subset
        model = fitModelFxn(matches_subset, parameters.bShouldNormalizePts);
        
        %compute inliers, ie: find all remaining points that are 
        %"close" to the model and reject the rest as outliers
        residualErrors = errorFxn(model, matches);
        
        %display(['Mean Residual Error: ', num2str(mean(residualErrors))]);
        inlierIndices = find(residualErrors < parameters.inlierDistThreshold);      

        %record the number of inliers
        numInliersEachIteration(i) = length(inlierIndices);
        
        %keep track of any models that generated an acceptable numbers of 
        %inliers. This collection can be parsed later to find the best fit
        currentInlierRatio = numInliersEachIteration(i)/numMatches;
        if currentInlierRatio >=  parameters.minInlierRatio
        %if numInliersEachIteration(i) >= max(numInliersEachIteration)
            %re-fit the model using all of the inliers and store it
            matches_inliers = matches(inlierIndices, :);
            storedModels{i} = fitModelFxn(matches_inliers, parameters.bShouldNormalizePts);
        end
    end
    %display(storedModels);
    %display(numInliersEachIteration);
    
    %retrieve the model with the best fit (highest number of inliers)
    bestIteration = find(numInliersEachIteration == max(numInliersEachIteration));
    bestIteration = bestIteration(1); %incase there was more than 1 with same value
    bestFitModel = storedModels{bestIteration};
    
    %recalculate the inlier indices for all points, this was done once before 
    %when calculting this model, but it wasn't stored for space reasons. 
    %Recalculate it now so that it can be returned to the caller
    residualErrors = errorFxn(bestFitModel, matches);
    inlierIndices = find(residualErrors < parameters.inlierDistThreshold);
end


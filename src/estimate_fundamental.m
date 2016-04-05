function [ F ] = estimate_fundamental( matches, bShouldNormalizePts )
%ESTIMATE_FUNDAMENTAL Summary of this function goes here
%   Detailed explanation goes here

    parameters.numIterations = 1000;     %the number of iterations to run
    parameters.subsetSize = 8;          %number of matches to use each iteration
    parameters.inlierDistThreshold = 35;   %the minimum distance for an inlier
    parameters.minInlierRatio = 20/size(matches,1);     %minimum inlier ratio required to store a fitted model
    parameters.bShouldNormalizePts = bShouldNormalizePts;
    
    [F, inlierIndices] = ransac_F(parameters, matches, @fit_fundamental, @calc_residuals);
    display(['Number of inliers is: ', num2str(length(inlierIndices))]);
    display('Mean Residual of Inliers is:');
    display(mean(calc_residuals(F,matches(inlierIndices,:))));
end
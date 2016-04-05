function residuals = calc_residuals(F, matches)
%CALC_RESIDUALS Summary of this function goes here
%   Detailed explanation goes here
   
    numMatches = size(matches,1);
    L = (F * [matches(:,1:2) ones(numMatches,1)]')'; % transform points from 
    % the first image to get epipolar lines in the second image

    % find points on epipolar lines L closest to matches(:,3:4)
    L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
    distances = sum(L .* [matches(:,3:4) ones(numMatches,1)],2); %distances from each pt to its line
    
    residuals = abs(distances);
end


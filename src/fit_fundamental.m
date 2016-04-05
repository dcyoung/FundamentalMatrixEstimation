function [ F ] = fit_fundamental( matches, bShouldNormalize )
%FIT_FUNDAMENTAL Summary of this function goes here
%Output...
%   F: Fundamental Matrix
%Inputs...
%   matches:
%       This is a N x 4 file where the first two numbers of each row
%       are coordinates of corners in the first image and the last two
%       are coordinates of corresponding corners in the second image: 
%       matches(i,1:2) is a point in the first image
%       matches(i,3:4) is a corresponding point in the second image
%   bShouldNormalize:
%       Whether or not the points should be normalized prior to estimating 
%       the fundamental matrix

    %homogenize the points
    x1 = cart_2_homo( matches(:,1:2) );
    x2 = cart_2_homo( matches(:,3:4) );
    
    if bShouldNormalize
        %The linear system to be solved will have terms that involve a
        %product between feature coordinates. If the coordinates are large,
        %then F could end up w/ values that are orders of magnitude
        %different from one another. This could yield poor behavior in
        %practice. So normalize the coordinates, compute F in the
        %normalized coordinates and then adjust it back to the original
        %coordinates later using the normalization transformations
        %display('Normalizing Coordinates');
        [transform_1, x1_norm] = normalize_coordinates(x1);
        [transform_2, x2_norm] = normalize_coordinates(x2);
        x1 = x1_norm;
        x2 = x2_norm;
    end
    
    u1 = x1(:,1);
    v1 = x1(:,2);
    u2 = x2(:,1);
    v2 = x2(:,2);
   
    %group at least 8 known matches together in a useful form
    temp = [ u2.*u1, u2.*v1, u2, v2.*u1, v2.*v1, v2, u1, v1, ones(size(matches,1), 1)];
    %Obtain an estimate for F by solving the homogenous linear system using
    %those matches
    %display('Solving homogenous linear system');
    [~,~,V] = svd(temp);
    f_vec = V(:,9);
    
    F = reshape(f_vec, 3,3); %reshape the 9x1 vec into the 3x3 fund matrix
    F = rank_2_constraint(F); %enforce the rank 2 constraint on F
    
    if bShouldNormalize
        %if F was computed from normalized points, transform it back to
        %the original coordinates
        F = transform_2' * F * transform_1;
    end
end

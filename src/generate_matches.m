function [ matches ] = generate_matches( I1, I2, numMatchesToReport, bPlotMatches)
%GENERATE_MATCHES Summary of this function goes here
%   Detailed explanation goes here

[heightImg1, widthImg1, ~] = size(I1);
grayImg1 = rgb2gray(im2double(I1));
grayImg2 = rgb2gray(im2double(I2));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detect feature points in both images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
discountedPixelPadSize = 5;
[r1, c1] = detect_features(grayImg1, discountedPixelPadSize);
[r2, c2] = detect_features(grayImg2, discountedPixelPadSize);

if(bPlotMatches)
    %display an overlay of the features ontop of the image
    figure; imshow([I1 I2]); hold on; title('Overlay detected features (corners)');
    hold on; plot(c1,r1,'ys'); plot(c2 + widthImg1, r2, 'ys'); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract local neighborhoods around every keypoint in both images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Specify the size of the neighboring region to be described
neighborhoodRadius = 20; 

% Form descriptors simply by "flattening" the pixel values in each 
% neighborhood to one-dimensional vectors
featDescriptions_1 = describe_features(grayImg1, neighborhoodRadius, r1, c1);
featDescriptions_2 = describe_features(grayImg2, neighborhoodRadius, r2, c2);


%%%%%%%%%%%%%%%%
% Match Features
%%%%%%%%%%%%%%%%
[img1_matchedFeature_idx, img2_matchedFeature_idx] = match_features(numMatchesToReport, featDescriptions_1, featDescriptions_2);

match_y1 = r1(img1_matchedFeature_idx);
match_x1 = c1(img1_matchedFeature_idx);
match_y2 = r2(img2_matchedFeature_idx);
match_x2 = c2(img2_matchedFeature_idx);


if(bPlotMatches)
    % Display an overlay of these best matched features on top of the images
    figure; imshow([I1 I2]); hold on; title('Overlay top matched features');
    hold on; plot(match_x1, match_y1,'ys'); plot(match_x2 + widthImg1, match_y2, 'ys'); 

    % Display lines connecting the matched features
    plot_r = [match_y1, match_y2];
    plot_c = [match_x1, match_x2 + widthImg1];
    figure; imshow([I1 I2]); hold on; title('Mapping of top matched features');
    hold on; 
    plot(match_x1, match_y1,'ys');           %mark features from the 1st img
    plot(match_x2 + widthImg1, match_y2, 'ys'); %mark features from the 2nd img
    for i = 1:size(match_y1,1)             %draw lines connecting matched features
        plot(plot_c(i,:), plot_r(i,:));
    end
end


matches = [match_x1, match_y1, match_x2, match_y2];

end


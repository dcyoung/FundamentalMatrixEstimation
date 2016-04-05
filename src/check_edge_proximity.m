function [bNearbyEdge] = check_edge_proximity(r, c, height, width, thresh)
%CHECK_EDGE_PROXIMITY Summary of this function goes here
%   Detailed explanation goes here
   
    rMin = thresh;
    rMax = height-thresh;
    cMin = thresh;
    cMax = width-thresh;
    
    bNearbyEdge = 0;
    if (r < rMin || r > rMax || c < cMin || c > cMax)
        bNearbyEdge = 1;
    end
end

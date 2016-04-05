function [ rank2_mat ] = rank_2_constraint( mat )
%RANK_2_CONSTRAINT Enforce a rank 2 constraint on 3x3 input matrix
%   Detailed explanation goes here

    %display('Enforcing Rank 2 Constraint');
    %take the svd of the input matrix
    [U, S, V] = svd(mat);
    %throw out the smallest singular value
    S(end) = 0;
    %recalcualte the matrix to yield the closest rank 2 constraint of the
    %original
    rank2_mat = U*S*V';
end


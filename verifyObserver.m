function [rowSums,columnSums,singularVals] = verifyObserver(X_obs)
%VERIFYOBSERVER Calculate sums of the rows and columns and singular values of the matrix as
%means of verifying computation of the observer automaton

[rows,columns] = size(X_obs);

rowSums = [];
columnSums = [];

% extract rows
for r = 1:rows
    row = X_obs(r,:);
    rowSum = sum(row);
    rowSums = [rowSums;rowSum];
end

% extract columns
for c = 1:columns
    col = X_obs(:,c);
    colSum = sum(col);
    columnSums = [columnSums;colSum];
end

singularVals = svd(X_obs);

end


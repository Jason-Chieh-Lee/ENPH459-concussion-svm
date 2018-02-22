function correlationData = getCorrelation(A, B)

if (size(A) ~= size(B))
    display('Error: Inputs must have the same dimensions');
    return;
end

numRows = size(A, 1);
correlationData = zeros(numRows, 1);

for i = 1:numRows
    correlationData(i) = corr(A(1,:)', B(1,:)');
end

end
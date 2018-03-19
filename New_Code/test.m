eegStruct = load('BN.mat');
field = fieldnames(eegStruct);
fieldName = field{1};
eegMatrix = eegStruct.(fieldName);
matrix = [1 1;1 1;2 1;2 1;3 2;3 3];
[shannonmat, uniquesymbols, probmatrix] = getShannonEntropy(eegMatrix);
%[shannonmat, uniquesymbols, probmatrix] = getShannonEntropy(matrix)

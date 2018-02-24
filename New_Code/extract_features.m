function [feature_matrix] = extract_features(eeg_mat)
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes here

eeg_struct = load(eeg_mat);
field = fieldnames(eeg_struct);
field_name = field{1};
eeg_matrix = eeg_struct.(field_name);
% Power Spectral Analysis
% Wavelet Decomposition Analysis
% Shannon Entropy Analysis
feature_matrix = eeg_matrix;
end


eeg_struct = load('BN.mat');
field = fieldnames(eeg_struct);
field_name = field{1};
eeg_matrix = eeg_struct.(field_name);

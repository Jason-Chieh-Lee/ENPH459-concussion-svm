function PSD_data = getPSD_Octave(file, savePath)
% Sample file
%file = 'C:\Users\Andrew\Documents\Work\EEGleWave\EEG Report Generation\trunk\code\mat_data\RFC01B0001_20160910_095450.mat'

% NOTE: requires Octave 'signal' package (which requires the 'control' package)
pkg load signal

load(file); % Contains 'data' variable

numDataPoints = length(data); % possibly change so that we can cut off garbage data near beginning and end of sampling
numOfsamples_to = numDataPoints - mod(length(data),90000); % used to find sampling freq

sampDuration = 6; % minutes
%fs = 250;
fs = numOfsamples_to/(sampDuration*60);
t_end = numOfsamples_to/fs;
x = linspace(0,t_end,numDataPoints);

nElec = size(data,1); % includes E65 zero row; we can use this row to store band type
PSD_data = zeros(nElec,4);

for n = 1:nElec

  % Filter data
  % Uses a 2nd-order butterworth filter with respecive low and high cutoff frequencies
  order    = 2;
  fcutlow  = 0.1;
  fcuthigh = 40;
  [b,a]    = butter(order,[fcutlow,fcuthigh]/(fs/2));
  eeg_filt        = filtfilt(b,a,data(n,:));

  %delta (f < 4 Hz)
  fdeltalow  = 0.1;
  fdeltahigh = 4;
  [b,a]    = butter(order,[fdeltalow,fdeltahigh]/(fs/2));
  delta        = filtfilt(b,a,eeg_filt);

  %theta (4 =< f < 8 Hz)
  fthetalow  = 4;
  fthetahigh = 8;
  [b,a]    = butter(order,[fthetalow,fthetahigh]/(fs/2));
  theta        = filtfilt(b,a,eeg_filt);

  %alpha (8 =< f < 14 Hz)
  falphalow  = 8;
  falphahigh = 14;
  [b,a]    = butter(order,[falphalow,falphahigh]/(fs/2));
  alpha        = filtfilt(b,a,eeg_filt);

  %beta (f >= 14)
  fbetalow  = 14;
  fbetahigh = 40;
  [b,a]    = butter(order,[fbetalow,fbetahigh]/(fs/2));
  beta        = filtfilt(b,a,eeg_filt);

  %PSD estimation (used in calculation)
  window = 512;
  fftlength = 2^(nextpow2(window))*2;
  [psd_delta, f_delta] = pwelch(delta, window, 0, fftlength, fs);
  [psd_theta, f_theta] = pwelch(theta, window, 0, fftlength, fs);
  [psd_alpha, f_alpha] = pwelch(alpha, window, 0, fftlength, fs);
  [psd_beta, f_beta] = pwelch(beta, window, 0, fftlength, fs);

  %{
  %% Create plots
  % EEG plots
  %figure;
  %plot(x,e1);
  %hold on;
  %plot(x,e1_filt);
  %hold off;
  ylowlim = -300;
  yhighlim = 300;
  figure;
  subplot(4,2,1);
  plot(x,delta);
  title('\delta');
  %ylim([ylowlim yhighlim]);
  subplot(4,2,3);
  plot(x,theta);
  title('\theta');
  %ylim([ylowlim yhighlim]);
  subplot(4,2,5);
  plot(x,alpha);
  title('\alpha');
  %ylim([ylowlim yhighlim]);
  subplot(4,2,7);
  plot(x,beta);
  title('\beta');
  %ylim([ylowlim yhighlim]);
  %% PSD Plots
  psdlowf = 0;
  psdhighf = 35;
  subplot(4,2,2);
  %plot(10*log10(pxx_delta));
  plot(f_delta, 10*log10(psd_delta));
  xlim([psdlowf, psdhighf]);
  subplot(4,2,4);
  %plot(10*log10(pxx_theta));
  plot(f_theta, 10*log10(psd_theta));
  xlim([psdlowf, psdhighf]);
  subplot(4,2,6);
  %plot(10*log10(pxx_alpha));
  plot(f_alpha, 10*log10(psd_alpha));
  xlim([psdlowf, psdhighf]);
  subplot(4,2,8);
  %plot(10*log10(pxx_beta));
  plot(f_beta, 10*log10(psd_beta));
  xlim([psdlowf, psdhighf]);
  %}

  %% PSD calculations
  acceptableError = 0.01;
  deltaLowIdx = find(f_delta - fdeltalow > acceptableError, 1);        % Get index of 0.1 Hz
  deltaHighIdx = find(f_delta - fdeltahigh > acceptableError, 1);      % Get index of 4 Hz
  PSD_delta = 10*log10(psd_delta);
  PSD_delta = mean(PSD_delta(deltaLowIdx:deltaHighIdx));               % Sum over band frequency range?
  %deltaHighIdx = find(f_delta - 40 > acceptableError, 1);
  %PSD_delta = mean(PSD_delta(1:deltaHighIdx));                         % Sum over 0.1-40Hz frequency range?

  thetaLowIdx = find(f_theta - fthetalow > acceptableError, 1);        % Get index of 4 Hz
  thetaHighIdx = find(f_theta - fthetahigh > acceptableError, 1);      % Get index of 8 Hz
  PSD_theta = 10*log10(psd_theta);
  PSD_theta = mean(PSD_theta(thetaLowIdx:thetaHighIdx));               % Sum over band frequency range?
  %thetaHighIdx = find(f_theta - 40 > acceptableError, 1);
  %PSD_theta = mean(PSD_theta(1:thetaHighIdx));                         % Sum over 0.1-40Hz frequency range?

  alphaLowIdx = find(f_alpha - falphalow > acceptableError, 1);        % Get index of 8 Hz
  alphaHighIdx = find(f_alpha - falphahigh > acceptableError, 1);      % Get index of 14 Hz
  PSD_alpha = 10*log10(psd_alpha);
  PSD_alpha = mean(PSD_alpha(alphaLowIdx:alphaHighIdx));               % Sum over band frequency range?
  %alphaHighIdx = find(f_alpha - 40 > acceptableError, 1);
  %PSD_alpha = mean(PSD_alpha(1:alphaHighIdx));                        % Sum over 0.1-40Hz frequency range?

  betaLowIdx = find(f_beta - fbetalow > acceptableError, 1);        % Get index of 14 Hz
  betaHighIdx = find(f_beta - fbetahigh > acceptableError, 1);      % Get index of 40 Hz
  PSD_beta = 10*log10(psd_beta);
  PSD_beta = mean(PSD_beta(betaLowIdx:betaHighIdx));                % Sum over band frequency range?
  %betaHighIdx = find(f_beta - 40 > acceptableError, 1);
  %PSD_beta = mean(PSD_beta(1:betaHighIdx));                         % Sum over 0.1-40Hz frequency range?
  
  PSD_data(n,:) = [PSD_delta, PSD_theta, PSD_alpha, PSD_beta];

end

%% Store band type
% 0 = delta
% 1 = theta
% 2 = alpha
% 3 = beta

PSD_data(65,:) = [0, 1, 2, 3];

save('-mat-binary', strcat(savePath,'\PSD_data.mat'), 'PSD_data');

end
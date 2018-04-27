function [ waveletDecompFeatures ] = waveletDecompExtract( besaOutput, waveletFunction )
%waveletDecompExtract Extraction of Wavelet Decomposition Features
%   Input:time series, “besaOutput”, and the wavelet function used for
%   wavelet decomposition, waveletFunction
%   Output: n x m matrix consisting of n features and m channels

for i = 1:27
% Wavelet Decomposition
            [C,L] = wavedec(besaOutput(:,i),6,waveletFunction);

% Calculation The Coefficients Vectors
            cD1 = detcoef(C,L,1);                   %NOISE
            cD2 = detcoef(C,L,2);                   %NOISE
            cD3 = detcoef(C,L,3);                   %GAMMA
            cD4 = detcoef(C,L,4);                   %BETA
            cD5 = detcoef(C,L,5);                   %ALPHA
            cD6 = detcoef(C,L,6);                   %THETA
            cA6 = appcoef(C,L,waveletFunction,6);   %DELTA
            %%%% Calculation the Details Vectors and Approximate vectors
            D1 = wrcoef('d',C,L,waveletFunction,1); %NOISE
            D2 = wrcoef('d',C,L,waveletFunction,2); %NOISE
            D3 = wrcoef('d',C,L,waveletFunction,3); %GAMMA
            D4 = wrcoef('d',C,L,waveletFunction,4); %BETA
            D5 = wrcoef('d',C,L,waveletFunction,5); %ALPHA
            D6 = wrcoef('d',C,L,waveletFunction,6); %THETA
            A6 = wrcoef('a',C,L,waveletFunction,6); %DELTA
            count=1;
            
            % Feature Extraction
            % Mean
            waveletDecompFeatures(i,count)=mean(D3);count=count+1;
            waveletDecompFeatures(i,count)=mean(D4);count=count+1;
            waveletDecompFeatures(i,count)=mean(D5);count=count+1;
            waveletDecompFeatures(i,count)=mean(D6);count=count+1;
            waveletDecompFeatures(i,count)=mean(A6);count=count+1;
            % STD
            waveletDecompFeatures(i,count)=std(D3);count=count+1;
            waveletDecompFeatures(i,count)=std(D4);count=count+1;
            waveletDecompFeatures(i,count)=std(D5);count=count+1;
            waveletDecompFeatures(i,count)=std(D6);count=count+1;
            waveletDecompFeatures(i,count)=std(A6);count=count+1;
            % Energy/Power
%             waveletDecompFeatures(i,count)=sum(D3.^2);count=count+1;
%             waveletDecompFeatures(i,count)=sum(D4.^2);count=count+1;
%             waveletDecompFeatures(i,count)=sum(D5.^2);count=count+1;
%             waveletDecompFeatures(i,count)=sum(D6.^2);count=count+1;
%             waveletDecompFeatures(i,count)=sum(A6.^2);count=count+1;
            % Normalized Energy/Power
            totalPower=sum(D3.^2)+sum(D4.^2)+sum(D5.^2)+sum(D6.^2)+sum(A6.^2);
            waveletDecompFeatures(i,count)=sum(D3.^2)/totalPower;count=count+1;
            waveletDecompFeatures(i,count)=sum(D4.^2)/totalPower;count=count+1;
            waveletDecompFeatures(i,count)=sum(D5.^2)/totalPower;count=count+1;
            waveletDecompFeatures(i,count)=sum(D6.^2)/totalPower;count=count+1;
            waveletDecompFeatures(i,count)=sum(A6.^2)/totalPower;count=count+1;
            % Normalized Number of zero crossings
            hzcd = dsp.ZeroCrossingDetector;
            waveletDecompFeatures(i,count)=step(hzcd,D3);count=count+1;
            waveletDecompFeatures(i,count)=step(hzcd,D4);count=count+1;
            waveletDecompFeatures(i,count)=step(hzcd,D5);count=count+1;
            waveletDecompFeatures(i,count)=step(hzcd,D6);count=count+1;
            waveletDecompFeatures(i,count)=step(hzcd,A6);count=count+1;

end

waveletDecompFeatures = transpose(waveletDecompFeatures);
end


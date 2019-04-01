% GaborTextureSegment: Texture Segmentation using Gabor Filters
%
%  seg = GaborTextureSegment(I,K,Sx,Sy,F,Theta,FUN,Wx,Wy,sigma)
%
%  Input and output arguments ([]'s are optional):
%   I     (matrix) of size NxM: Input Image of size NxM. 
%   K     (scalar): The # of expected segments. A param for k-means.
%
%   gamma (scalar): The spatial aspect ratio, x to y. 
%   Lambda (vector): The wavelengthes of the sinusoidal functions. 
%   b      (scalar): The spatial frequency band-width (in octaves)
%   Theta  (vector): The orientations of the gabor filters. 
%   phi    (scalar): The phase offset. 0 is real part of Gabor filter or
%    even-symmetric, pi/2 is imaginary part of Gabor filter or
%    odd-symmetric.
%   shape  (string): shape option for conv2 to apply Gabor filter to image. 
%    'same' or 'valid' or 'full'. See help conv2. 
%   Note: sigma (scalar): The spread of Gabor filter or the standard
%    deviation of Gaussian is automatically computed from lambda and b. 
%
%   seg    (matrix) of size NxM: The segmented image. Each element has its
%     partition id.  
%
% Author : Naotoshi Seo, sonots@umd.edu
% Date   : Oct, 2006
function seg = GaborTextureSegment(I, K, gamma, Lambda, b, Theta, phi, shape)
 [nRow, nCol, C] = size(I);

 % Step 1. Gabor Filter bank
 i = 0;
 for lambda = Lambda
     for theta = Theta
         i = i + 1;
         D = gabor2(I, gamma, lambda, b, theta, phi, shape);
         % Normalize into [0, 1]
         D = D - min(reshape(D, [], 1)); D = D / max(reshape(D, [], 1));
         %figure; imshow(uint8(D * 255));
         % Adjust image size to the smallest size if 'valid' (Cut off)
         if (isequal(shape, 'valid') && i >= 2)
             [nRow, nCol, C] = size(O(:, :, i-1));
             [Nr, Nc, C] = size(D);
             DNr = (Nr - nRow)/2;
             DNc = (Nc - nCol)/2;
             D = D(1+floor(DNr):Nr-ceil(DNr), 1+floor(DNc):Nc-ceil(DNc));
         end
         O(:, :, i) = D;
     end
 end
 [nRow, nCol, N] = size(O);

 % Step 2. Energy (Feature Extraction)
 % Step 2-1. Nonlinearity
 for i=1:N
     D = O(:, :, i);
     alpha = 1; 
     D = tanh(double(O(:, :, i)) .* alpha); % Eq. (3). Input is [0, 1]
     % Normalize into [0, 1] although output of tanh is originally [0, 1]
     D = D - min(reshape(D, [], 1)); D = D / max(reshape(D, [], 1));
     %figure; imshow(uint8(D * 255));         
     O(:, :, i) = D;    
 end

 % Step 2-2. Smoothing
 for i=1:N
     D = O(:, :, i);
     lambda = Lambda(floor((i-1)/length(Theta))+1);
     % (1) constant
     % sigma = 5; 
     % (2) Use lambda. 0.5 * lambda should be near equal to gabor's sigma 
     % sigma = .5 * lambda;  
     % (3). Use gabor's sigma
     sigma = (1 / pi) * sqrt(log(2)/2) * (2^b+1) / (2^b-1) * lambda; 
     sigma = 3 * sigma; 
     D = gauss2(D, sigma, shape);  % Instead of Eq, (4) Avg filter
     % Normalize into [0, 1]
     D = D - min(reshape(D, [], 1)); D = D / max(reshape(D, [], 1));
     %figure; imshow(uint8(D * 255));         
     % Adjust image size to the smallest size if 'valid' (Cut off)
     if (isequal(shape, 'valid') && i >= 2)
         [nRow, nCol, C] = size(P(:, :, i-1));
         [Nr, Nc, C] = size(D);
         DNr = (Nr - nRow)/2;
         DNc = (Nc - nCol)/2;
         D = D(1+floor(DNr):Nr-ceil(DNr), 1+floor(DNc):Nc-ceil(DNc));
     end
     P(:, :, i) = D;
 end
 O = P; clear P;
 [nRow, nCol, N] = size(O);


 % Step 3. Clustering
 % Step 3-1. Adding coordinates information to involves adjacency
 for i=1:nRow
     for j=1:nCol
         O(i, j, N+1) = i / nRow; % [0, 1]
         O(i, j, N+2) = j / nCol;
     end
 end

 % Step 3-2. Clustering
 data = reshape(O, [], size(O, 3)); % (# of data) x (# of dimensions)  
 [cluster, codebook] = kmeans_light(data, K);
 seg = reshape(cluster, nRow, nCol, 1); % 2D
end
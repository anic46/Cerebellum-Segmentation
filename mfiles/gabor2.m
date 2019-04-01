 quency band-width (in octaves)
%   theta (scalar): The orientation of the gabor filter. 
%   phi   (scalar): The phase offset. 0 is the real parts of Gabor filter or
%    even-symmetric, pi/2 is the imaginary parts of Gabor filter or
%    odd-symmetric.
%   Note: sigma (scalar), the spread of Gabor filter or the standard
%    deviation of Gaussian is automatically computed from lambda and b. 
%  [shape] (strings): Shape for conv2. See help conv2. Default is 'same'. 
%
%   GO    (matrix) of size NxM: Output images which was applied Gabor
%    filters. 
%   [GF]  (matrix) of size (2Sx+1)x(2Sy+1): Gabor filter. 
%
% Author : Naotoshi Seo, sonots(at)umd.edu
% Date   : Oct, 2006
function [GO, GF] = gabor2(I, gamma, lambda, b, theta, phi, shape);
if nargin < 7, shape = 'same';, end;
if isa(I, 'double') ~= 1, I = double(I); end

sigma = (1 / pi) * sqrt(log(2)/2) * (2^b+1) / (2^b-1) * lambda;
Sy = sigma * gamma;
for x = -fix(sigma):fix(sigma)
    for y = -fix(Sy):fix(Sy)
        xp = x * cos(theta) + y * sin(theta);
        yp = y * cos(theta) - x * sin(theta);
        GF(fix(Sy)+y+1,fix(sigma)+x+1) = ...
            exp(-.5*(xp^2+gamma^2*yp^2)/sigma^2) * cos(2*pi*xp/lambda+phi) ...
           ; %/ (2*pi*(sigma^2/gamma)); 
           % Normalize if you use different sigma (lambda or b)
    end
end

GO = conv2(I, double(GF), shape);
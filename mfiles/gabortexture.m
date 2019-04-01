function demo_GaborTextureSegment
 imfile = 'data.10.png';
 I = imread(imfile); K = 5;
 %I = rgb2gray(I); 
 %I = imresize(I, [256 256]);
 [Nr, Nc, D] = size(I);
 gamma = 1; b = 1; Theta = 0:pi/6:pi-pi/6; phi = 0; shape = 'valid';
 %[4 8 16 ...] sqrt(2) % Jain
 % Lambda = Nc./((2.^(2:log2(Nc/4))).*sqrt(2));
 % J. Zhang
 J = (2.^(0:log2(Nc/8)) - .5) ./ Nc;
 F = [ (.25 - J) (.25 + J) ]; F = sort(F); Lambda = 1 ./ F;
 seg = GaborTextureSegment(I, K, gamma, Lambda, b, Theta, phi, shape);
 %imseg = uint8(seg) * floor(255 / K); % cluster id to gray scale (max 255)
 [nRow, nCol] = size(seg);
 color = [0 0 0; 255 255 255; 255 0 0; 0 255 0; 0 0 255]; % 5 colors reserved
 imseg = zeros(nRow*nCol, 3);
 for i=1:K
     idx = find(seg == i);
     imseg(idx, :) = repmat(color(i, :), [], length(idx));
 end
 imseg = reshape(imseg, nRow, nCol, 3);
 figure; imshow(imseg);
 imwrite(imseg, sprintf('seg.%s', imfile));
end
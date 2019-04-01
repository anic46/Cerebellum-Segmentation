% -----------------------------------------------------------------
% This program is used to extract the texture features from the 116
% brodatz album texture (49 128x128 images are obtained per class)
% -----------------------------------------------------------------
clear;
% 
% fn = inputfiles;
% sz = 512;
% 
% out_fn = outputfiles;

% --------------- generate the Gabor FFT data ---------------------

stage = 3;
orientation = 4;
N = 256;
freq = [0.3 1.2];
flag = 1;

j = sqrt(-1);

for s = 1:stage,
    for n = 1:orientation,
        [Gr,Gi] = Gabor_M(N,[s n],freq,[stage orientation],flag);
        F = fft2(Gr+j*Gi);
        F(1,1) = 0;
        F=fftshift(F);
        GW(N*(s-1)+1:N*s,N*(n-1)+1:N*n) = F;
    end;
end;

% -----------------------------------------------------------------

img=rgb2gray(uint8(imread('dataset3_35.png')));
F=FeaGaborbrodatz(img,GW,N,stage,orientation);
% height = 7;
% width = 7;
% 
% for i = 1:40,
%     filename = extractName(fn(i,:));
%     texture = loadimg(filename,sz);
% 
%     A = zeros(stage*orientation*2,height*width);
%     for h = 1:height,
%         for w = 1:width,
%             [i h w]
%             img = texture((h-1)*64+1:(h-1)*64+128, (w-1)*64+1:(w-1)*64+128);
%             F = Fea_Gabor_brodatz(img, GW, N, stage, orientation);
%             A(:,(h-1)*width+w) = [F(:,1); F(:,2)];
%         end;  
%     end;
% 
%     output = [ extractName(out_fn(i,:)) '.fea'];
%     fid = fopen(output, 'w');
%     fwrite(fid, A, 'float');
%     fclose(fid);
% end;

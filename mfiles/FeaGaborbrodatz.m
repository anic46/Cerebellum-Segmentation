function F = FeaGaborbrodatz(img,GW,N,stage,orientation)

A = fft2(img);

F = [];
z = zeros(1,2);

for s = 1:stage,
    for n = 1:orientation, 
        D = abs(ifft2(A.*GW(N*(s-1)+1:N*s,N*(n-1)+1:N*n)));
        D=D-min(min(D));
        D=D-mean(mean(D));
        figure,imshow(D/max(max(D)));
        
%         z(1,1) = mean(mean(D));
%         z(1,2) = sqrt(mean(mean((D-z(1,1)*ones(128,128)).^2))); 
%         F((s-1)*orientation+n,1:2) = z;
    end;
end;


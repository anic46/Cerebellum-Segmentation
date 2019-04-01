gg=gnet(:,:,6)-min(min(gnet(:,:,6)))*ones(256);
figure,imshow(imadjust(gg/max(max(gg)));
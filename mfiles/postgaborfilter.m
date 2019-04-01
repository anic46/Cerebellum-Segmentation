counterzz=0;
for countphi=1:7
for countsi=1:7
counterzz=counterzz+1;
gg(:,:,counterzz)=gabout(:,:,11,counterzz)-min(min(gabout(:,:,11,counterzz)));
figure,imshow(imadjust(uint8(gg(:,:,counterzz))));

end
end
figure,imshow(imadjust(img(:,:,11)));
gabout1=abs(gabout);
counterzz=0;
for countphi=1:6
for countsi=1:6
counterzz=counterzz+1;
figure,imshow(imadjust(img(:,:,8))/2+imadjust(gabout1(:,:,8,counterzz)/max(max(gabout1(:,:,8,counterzz)))));
%gg1(:,:,counterzz)=gabout(:,:,9,counterzz)-min(min(gabout(:,:,9,counterzz)));
end
end
% for i=1:110
%     gabout3(:,:,i)=imadjust(gabout1(:,:,i,counterzz)/max(max(gabout1(:,:,i,counterzz))));
% end
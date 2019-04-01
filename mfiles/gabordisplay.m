[I1,dim,dtype]=readanalyze('dataset2.hdr');

for i=1:48
    for j=1:22
        gabout2(:,:,j)=imrotate(gabout1(:,:,j,i),-90);
    end
gg=abs(gabout2); % figure,imshow(imadjust(gg/max(max(gg))));
gg1=255*gg/max(max(max(gg)));
%imwrite(gg/max(max(gg)),strcat('dataset1/feature',num2str(i),'.png'));
writeanalyze(gg1,strcat('dataset5/feature',num2str(i),'.hdr'),dim,dtype);
end

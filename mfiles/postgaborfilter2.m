poi=8;
for i=1:size(gabout,1)
    for j=1:size(gabout,2)
        for k=1:1
            for l=1:size(gabout,4)
                if gabout(i,j,poi,l)<0
                gabout1(i,j,k,l)=-(gabout(i,j,poi,l));
                else
                    gabout1(i,j,k,l)=gabout(i,j,poi,l);
                end
            end
        end
    end
end
% for i=1:36
% gg=gabout(:,:,5,i)-min(min(gabout(:,:,5,i))); figure,imshow(imadjust(gabout1(:,:,1,i)/max(max(gabout1(:,:,1,i)))));
% end
poi=8;
gnet=mean(gabout(:,:,:,41:64),4);
gnet=mean(gabout(:,:,:,1:32),4)+gnet;
% gnet=gnet+mean((gabout(:,:,:,25:36)),4);
min(min(gnet(:,:,poi)))
gg=gnet(:,:,poi)-min(min(gnet(:,:,poi)))*ones(256);
figure,imshow(((adapthisteq(gg/max(max(gg))))));
figure,imshow(imadjust(img(:,:,poi))/2+imadjust(gg/max(max(gg)))/2)
figure,imshow(imadjust(img(:,:,poi)))
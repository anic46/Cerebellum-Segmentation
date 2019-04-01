function roiextractor(imageno,roino)
    strcat('subject',num2str(imageno),'.img')
    [I1,dim,dtype]=readanalyze(strcat('subject',num2str(imageno),'_mask.img'));
    I2=(I1>roino-1);%&(I1<roino+1);
    dtype
    strcat('subject',num2str(imageno),'_finalmask.img')
    writeanalyze(255*I2,strcat('subject',num2str(imageno),'_finalmask.img'),dim,dtype);
%     for i=1:181
%     figure,imshow(I2(:,:,i));
%     end
    
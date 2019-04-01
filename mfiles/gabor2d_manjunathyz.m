clear all;
[I1,dim,dtype]=readanalyze('dataset1.img');

counter1=0;
%figure,imshow(img);


windowsize=7;
counter=0;
noofscales=3;
fmax=0.4;
fmin=0.1;
noofangles=4;
a=double(0);
for scales=0:2
a=double((fmax/fmin)^(1/(noofscales-1)))
gsize=15;
u0=fmax/(a^(noofscales-scales))
Su=((a-1)*u0)/((a+1)*sqrt(2*log(2)));
Sx=1/(2*pi*Su)
z = -2*log(2)*(Su^2/u0);
Sv = tan(pi/(2*noofangles))*(u0-2*log(2*Su^2/u0))/sqrt(2*log(2)-z*z/(Su^2));
Sy=1/(2*pi*Sv)
for countt=0:noofangles-1
    counter=counter+1;
    for i=1:size(I1,2)
    img=adapthisteq(imrotate(uint8(squeeze(I1(:,i,:))),0));
    %img=im2double(img);
    I=img;
    theta=(pi/noofangles)*(countt);
    theta*180/pi;
    if isa(I,'double')~=1 
        I = im2double(I);
    end
    clear G
    for x = -gsize:gsize
            for y = -gsize:gsize               
                xPrime = double(x * cos(theta)) + double(y * sin(theta));
                yPrime = double(y * cos(theta)) - double(x * sin(theta));
                G(gsize+x+1,gsize+y+1) =a^(noofscales-scales)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2)))*cos(2*pi*u0*xPrime)/(2*pi*Sx*Sy);
                G1(gsize+x+1,gsize+y+1) = a^(noofscales-scales)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2)))*sin(2*pi*u0*xPrime)/(2*pi*Sx*Sy);
             end
    end
    G=G-mean(mean(G))*ones(size(G));
    
      x=-gsize:gsize;
      y=-gsize:gsize; 
     % figure,surf(x,y,G);
%     %figure,surf(x,y,G1);
    %figure,imshow(G1);
    %Gnet=fft2(G+i*G1);
%     x=-gsize:gsize;
%     y=-gsize:gsize;
%     figure,surf(x,y,G(:,:,1));
%     for i=1+gsize:size(img,1)-gsize
%         for j=1+gsize:size(img,2)-gsize
%             I=img(i-gsize:i+gsize,j-gsize:j+gsize);
%             I=double(I);     
%            
%      Regabout(i,j)=mean(mean(abs(conv2(I,G))));% conv2(I,G,'same');
%      Imgabout(i,j)=mean(mean(abs(conv2(I,G1))));% conv2(I,G1,'same');
%         end
%     end
    Regabout=conv2(I,double(G),'same');
    Imgabout=conv2(I,double(G1),'same');
    %Regabout(:,:,offset)=Regabout(:,:,offset)-mean(mean(Regabout(:,:,offset)))*ones(size(Regabout(:,:,offset)));
%      if (var(var(Regabout(:,:,offset)))<10^-4)
%          Regabout(:,:,offset)=zeros(size(Regabout(:,:,offset)));
%      end
    max(max(Regabout))
    max(max(Imgabout))
    gaboutreal(:,i,:) =imfilter(uint8(255*Regabout/1800),fspecial('gaussian',[3 3],1));
    gaboutimag(:,i,:) =imfilter(uint8(128*Imgabout/1800+128),fspecial('gaussian',[3 3],1));
    end
%     max(max(max(gaboutreal)))
%     max(max(max(gaboutimag)))
    %greal=imfilter(uint8(255*gaboutreal(:,:,i)/max(max(gaboutreal(:,:,i)))),fspecial('gaussian',[3 3],1));
    %figure,imshow((imfilter(greal,fspecial('gaussian',[3 3],1))));
    %max(max(max(gaboutreal)))*10
     writeanalyze(gaboutreal,strcat('featurerealyz',num2str(counter),'.img'),dim,dtype);
     %greal=imfilter(uint8(255*gaboutimag(:,:,i)/max(max(gaboutimag(:,:,i)))+128),fspecial('gaussian',[3 3],1));
     writeanalyze(gaboutimag,strcat('featureimagyz',num2str(counter),'.img'),dim,dtype);
%gg=gaboutreal(:,:,counter);
    %gg=gg-mean(mean(gg));
 %figure,imshow(imadjust(gg/max(max(gg))))
end
end
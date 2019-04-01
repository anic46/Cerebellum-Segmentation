%clc;
clear all;
[I1,dim,dtype]=readanalyze('Breast/YS4.img');
I1=I1/max(max(max(I1)))*255;
counter1=0;
%figure,imshow(img);


windowsize=15;
counter=0;
noofscales=4;
fmax=0.8;
fmin=0.2;
noofangles=4;
a=double(0);
for scales=0:noofscales-1
a=double((fmax/fmin)^(1/(noofscales-1)))
gsize=7;
u0=fmax/(a^(noofscales-scales));
Su=((a-1)*u0)/((a+1)*sqrt(2*log(2)));
Sx=1/(2*pi*Su)
Sv=tan(pi/(2*noofangles))*(u0-2*log(2)*(Su^2/u0))/(sqrt(2*log(2)-(2*log(2))^2*Su^2/u0^2));
Sy=1/(2*pi*Sv)
for countt=0:noofangles-1
    counter=counter+1;
    for i=40:40
    img=adapthisteq(imrotate(uint8(I1(:,:,i)),90));
   
    %img=im2double(img);
    I=img;
    theta=(pi/noofangles)*(countt);
    theta*180/pi;
    if isa(I,'double')~=1 
        I = double(I);
    end
    clear G
    for x = -gsize:gsize
            for y = -gsize:gsize               
                xPrime = (x * cos(theta+pi/2) + y * sin(theta+pi/2));
                yPrime = (y * cos(theta+pi/2) - x * sin(theta+pi/2));
                G(gsize+x+1,gsize+y+1) = a^(noofscales-scales)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2))*cos(2*pi*u0*xPrime))/(2*pi*Sx*Sy);
                G1(gsize+x+1,gsize+y+1) = a^(noofscales-scales)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2))*sin(2*pi*u0*xPrime))/(2*pi*Sx*Sy);
             end
    end
    G=G-mean(mean(G))*ones(size(G));
    
%      x=-gsize:gsize;
%      y=-gsize:gsize;
%      figure,surf(x,y,G);
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
    gaboutreal(:,:,i) =abs(Regabout);
    gaboutimag(:,:,i) =abs(Imgabout);
    gabout(:,:,i)=sqrt(Regabout.^2+Imgabout.^2);
    end
    
    figure,imshow(imadjust(uint8((Regabout/0.1))));
    %max(max(max(gaboutreal)))*10
    filter=fspecial('average',[5 5]);
    gabout1=gabout(:,:,i);
    gaboutmean=imfilter(gabout1,filter);
    gaboutsqrmean=imfilter(gabout1.^2,filter);
    gaboutstd=sqrt(gaboutsqrmean-gaboutmean.^2);
    figure,imshow(imadjust(gaboutmean/max(max(gaboutmean))));
    %writeanalyze(gaboutmean/0.2*255,strcat('dataset1_multi/featuremean',num2str(counter),'.img'),dim,dtype);
    %writeanalyze(gaboutstd/0.2*255,strcat('dataset1_multi/featurestd',num2str(counter),'.img'),dim,dtype);
    %gg=gaboutreal(:,:,counter);
    %gg=gg-mean(mean(gg));
 %figure,imshow(imadjust(gg/max(max(gg))))
end
end
figure,imshow(img);
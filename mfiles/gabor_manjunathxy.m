%clc;
clear all;
[I1,dim,dtype]=readanalyze('dataset2.img');

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
gsize=7;
u0=fmax/(a^(noofscales-scales))
Su=((a-1)*u0)/((a+1)*sqrt(2*log(2)));
Sx=1/(2*pi*Su)
z = -2*log(2)*(Su^2/u0);
Sv = tan(pi/(2*noofangles))*(u0-2*log(2*Su^2/u0))/sqrt(2*log(2)-z*z/(Su^2));
Sy=1/(2*pi*Sv)
for countt=0:noofangles-1
    counter=counter+1;
    for i=1:size(I1,3)
    img=(imrotate((squeeze(I1(:,:,i))),90));
%     img=adapthisteq(uint8(255*(img1-min(min(min(I1))))/(max(max(max(I1)))-min(min(min(I1))))));
   
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
                xPrime = dim(1)*double(x * cos(theta)) + dim(2)*double(y * sin(theta));
                yPrime = dim(2)*double(y * cos(theta)) - dim(1)*double(x * sin(theta));
                G(gsize+x+1,gsize+y+1) =a^(noofscales-scales)*cos(2*pi*u0*xPrime)/(2*pi*Sx*Sy)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2)));
                G1(gsize+x+1,gsize+y+1) =a^(noofscales-scales)*sin(2*pi*u0*xPrime)/(2*pi*Sx*Sy)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2)));
             end
    end
    G=G-mean(mean(G))*ones(size(G));
    Regabout=conv2(I,double(G),'same');
    Imgabout=conv2(I,double(G1),'same');
    gaboutreal(:,:,i) =(imrotate(Regabout,-90));%imfilter((Regabout),fspecial('average',[0 0]));
    gaboutimag(:,:,i) =(imrotate(Imgabout,-90));%imfilter(Imgabout,fspecial('average',[0 0]));
    end
    x=-gsize:gsize;
    y=-gsize:gsize; 
    figure,surf(x,y,G);
    writeanalyze(128*gaboutreal/max(max(max(gaboutreal)))+128,strcat('dataset2_multi/featurerealxy',num2str(counter),'.img'),dim,dtype);
    writeanalyze(128*gaboutimag/max(max(max(gaboutimag)))+128,strcat('dataset2_multi/featureimagxy',num2str(counter),'.img'),dim,dtype);

end
end
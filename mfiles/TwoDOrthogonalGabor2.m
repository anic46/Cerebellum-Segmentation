function TwoDOrthogonalGabor(inputimage,fmax,fmin,noofangles,noofscales,gaborfilterradius,applygaussiansmoothing)
[I1,dim,dtype]=readanalyze(inputimage);
inputimagename=inputimage(1:size(inputimage,2)-4);
system(['mkdir ',inputimagename,'_multi']);
if (nargin<7)
applygaussiansmoothing=0;
end
%applying gabor filter along xy dimension
gaussianwindowsize=4;
counter=0;
gsize=gaborfilterradius;
a=double(0);
for scales=0:noofscales-1
a=double((fmax/fmin)^(1/(noofscales-1)))
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
	if applygaussiansmoothing==1
	gaboutreal(:,:,i) =imfilter(gaboutreal(:,:,i),fspecial('gaussian',[gaussianwindowsize gaussianwindowsize],2));
    gaboutimag(:,:,i) =imfilter(gaboutimag(:,:,i),fspecial('gaussian',[gaussianwindowsize gaussianwindowsize],2));
    end
    end
    % x=-gsize:gsize;
    % y=-gsize:gsize; 
    % figure,surf(x,y,G);
    writeanalyze(128*gaboutreal/max(max(max(gaboutreal)))+128,strcat(inputimagename,'_multi/featurerealxy',num2str(counter),'.img'),dim,dtype);
    writeanalyze(128*gaboutimag/max(max(max(gaboutimag)))+128,strcat(inputimagename,'_multi/featureimagxy',num2str(counter),'.img'),dim,dtype);

end
end
%now applying gabor filter along xz dimension
counter=0;
for scales=0:2
a=double((fmax/fmin)^(1/(noofscales-1)))
u0=fmax/(a^(noofscales-scales))
Su=((a-1)*u0)/((a+1)*sqrt(2*log(2)));
Sx=1/(2*pi*Su)
z = -2*log(2)*(Su^2/u0);
Sv = tan(pi/(2*noofangles))*(u0-2*log(2*Su^2/u0))/sqrt(2*log(2)-z*z/(Su^2));
Sy=1/(2*pi*Sv)
for countt=0:noofangles-1
    counter=counter+1;
    for i=1:size(I1,2)
    img=(imrotate(uint8(squeeze(I1(i,:,:))),90));
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
                xPrime = dim(3)*double(x * cos(theta)) + dim(2)*double(y * sin(theta));
                yPrime = dim(2)*double(y * cos(theta)) - dim(3)*double(x * sin(theta));
                G(gsize+x+1,gsize+y+1) =a^(noofscales-scales)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2)))*cos(2*pi*u0*xPrime)/(2*pi*Sx*Sy);
                G1(gsize+x+1,gsize+y+1) = a^(noofscales-scales)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2)))*sin(2*pi*u0*xPrime)/(2*pi*Sx*Sy);
             end
    end
    G=G-mean(mean(G))*ones(size(G));


    Regabout=conv2(I,double(G),'same');
    Imgabout=conv2(I,double(G1),'same');
    gaboutreal(i,:,:) =(imrotate(Regabout,-90));%imfilter((Regabout),fspecial('average',[0 0]));
    gaboutimag(i,:,:) =(imrotate(Imgabout,-90));%imfilter(Imgabout,fspecial('average',[0 0]));
	if applygaussiansmoothing==1
	gaboutreal(i,:,:) =imfilter(gaboutreal(:,:,i),fspecial('gaussian',[gaussianwindowsize gaussianwindowsize],2));
    gaboutimag(i,:,:) =imfilter(gaboutimag(:,:,i),fspecial('gaussian',[windowsize gaussianwindowsize],2));
    end
    end
    writeanalyze(128*gaboutreal/max(max(max(gaboutreal)))+128,strcat(inputimagename,'_multi/featurerealxz',num2str(counter),'.img'),dim,dtype);
    writeanalyze(128*gaboutimag/max(max(max(gaboutimag)))+128,strcat(inputimagename,'_multi/featureimagxz',num2str(counter),'.img'),dim,dtype);

end
end
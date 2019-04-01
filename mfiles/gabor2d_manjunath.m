function gabor2d_manjunath(inputimage,lowfreqlimit,highfreqlimit,noofscales,noofangles,gaborfilterradius,magresponse)
clc
I1=imread(inputimage);
if isrgb(I1)
    I1=rgb2gray(I1);
end
if isa(I1,'double')~=1 || max(max(I1))==255
    I1=im2double(uint8(I1));
end
figure,imshow(I1);
if (nargin==6)
    magresponse=0;
end
counter=0;
fmax=highfreqlimit;
fmin=lowfreqlimit;
a=double(0);
for scales=0:noofscales-1
    a=double((fmax/fmin)^(1/(noofscales-1)))
    gsize=gaborfilterradius;
    u0=fmax/(a^(noofscales-scales))
    Su=((a-1)*u0)/((a+1)*sqrt(2*log(2)));
    Sx=1/(2*pi*Su)
    z = -2*log(2)*(Su^2/u0);
    Sv = tan(pi/(2*noofangles))*(u0-2*log(2*Su^2/u0))/sqrt(2*log(2)-z*z/(Su^2));
    Sy=1/(2*pi*Sv)
    for countt=0:noofangles-1
        
        counter=counter+1;
        I=I1;
        theta=(pi/noofangles)*(countt);
        if isa(I,'double')~=1
            I = double(I);
        end
        clear G
        for x = -gsize:gsize
            for y = -gsize:gsize
                xPrime = double(x * cos(theta+pi/2)) + double(y * sin(theta+pi/2));
                yPrime = double(y * cos(theta+pi/2)) - double(x * sin(theta+pi/2));
                Greal(gsize+x+1,gsize+y+1) =a^(noofscales-scales)*cos(2*pi*u0*xPrime)/(2*pi*Sx*Sy)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2)));
                Gimag(gsize+x+1,gsize+y+1) =a^(noofscales-scales)*sin(2*pi*u0*xPrime)/(2*pi*Sx*Sy)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2)));
            end
        end
        Greal=Greal-mean(mean(Greal))*ones(size(Greal));
        disp(strcat('computing features for scale=',num2str(scales),' & angle=',num2str(180/noofangles*countt),' & frequency=',num2str(u0)));
       size(Greal)
       size(Gimag)
       size(I)
        Regabout=conv2(I,double(Greal),'same');
        Imgabout=conv2(I,double(Gimag),'same');
        if magresponse==1
            Regabout=abs(Regabout);
            Imgabout=abs(Imgabout);
        end
        gaboutreal =imfilter(Regabout,fspecial('gaussian',[3 3],2));
        gaboutimag =imfilter(Imgabout,fspecial('gaussian',[3 3],2));
        outputimagename=inputimage(1:size(inputimage,2)-4);
        min(min(gaboutreal))
        min(min(gaboutimag))
        imwrite(gaboutreal/max(max(gaboutreal)),strcat(outputimagename,'_featurereal_angle_',num2str(180/noofangles*countt),'_scale_',num2str(scales),'.png'));
        imwrite(0.5+0.5*gaboutimag/max(max(gaboutimag)),strcat(outputimagename,'_featureimag_angle_',num2str(180/noofangles*countt),'_scale_',num2str(scales),'.png'))
    end
end
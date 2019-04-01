%-- 6/23/09 12:33 PM --%
save
help save
save matlab.mat gabout
for i=1:64
gg=gabout(:,:,5,i)-min(min(gabout(:,:,5,i))); figure,imshow(imadjust(gabout1(:,:,1,i)/max(max(gabout1(:,:,1,i)))));
end
close all
gabout1=abs(gabout);
for i=1:64
gg=gabout(:,:,5,i)-min(min(gabout(:,:,5,i))); figure,imshow(imadjust(gabout1(:,:,5,i)/max(max(gabout1(:,:,5,i)))));
end
close all
Sx
%-- 6/26/09  4:52 PM --%
for i=1:64
gg=abs(gabout(:,:,5,i)); figure,imshow(imadjust(gg/max(max(gg)))));
end
for i=1:64
gg=abs(gabout(:,:,5,i)); figure,imshow(imadjust(gg/max(max(gg))));
end
close all
for i=1:32
gg=abs(gabout(:,:,10,i)); figure,imshow(imadjust(gg/max(max(gg))));
end
figure,imshow(imadjust(img(:,:,10)))
for i=1:8
gg=abs(gabout(:,:,10,i)); figure,imshow(imadjust(gg/max(max(gg))));
end
close all
for i=1:8
gg=abs(gabout(:,:,10,i)); figure,imshow(imadjust(gg/max(max(gg)))+imadjust(img(:,:,10)));
end
save gabout_dataset gabout
%-- 6/27/09  4:19 PM --%
countphi
countsi
for i=1:16
gg=abs(gabout(:,:,10,i)); figure,imshow(imadjust(gg/max(max(gg)))+imadjust(img(:,:,10)));
end
close all
for i=1:16
gg=abs(gabout(:,:,10,i)); figure,imshow(imadjust(gg/max(max(gg)))/2+imadjust(img(:,:,10))/2);
end
for i=1:16
gg=abs(gabout(:,:,20,i)); figure,imshow(imadjust(gg/max(max(gg)))/2+imadjust(img(:,:,20))/2);
end
close all
for i=1:16
gg=abs(gabout(:,:,15,i)); figure,imshow(imadjust(gg/max(max(gg)))/2+imadjust(img(:,:,15))/2);
end
for i=1:16
gg=abs(gabout(:,:,15,i)); figure,imshow(imadjust(gg/max(max(gg)))/2);
end
close all
%-- 6/29/09 12:39 PM --%
for i=1:48
gg=abs(gabout(:,:,15,i)); figure,imshow(imadjust(gg/max(max(gg)))/2);
end
close all
%-- 7/02/09 11:29 AM --%
for i=1:3
gg=abs(gabout(:,:,15,i)); figure,imshow(imadjust(gg/max(max(gg)))/2);
end
%-- 7/08/09  2:20 PM --%
[I1,dim,dtype]=readanalyze('603H20595-20040722.T1.byte_acpc_str.img');
for i=1:110
imwrite(I1(:,:,i),strcat('I1',num2str(i),'.png'));
end
%-- 7/08/09  2:24 PM --%
[I1,dim,dtype]=readanalyze('dataset1.img');
for i=1:110
imwrite(I1(:,:,i),strcat('I1-1',num2str(i),'.png'));
end
for i=1:110
system(strcat('./itkScalarToFractalImageFilterTest 2 I1-1',num2str(i),'.png I2-1',num2str(i),'.png'));
end
for i=1:110
system(strcat('./itkScalarToFractalImageFilterTest 2 I1-1',num2str(i),'.png I2-1',num2str(i),'.img'));
end
%-- 7/08/09  4:00 PM --%
for i=1:110
%-- 7/09/09 12:10 PM --%
for i=1:110
system(strcat('./itkScalarToFractalImageFilterTest 2 I1',num2str(i),'.png I2',num2str(i),'.img'));
end
for i=1:110
system(strcat('./itkScalarToFractalImageFilterTest 2 I1',num2str(i),'.png I2',num2str(i),'.img'));
end
%-- 7/10/09  2:51 PM --%
[I1,dim,dtype]=readanalyze('dataset5/dataset5.img');for i=1:110
imwrite(I1(:,:,i),strcat('dataset5',num2str(i),'.png'));
end
[I1,dim,dtype]=readanalyze('dataset5/dataset5.img');for i=1:110
imwrite(I1(:,:,i),strcat('dataset5/dataset5',num2str(i),'.png'));
end
for i=1:110
system(strcat('./itkScalarToFractalImageFilterTest 2 dataset5/dataset5',num2str(i),'.png dataset5/dataset5_fd',num2str(i),'.img'));
end
[I1,dim,dtype]=readanalyze('dataset5/dataset5.img');for i=1:110
imwrite(I1(:,:,i)*255,strcat('dataset5',num2str(i),'.png'));
[I1,dim,dtype]=readanalyze('dataset5/dataset5.img');
max(max(max(I1)))
I1=uint8(I1);
for i=1:110
imwrite(I1(:,:,i),strcat('dataset5',num2str(i),'.png'));
end
for i=1:110
imwrite(I1(:,:,i),strcat('dataset5/',num2str(i),'.png'));
end
for i=1:110
system(strcat('./itkScalarToFractalImageFilterTest 2 dataset5/',num2str(i),'.png dataset5/dataset5_fd',num2str(i),'.img'));
end
x=[1 2 3 4 5];
dwt(x)
dwt(x,'db2')
dwt2(double(img),'haar');
img=imread('5x5image.png');
dwt2(double(img),'haar');
dwt2(double(img),'haar')
dwt2(double(rgb2gray(img)),'haar')
[a b c d]=dwt2(double(rgb2gray(img)),'haar');
a
b
c
d
img=imread('dataset2_39.png');
[ca cb cc cd]=dwt2(double(rgb2gray(img)),'db16');
figure,imshow(ca);
figure,imshow(ca-min(min(ca)));
min(min(ca))
max(max(ca))
gg=ca-min(min(ca))*ones(256);
gg=ca-min(min(ca))*ones(143);
gg1=gg/max(max(gg));
figure,imshow(gg1);
gg=cb-min(min(cb))*ones(143);
gg1=gg/max(max(gg));
figure,imshow(gg1);
gg=cc-min(min(cc))*ones(143);
gg1=gg/max(max(gg));
figure,imshow(gg1);
gg=cd-min(min(cd))*ones(143);
gg1=gg/max(max(gg));
figure,imshow(gg1);
[ca cb cc cd]=dwt2(double(rgb2gray(img)),'db2');
[ca cb cc cd]=dwt2(double(rgb2gray(img)),'haar');
[ca cb cc cd]=dwt2(double(rgb2gray(img)),'db2');
[ca cb cc cd]=dwt2(ca,'haar');
img=rgb2gray(imread('dataset3_35.png'));
[cA cB cC cD]=dwt2(double(img),'db16');
img=rgb2gray(imread('dataset2_39.png'));
[cA cB cC cD]=dwt2(double(img),'db16');
img=rgb2gray(imread('5x5small.png'));
img=rgb2gray(imread('5x5image.png'));
[cA cB cC cD]=dwt2(double(img),'db16');
gg=ca-min(min(ca))*ones(143);
gg1=gg/max(max(gg));
figure,imshow(gg1);
gg=ca-min(min(ca))*ones(18);
gg=cA-min(min(cA))*ones(18);
gg1=gg/max(max(gg));
figure,imshow(gg1);
img=imread('dataset2_39.png');
[cA cB cC cD]=dwt2(double(img),'db16');
[cA cB cC cD]=dwt2(double(rgb2gray(img)),'db16');
gg=cA-min(min(cA))*ones(18);
gg=cA-min(min(cA))*ones(143);
gg1=gg/max(max(gg));
figure,imshow(gg1);
gg=cB-min(min(cB))*ones(143);
gg1=gg/max(max(gg));
figure,imshow(gg1);
help dwt2
[cA cB cC cD]=dwt2(double(rgb2gray(img)),'db16','mode','sym');
cA=dwtmode('zpd');
%-- 7/13/09  4:44 PM --%
img=rgb2gray(imread('dataset2_39.png'));
for i=1:size(img,1)-8
for j=1:size(img,2)-8
I=double(img(i:i+8,j:j+8));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
end
img=rgb2gray(imread('dataset2_39.png'));
for i=1:size(img,1)-8
for j=1:size(img,2)-8
I=double(img(i:i+8,j:j+8));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
end
img=rgb2gray(imread('dataset2_39.png'));
for i=1:size(img,1)-8
for j=1:size(img,2)-8
I=double(img(i:i+8,j:j+8));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
end
clc
img=rgb2gray(imread('dataset2_39.png'));
for i=1:9-8
for j=1:9-8
I=double(img(i:i+8,j:j+8));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
end
dim
dtype
help writeanalyze
img=rgb2gray(imread('dataset2_39.png'));
for i=1:9-8
for j=1:9-8
I=double(img(i:i+8,j:j+8));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
end
img=rgb2gray(imread('dataset2_39.png'));
for i=1:9-8
for j=1:9-8
I=double(img(i:i+8,j:j+8));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
end
img=rgb2gray(imread('dataset2_39.png'));
for i=1:9-8
for j=1:9-8
I=double(img(i:i+8,j:j+8));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
end
[img1,dim,dtype]=readanalyze('tempoutput.img');
img1
img=rgb2gray(imread('dataset2_39.png'));
for i=1:9-8
for j=1:9-8
I=double(img(90:90+8,90:90+8));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
end
[img1,dim,dtype]=readanalyze('tempoutput.img');
img1
img=rgb2gray(imread('dataset2_39.png'));
for i=1:9-8
for j=1:9-8
I=double(img(90:90+8,90:90+8));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 4']
system(fdcommand);
end
img=rgb2gray(imread('dataset2_39.png'));
for i=1:9-8
for j=1:9-8
I=double(img(1:256,1:256));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 4']
system(fdcommand);
end
img1=readanalyze('tempoutput.img');
img1
figure,imshow(img1);
figure,imshow(img1/3);
figure,imshow(img1/4);
img=rgb2gray(imread('dataset2_39.png'));
featurevector=zeros(size(img,1),size(img,2),4);
for i=1:size(img,1)-8
for j=1:size(img,2)-8
counter=1;
I=double(img(i:i+8,j:j+8));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
++counter;
writeanalyze(cB,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
++counter;
writeanalyze(cC,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
++counter;
writeanalyze(cD,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
end
figure,imshow(featurevector(:,:,1)/4);
figure,imshow(featurevector(:,:,1));
featurevector(:,:,1)
img=rgb2gray(imread('dataset2_39.png'));
featurevector=zeros(size(img,1),size(img,2),4);
for i=1:size(img,1)-8
for j=1:size(img,2)-8
counter=1;
I=double(img(i:i+8,j:j+8));
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cB,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cC,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cD,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
end
img=rgb2gray(imread('dataset2_39.png'));
featurevector=zeros(size(img,1),size(img,2),4);
for i=1:size(img,1)-8
for j=1:size(img,2)-8
counter=1;
I=double(img(i:i+8,j:j+8));
if max(max(I))>0
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cB,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cC,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cD,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
end
i
j
clear
img=rgb2gray(imread('dataset2_39.png'));
featurevector=zeros(size(img,1),size(img,2),4);
for i=1:size(img,1)-8
for j=1:size(img,2)-8
counter=1;
I=double(img(i:i+8,j:j+8));
if max(max(I))>0
[cA cB cC cD]=dwt2(I,'haar');
[img,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cB,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cC,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cD,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
end
j
i
img=rgb2gray(imread('dataset2_39.png'));
featurevector=zeros(size(img,1),size(img,2),4);
for i=1:size(img,1)-8
for j=1:size(img,2)-8
counter=1;
I=double(img(i:i+8,j:j+8));
if max(max(I))>0
[cA cB cC cD]=dwt2(I,'haar');
[img2,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cB,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cC,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cD,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
end
img=rgb2gray(imread('dataset2_39.png'));
featurevector=zeros(size(img,1),size(img,2),4);
for i=1:size(img,1)-8
for j=1:size(img,2)-8
counter=1;
I=double(img(i:i+8,j:j+8));
if max(max(I))>6
[cA cB cC cD]=dwt2(I,'haar');
[img2,dim,dtype]=readanalyze('output.img');
writeanalyze(cA,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cB,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cC,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
++counter;
writeanalyze(cD,'temp.img',dim,dtype);
fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 2']
system(fdcommand);
img1=readanalyze('tempoutput.img');
featurevector(i,j,counter)=img1(3,3);
img1(3,3)
end
cA
cB
cC
cD
%-- 7/14/09  3:54 PM --%
Gabor
%-- 7/14/09  4:05 PM --%
Gabor
%-- 7/24/09 12:53 PM --%
[I1,dim,dtype]=readanalyze('dataset2_flirt.img');
I1=uint8(I1);
for i=1:110
imwrite(I1(:,:,i),strcat('dataset2_flirt',num2str(i),'.png'));
end
for i=1:110
system(strcat('./itkScalarToFractalImageFilterTest 2 dataset2_flirt',num2str(i),'.png dataset2_flirt_fd',num2str(i),'.img'));
end
%-- 7/30/09  5:04 PM --%
brainextractbetdemons('Demons/subject44_t1.img','Demons/subject41_t1.img','Demons/subject44_finalmasl.img','Demons/subject41_finalmask.img')
brainextractbetdemons('Demons/subject44_t1.img','Demons/subject41_t1.img','Demons/subject44_finalmask.img','Demons/subject41_finalmask.img')

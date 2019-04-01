clear all
I=imread('dataset2_28.png');
I=rgb2gray(I);
for i=1:size(I,1)-18
for j=1:size(I,2)-18
    clear stats;
I5=I(i:i+18,j:j+18);

GLCM2=graycomatrix(I5);
stats = GLCM_Features1(GLCM2,0);
I1(i,j)=sum([stats.homom]); 
I2(i,j)=sum([stats.entro]); 
I3(i,j)=sum([stats.energ]);
end
end
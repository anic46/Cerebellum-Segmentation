inputimage='dataset5_32.png';
radius=2
outputimage=strcat(inputimage(1:size(inputimage,2)-4),'_result',num2str(radius),'.img');
fdcommand=['itkScalarToFractalImageFilterTest 2 ',inputimage,' ',outputimage,' ',num2str(radius)] 
fdcommand
system(fdcommand);
I1=analyze75read(outputimage);
for i=1:256
for j=1:256
if isnan(I1(i,j))
I1(i,j)=0;
end
end
end

sizeofimage=8;
sizeofbox=5;
for i=1:256-sizeofimage+1
for j=1:256-sizeofimage+1
I2=I1(i:i+sizeofimage-1,j:j+sizeofimage-1);
counter=0;
for k=1:sizeofimage-sizeofbox+1
for m=1:sizeofimage-sizeofbox+1
counter=counter+1;
a(counter)=sum(sum(I2(k:k+sizeofbox-1,m:m+sizeofbox-1)));
end
end
% vara=var(a)
% meana=mean(a)
l(i,j)=var(a)/(mean(a))^2;%mean((a/mean(a)-1).^2);
end
end
for i=1:252
for j=1:252
if isnan(l(i,j))
l(i,j)=0;
end
end
end
figure,imshow((l-mean(mean(l))/0.01));
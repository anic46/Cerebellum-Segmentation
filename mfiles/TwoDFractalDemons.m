function TwoDFractalDemons(subjectimage,templateimage,templatemask,fractalradius)
subjectname1=subjectimage(1:size(subjectimage,2)-4);
index=strfind(subjectimage(1:size(subjectimage,2)-4),'/');
if index~=0
subjectname=subjectname1(index(size(index,2))+1:size(subjectname1,2));
subjectpathname=strcat(subjectname1(1:index(size(index,2))));
else
    subjectname=subjectname1;
end
    
templatename1=templateimage(1:size(templateimage,2)-4);
index=strfind(templateimage(1:size(templateimage,2)-4),'/');
if index~=0
templatename=templatename1(index(size(index,2))+1:size(templatename1,2));
templatepathname=strcat(templatename1(1:index(size(index,2))));
else
    templatename=templatename1;
end

[I1,dim,dtype]=readanalyze(subjectimage);
I1=uint8(I1);
for i=1:size(I1,3)
imwrite(I1(:,:,i),strcat(subjectname1,'_',num2str(i),'.png'));
end
for i=1:size(I1,3)
system(['./itkScalarToFractalImageFilterTest ',fractalradius,' ',strcat(subjectname1,'_',num2str(i),'.png'),' ',strcat(subjectname1,'_',num2str(i),'_fd.img')]);
end

for i=1:size(I1,3)
    I2(:,:,i)=readanalyze(strcat(subjectname1,'_',num2str(i),'_fd.img'));
    for j=1:size(I2(:,:,i),1)
        for k=1:size(I2(:,:,i),2)
            if isnan(I2(j,k,i))
                I2(j,k,i)=0;
            end
        end
    end
end
writeanalyze(I2,strcat(subjectname1,'_',num2str(i),'_fd.img'),dim,'float');

[I1,dim,dtype]=readanalyze(templateimage);
I1=uint8(I1);
for i=1:size(I1,3)
imwrite(I1(:,:,i),strcat(templatename1,'_',num2str(i),'.png'));
end
for i=1:size(I1,3)
system(['./itkScalarToFractalImageFilterTest ',fractalradius,' ',strcat(templatename1,'_',num2str(i),'.png'),' ',strcat(templatename1,'_',num2str(i),'_fd.img')]);
end

for i=1:size(I1,3)
    I2(:,:,i)=readanalyze(strcat(templatename1,'_',num2str(i),'_fd.img'));
    for j=1:size(I2(:,:,i),1)
        for k=1:size(I2(:,:,i),2)
            if isnan(I2(j,k,i))
                I2(j,k,i)=0;
            end
        end
    end
end
writeanalyze(I2,strcat(templatename1,'_',num2str(i),'_fd.img'),dim,'float');



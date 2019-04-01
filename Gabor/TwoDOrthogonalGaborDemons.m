function TwoDOrthogonalGaborDemons(subjectimage,templateimage,templatemask)

%computing the gabor features for the subject image & template image

%TwoDOrthogonalGabor(subjectimage,0.4,0.1,4,3,7);
%TwoDOrthogonalGabor(templateimage,0.4,0.1,4,3,7);

%creating vector image from the subject image gabor features
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

datasetfoldername=strcat(subjectimage(1:size(subjectimage,2)-4),'_multi');
datasetname=subjectimage(1:size(subjectimage,2)-4);
completefilesxy=['--inputVolume ' datasetfoldername '/featurerealxy1.img,' datasetfoldername '/featureimagxy1.img'];
for i=2:12
completefilesxy=strcat(completefilesxy,',',datasetfoldername,'/featurerealxy',num2str(i),'.img,',datasetfoldername,'/featureimagxy',num2str(i),'.img');
end
completefilesxz=['--inputVolume ' datasetfoldername '/featurerealxz1.img,' datasetfoldername '/featureimagxz1.img'];
for i=2:12
completefilesxz=strcat(completefilesxz,',',datasetfoldername,'/featurerealxz',num2str(i),'.img,',datasetfoldername,'/featureimagxz',num2str(i),'.img');
end
finalstring=['./CreateVectorImage --outputVolume ' strcat(datasetname,'vector.mha') ' ' completefilesxy ' ' completefilesxz ',' subjectimage]
system(finalstring);
subjectimagevectorname=strcat(datasetname,'vector.mha');

%creating vector image from the template image gabor features

datasetfoldername=strcat(templateimage(1:size(templateimage,2)-4),'_multi');
index=strfind(templateimage(1:size(templateimage,2)-4),'/');
datasetname=templateimage(1:size(templateimage,2)-4);
completefilesxy=['--inputVolume ' datasetfoldername '/featurerealxy1.img,' datasetfoldername '/featureimagxy1.img'];
for i=2:12
completefilesxy=strcat(completefilesxy,',',datasetfoldername,'/featurerealxy',num2str(i),'.img,',datasetfoldername,'/featureimagxy',num2str(i),'.img');
end

completefilesxz=['--inputVolume ' datasetfoldername '/featurerealxz1.img,' datasetfoldername '/featureimagxz1.img'];
for i=2:12
completefilesxz=strcat(completefilesxz,',',datasetfoldername,'/featurerealxz',num2str(i),'.img,',datasetfoldername,'/featureimagxz',num2str(i),'.img');
end
finalstring=['./CreateVectorImage --outputVolume ' strcat(datasetname,'vector.mha') ' ' completefilesxy ' ' completefilesxz ',' templateimage]
system(finalstring);
templateimagevectorname=strcat(datasetname,'vector.mha');

%applying the Weighted Multichannel Demons based registration(Yang Li's
%method)
disp('calculating the deformation field using weighted multichannel');
['./Weighted_Multichannel --fixedVolume ',subjectimagevectorname,' --movingVolume ',templateimagevectorname,' --outputDeformationField ',strcat(templatename,'to',subjectname,'deffield.mha'),' --outputVolume ',strcat(templatename,'to',subjectname,'.mha')]
system(['./Weighted_Multichannel --fixedVolume ',subjectimagevectorname,' --movingVolume ',templateimagevectorname,' --outputDeformationField ',strcat(templatename,'to',subjectname,'deffield.mha'),' --outputVolume ',strcat(templatename,'to',subjectname,'.mha')]);
disp('applying the deformation field');
['DemonsRegistration -f ',subjectimage,' -m ',templatemask,' -o ',strcat('aux_mask_',subjectname,'.img'),' -b ',strcat(templatename,'to',subjectname,'deffield.mha'),' -e -d -i 0']
system(['DemonsRegistration -f ',subjectimage,' -m ',templateimage,' -o ',strcat(templatename,'to',subjectname,'deffield.mha'),' -O ',strcat(templatename,'to',subjectname,'.img'),' -e -d -i 0']);

function vectorimagecreator(datasetname)
completefilesxy=['--inputVolume ' datasetname '/featurerealxy1.img,' datasetname '/featureimagxy1.img'];
for i=2:12
completefilesxy=strcat(completefilesxy,',',datasetname,'/featurerealxy',num2str(i),'.img,',datasetname,'/featureimagxy',num2str(i),'.img');
end

completefilesxz=['--inputVolume ' datasetname '/featurerealxz1.img,' datasetname '/featureimagxz1.img'];
for i=2:12
completefilesxz=strcat(completefilesxz,',',datasetname,'/featurerealxz',num2str(i),'.img,',datasetname,'/featureimagxz',num2str(i),'.img');
end

finalstring=['./CreateVectorImage --outputVolume ' datasetname '/dataset2flirtvector.mha ' completefilesxy ' ' completefilesxz]
system(finalstring);
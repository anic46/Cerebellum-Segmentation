function vectorimagecreator(datasetname)
completefiles=['--inputVolume ' datasetname '\featurerealxy1.img,' datasetname '\featureimagxy1.img'];
for i=2:12
completefiles=strcat(completefiles,',',datasetname,'\featurerealxy',num2str(i),'.img,',datasetname,'\featureimagxy',num2str(i),'.img');
end

finalstring=['createVectorImage --outputVolume ' datasetname '\dataset1vector.mha ' completefiles ',' datasetname '\dataset1.img']
system(finalstring);
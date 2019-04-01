completefiles='--inputVolume dataset2_multi\featurereal1.img,dataset2_multi\featureimag1.img';
for i=2:12
completefiles=strcat(completefiles,',dataset2_multi\featurereal',num2str(i),'.img,dataset2_multi\featureimag',num2str(i));
end
finalstring=['createVectorImage --outputVolume dataset2_multi\dataset2vector.mha ' completefiles];
system(finalstring);
function vectorimagecreator(datasetname)
completefiles=['--inputVolume ' datasetname '\B_level1_3dHori_F_real.0_0.img,' datasetname '\B_level1_3dHori_F_imag.0_0.img'];
for j=0:2
for k=0:3
    if j==0 && k==0
    else
    completefiles=strcat(completefiles,',',datasetname,'\B_level1_3dHori_F_real.',num2str(j),'_',num2str(k),'.img,',datasetname,'\B_level1_3dHori_F_imag.',num2str(j),'_',num2str(k),'.img');
    end
end
end

finalstring=['createVectorImage --outputVolume ' datasetname '\dataset2vector.mha ' completefiles]

system(finalstring);
function brainextractbetdemons(subjectimage,templateimage,trueskullmask,templateskullmask,outputimage)
subjectname1=subjectimage(1:size(subjectimage,2)-4);
index=strfind(subjectimage(1:size(subjectimage,2)-4),'/');
subjectname=subjectname1(index(size(index,2))+1:size(subjectname1,2));
pathname=strcat(subjectname1(1:index(size(index,2))));
pythoncommand=['python 3DDemonsSkullStripper.py -t ',templateimage,' -s ',subjectimage,' -p aux_mask_',subjectname,'.img',' -m ',templateskullmask,' -n 0']
system(pythoncommand);

%reading the skull mask outputted by the demons & finding the brain mask from it
[I1,dim,dtype]=readanalyze(strcat(pathname,'aux_mask_',subjectname,'_thresholded.img'));
I2=I1>0;
for i=1:size(I1,3)
    I3(:,:,i)=imfill(I2(:,:,i),'holes');
end
I3(:,:,1:5)=zeros(size(I3(:,:,1:5)));
I5=logical(I3-I2);
I5(:,:,1:5)=zeros(size(I1,1),size(I1,2),5);
I5=bwareaopen(I5,200);
%writing the demons mask for brain
writeanalyze(I5,strcat(pathname,'braindemons_',subjectname,'_mask.img'),dim,dtype);
[I6,dim,dtype]=readanalyze(subjectimage);
I7=I6.*double(I5);
%writing out the brain using the demons mask
writeanalyze(uint8(I6.*double(I5)),strcat(pathname,'braindemons_',subjectname,'.img'),dim,dtype);

%calculating the brain mask using bet

system(['bet ',subjectimage,' ',strcat(pathname,'brainbet_',subjectname),' -o -m']);
%reading the bet mask
I9=readanalyze(strcat(pathname,'brainbet_',subjectname,'_mask.img'));
%and & or of the bet & demons masks
I10=I7&I9;
I11=I7|I9;
%finding the regions which are different in the 2 masks(i.e. are in one of the masks but not the other).the regions are stored in I13
I12=I11-I10;
I13=I12.*I6;
%clearing memory
clear I12 I6 I7 I9
%applying fast on the brain found out from demons
system(['fast -v -o ',strcat(pathname,'brainlabelled_',subjectname),' ',strcat('braindemons_',subjectname,'.img')]);
%reading the labelled brain image given by demons 
I1=readanalyze(strcat(pathname,'brainlabelled_',subjectname,'_seg.img'));
%reading the original subject image & segmenting the grey matter from that
I2=readanalyze(subjectimage);
I3=I2.*double(ismember(I1,2));
%thresholding the I13 image by finding the mean & standard deviation of the grey matter & using mean-2*standard deviation as the threshold 
count=I3(I3>0);
mean(count)-2*std(count)
I13=I13>mean(count)-2*std(count);
%finding the bet+demons mask & writing it
Inet=I10|I13;
Inet(:,:,1:5)=zeros(size(Inet,1),size(Inet,2),5);
writeanalyze(uint8(Inet),strcat(pathname,'brainbetdemons_',subjectname,'_mask.img'),dim,dtype);
clear I13 I3 I1
%writing the brain using the bet+demons mask
writeanalyze(uint8(Inet.*I2),strcat(pathname,'brainbetdemons_',subjectname,'.img'),dim,'uint8');
writeanalyze(uint8(Inet.*I2),outputimage,dim,'uint8');

%computing the brain using the true skull mask

[I1,dim,dtype]=readanalyze(trueskullmask);
I2=I1>0;
for i=1:size(I1,3)
I3(:,:,i)=imfill(I2(:,:,i),'holes');
end
I5=logical(I3-I2);
I5(:,:,1:5)=zeros(size(I1,1),size(I1,2),5);
I5=bwareaopen(I5,200);
writeanalyze(I5,strcat(pathname,'braintrue_',subjectname,'_mask.img'),dim,dtype);
[I6,dim,dtype]=readanalyze(strcat(subjectname,'.img'));
I7=I6.*double(I5);
%writing the brain using the true mask
writeanalyze(uint8(I6.*double(I5)),strcat(pathname,'braintrue_',subjectname,'.img'),dim,dtype);

%finding the jaccard ratios

truemask=readanalyze(strcat(pathname,'braintrue_',subjectname,'_mask.img'));
maskbeforebet=readanalyze(strcat(pathname,'braindemons_',subjectname,'_mask.img'));
maskafterbet=readanalyze(strcat(pathname,'brainbetdemons_',subjectname,'_mask.img'));
img9=truemask&maskbeforebet;
img10=truemask|maskbeforebet;
jaccardratiobeforebet=sum(sum(sum(img9(:,:,:))))/sum(sum(sum(img10(:,:,:))))

img9=truemask&maskafterbet;
img10=truemask|maskafterbet;
jaccardratioafterbet=sum(sum(sum(img9(:,:,:))))/sum(sum(sum(img10(:,:,:))))

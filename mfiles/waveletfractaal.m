img=rgb2gray(imread('dataset2_39.png'));
featurevector=zeros(size(img,1),size(img,2),4);

for i=1:size(img,1)-16
    for j=1:size(img,2)-16
        counter=1;
        I=double(img(i:i+16,j:j+16));
        if max(max(I))>6
            
        [cA cB cC cD]=dwt2(I,'haar');
        [img2,dim,dtype]=readanalyze('output.img');
        writeanalyze(cA,'temp.img',dim,dtype);
        fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 4']
        system(fdcommand);
        img1=readanalyze('tempoutput.img');
        featurevector(i,j,counter)=img1(3,3);
        img1(3,3)
        ++counter;
        writeanalyze(cB,'temp.img',dim,dtype);
        fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 4']
        system(fdcommand);
        img1=readanalyze('tempoutput.img');
        featurevector(i,j,counter)=img1(3,3);
        img1(3,3)
         ++counter;
        writeanalyze(cC,'temp.img',dim,dtype);
        fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 4']
        system(fdcommand);
        img1=readanalyze('tempoutput.img');
        featurevector(i,j,counter)=img1(3,3);
        img1(3,3)
         ++counter;
        writeanalyze(cD,'temp.img',dim,dtype);
        fdcommand=['./itkScalarToFractalImageFilterTest 2 temp.img tempoutput.img 4']
        system(fdcommand);
        img1=readanalyze('tempoutput.img');
        featurevector(i,j,counter)=img1(3,3);
        img1(3,3)

        end
    end
end


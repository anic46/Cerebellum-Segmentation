%clc;
tic
clear all;
I=(uint8(readanalyze('dataset2.hdr')));

img=(I(:,:,1:110));
for i=1:110
     img(:,:,i)=imadjust(imrotate((img(:,:,i)),90));
end
clear I
%img=histeq(rgb2gray(uint8(imread('dataset3_35.png'))));
% F=img;
% F=im2double(F);
% r=F(:,:,1);
% g=F(:,:,2);
% b=F(:,:,3);
% th=acos((0.5*((r-g)+(r-b)))./((sqrt((r-g).^2+(r-b).*(g-b)))+eps));
% H=th;
% H(b>g)=2*pi-H(b>g);
% H=H/(2*pi);
% S=1-3.*(min(min(r,g),b))./(r+g+b+eps);
% I=(r+g+b)/3;
% hsi=cat(3,H,S,I);

counter=0;
counter1=0;
%figure,imshow(img(:,:,3));
%img=imfilter(img,fspecial('gaussian'));
num_clusters=6;
%img2=edge(img,'canny',0.05);
%img=(img2);
%figure,imshow(img);

%g=zeros(size(img,1),size(img,2),size(img,3));
%temp1=g;
%gabout1=zeros(size(img,1),size(img,2),size(img,3),12);

img=im2double(img);
I=img;
windowsize=7;
nooffrequencies=1;
counter=0;
gsize=6;
noofanglesxy=[0 1 2 3];
noofanglesz=4;
b=0.5;

for countf=0.15:0.1:0.45
f=countf;
%Sx according to bandwidth
Sx=(1/f)*(1/pi)*(sqrt(log(2)/2)*(2^b+1)/(2^b-1))
Sy=Sx;
Sz=Sx/2;

for countphi=1:size(noofanglesxy,2)
    for countsi=0:noofanglesz-1
    counter=counter+1;
    counter
    phi=pi/4*(noofanglesxy(countphi));
    si=pi/noofanglesz*(countsi);
    if isa(I,'double')~=1 
        I = double(I);
    end
    for x = -gsize:gsize
       for y = -gsize:gsize
          for z=-3:3
                xPrime = x * cos(si) + y * sin(si);
                yPrime = y * cos(si)*cos(phi) - x * sin(si)*cos(phi)+z*sin(phi);
                zPrime = x*sin(phi)*sin(si) - y*sin(phi)*cos(si)+z*cos(phi);
                G(gsize+x+1,gsize+y+1,3+z+1) = exp(-0.5*((xPrime/Sx)^2+(yPrime/Sy)^2+(zPrime/Sz)^2))*exp(2i*pi*(x*f*cos(phi)*cos(si)+y*f*cos(phi)*sin(si)+z*f*sin(phi)));
          end
        end
    end
    G=G-mean(mean(mean(G)))*ones(size(G));
    disp('calculating Regabout');
     Regabout= convn(I,double(real(G)),'same');
     Imgabout= convn(I,double(imag(G)),'same');
     gabout(:,:,:,counter)= sqrt(Regabout.^2+Imgabout.^2);
end
end
end
%gabout1=abs(gabout);
save gabout_dataset2_full.mat gabout1
% for i=1:11
% gg=abs(gabout(:,:,i,1)); figure,imshow(imadjust(gg/max(max(gg))/2));
% end
% figure,imshow(adapthisteq(img(:,:,8)))
% for v=1:noofanglesxy*nooffrequencies*noofanglesz
% gnet(:,:,:,v)=mean(mean(mean(abs(gabout(:,:,:,v)))))*ones(size(gabout(:,:,:,v)));
% end
% gabout1=abs(gabout)-gnet;
% gabout2=tanh(0.25*gabout1);
% gabout2=abs(gabout2);
% matrix=ones(windowsize,windowsize)/(windowsize^2);

% for v=1:noofangles*nooffrequencies
% gabout2(:,:,v)=(conv2(abs(gabout1(:,:,v)),matrix,'same'));
% figure,imshow(imadjust(gabout2(:,:,v)));
% finalvalues(v)=gabout2(9,9,v);
% %figure,line([100 100+50*cos(pi*(v-1)/noofangles-pi/2)],[100 100-50*sin(pi*(v-1)/noofangles-pi/2)]);
% end
% x=1:noofangles*nooffrequencies;
% figure,plot(x,finalvalues);
% 
% maxsize=noofangles*nooffrequencies;
% SSTOTtemp=sum(sum((gnet).^2));
% SSTOT=SSTOTtemp(:,:,1);
% R=0;
% gsdash=gabout;
% usefulindex=0;
% count=0;
% while(R==1)
%     count=count+1;
%     SSEtemp=sum(sum(((gsdash-gnet).^2),2),1);
%     [c,index]=min(SSEtemp);
%     SSE=sum(SSEtemp(index));
%     R=1-SSE/SSTOT
%     index
%     gsdash(:,:,index)=zeros(size(gsdash(:,:,index)));
%         for v=1:maxsize
%             gsdash(:,:,v)=gsdash(:,:,v)+gabout(:,:,index);
%         end
%     usefulindex(count)=index;    
% end
% % while(1)
% %     for v=1:maxloop
% %         s=gabout(:,:,v)+s;
% %         SSE=sum(sum(gnet-s).^2);
% %         SSTOT=sum(sum(gnet.^2));
% %         R=1-(SSE/SSTOT);
% %         if R>temp
% %             temp=R;
% %             id=v;
% %         else
% %             s=s-gabout(:,:,v);
% %         end
% %         
% %     end
% %     
% % end
% 
% 
% for v=1:size(usefulindex,2)
% gabout1(:,:,v)=(gabout(:,:,usefulindex(v)));
% end
% 
% % for v=1:size(usefulindex,2)
% %     gabout1(:,:,v)=gabout1(:,:,v)-mean(gabout1,3);
% % end
% 
% gabout1=tanh(0.25*gabout1);
% gabout1=abs(gabout1);
% matrix=ones(windowsize,windowsize)/(windowsize^2);
% 
% 
% %matrix=fspecial('gaussian',[gsize gsize],2*Sx);
% for v=1:size(usefulindex,2)
% gabout2(:,:,v)=(conv2(abs(gabout1(:,:,v)),matrix,'same'));
% imwrite(imadjust(gabout2(:,:,v)),strcat('Angle',num2str(180-(v-1)*7.5),'.png'));
% %gabout2(:,:,v)=gabout2(:,:,v)-mean(mean(gabout2(:,:,v)));
% %figure,imshow(imadjust(gabout2(:,:,v)));
% %sum(sum(gabout2(:,:,v)))
% %figure,imshow((imadjust(gabout2(:,:,v)))+im2double(rgb2gray(imread('dataset2_39.png')))/2);
% %hold on;
% figure,line([100 100+50*cos(pi*(v-1)/noofangles-pi/2)],[100 100-50*sin(pi*(v-1)/noofangles-pi/2)]);
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %gnet=mean(gabout(:,:,5:23),3);
% %figure,imshow(imadjust(gnet,[0.2 0.8],[0 1]));
% %figure,imshow(imadjust(gabout2(:,:,5)/3+gabout2(:,:,6)/3+gabout2(:,:,4)/3));
% %gaboutfinal(:,:,1)=imadjust(gabout2(:,:,5)/3+gabout2(:,:,6)/3+gabout2(:,:,4)/3);
% %gaboutfinal(:,:,2)=imadjust(gabout2(:,:,15));
% %gaboutfinal(:,:,3)=imadjust(gabout2(:,:,4));
% %gaboutfinal(:,:,4)=imadjust(gabout2(:,:,5));
% % gaboutfinal(:,:,5)=imadjust(gabout2(:,:,4));
% % gaboutfinal(:,:,6)=imadjust(gabout2(:,:,7));
% 
% % gaboutfinal(:,:,3)=gabout2(:,:,16);
% % gaboutfinal(:,:,4)=gabout2(:,:,11);
% for v=1:size(usefulindex,2)
% gaboutfinal(:,:,v)=(gabout2(:,:,v));
% figure,imshow(imadjust(gaboutfinal(:,:,v)));
% end
% for v=1:size(usefulindex,2)
% gaboutfinal1(:,:,v)=im2uint8(gaboutfinal(:,:,v));
% end
% 
% gaboutfinal1(:,:,v+1)=repmat([1:256],256,1);
% gaboutfinal1(:,:,v+2)=repmat([1:256],256,1)';
% for i=0:255
% X((i)*256+1:(i+1)*256,:)=gaboutfinal1(i+1,:,:);
% end
% idx=kmeans(double(X),7);
% for i=0:255
% g(i+1,:,:)=idx((i)*256+1:(i+1)*256,:);
% end
% figure,imagesc(g);
%  %gaboutfinal(:,:,v+1)=repmat([1:256],256,1);
%  %gaboutfinal(:,:,v+2)=repmat([1:256],256,1)';
% % % counter=0;
% % % for k=1:4
% % %     for l=1:4
% % %         counter=counter+1
% % %         counter1=0;
% % %         128*(k-1)+1+32*(j-1)
% % %         for i=1:4
% % %             for j=1:4
% % %                 counter1=counter1+1
% % %                 gabout1(counter,counter1,:)=sum(sum(gabout(128*(k-1)+1+32*(j-1):128*(k-1)+32*(j-1)+32,128*(l-1)+1+32*(i-1):128*(l-1)+32*(i-1)+32,:),2),1)/(32*32);
% % %             end
% % %         end
% % %     end
% % % end
% % gabout1
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % for v=1:16
% % gabout1(:,:,v)=(conv2(abs(gabout(:,:,v)),matrix,'same'))/(17*17);
% % end
% % % gabout1(:,:,17)=hsi(:,:,1)
% % % gabout1(:,:,18)=hsi(:,:,2);
% % % gabout1(:,:,19)=hsi(:,:,3);
% % 
% % % for i=1:size(gabout,1)
% % %     for j=1:size(gabout,2)
% % %         for x=i-16:i+16
% % %             for y=j-16:j+16
% % %                 if x>0 && y>0 && x<=size(gabout,1) && y<=size(gabout,2)
% % %                 gabout1(i,j,:)=abs(gabout(i,j,:)/(17*17))+gabout1(x,y,:);
% % %                 end
% % %             end
% % %         end
% % %     end
% % % end
% % % gabout1;
% % %figure,imshow(img);
% % 
% % % % starting of k means clustering
% % % ...........................................
% % cluster=zeros(num_clusters,size(gaboutfinal,3));
% % 
% %  %cluster(1,:)=gaboutfinal(77,62,:);
% %  %cluster(2,:)=gaboutfinal(107,62,:);
% %  %cluster(3,:)=gaboutfinal(43,78,:);
% % for k=1:num_clusters
% %     x=uint16(rand(1)*(size(gaboutfinal,1)))
% %     y=uint16(rand(1)*(size(gaboutfinal,2)))
% %     if(y==0)
% %         y=1;
% %     end
% %     if(x==0)
% %         x=1;
% %     end
% %     cluster(k,:)=gaboutfinal(x,y,:);
% % end
% % %cluster(4,:)=gaboutfinal(120,120,:);
% % temp=0;
% % cluster
% % while(1)
% % cluster1(1:num_clusters,1:size(gaboutfinal,3))=(0);
% % count(1:num_clusters)=(0);
% % for i=1:size(gabout2,1)
% %         for j=1:size(gabout2,2)
% %             ct=0;
% %             temp=double(32323232);
% %             for l=1:num_clusters
% %                 distance=0;
% %                 gabouttemp=zeros(1,size(gaboutfinal,3));
% %                 gabouttemp=gaboutfinal(i,j,:);
% %                 distance=sqrt(sum((gabouttemp(1,:)-cluster(l,:)).^2));
% %                 
% % %                 for z=1:23
% % %                  distance=((gaboutfinal(i,j,z)-cluster(l,z))^2) + distance;
% % %                 end
% %                 
% %                 if ct>0
% %                      if distance<temp
% %                          g(i,j)=l;
% %                          temp=distance;
% %                      end
% %                 else
% %                      temp=distance;
% %                      g(i,j)=1;
% %                      ct=ct+1;
% %                 end
% %             end
% %             cluster2(g(i,j),1:size(gaboutfinal,3))=gaboutfinal(i,j,1:size(gaboutfinal,3));
% %             cluster1(g(i,j),1:size(gaboutfinal,3))=cluster1(g(i,j),1:size(gaboutfinal,3))+ cluster2(g(i,j),1:size(gaboutfinal,3));
% %             count(g(i,j))=count(g(i,j))+1;
% %         end
% % end
% % for p=1:num_clusters
% %     count(p)
% % cluster1(p,:)=cluster1(p,:)/count(p);
% % end
% % 
% % cluster=cluster1;
% % cluster
% % if (g==temp1)
% %     break;
% % else
% %     temp1=g;
% % end
% % end
% % g
% % counter=0;
% % figure,imagesc(g);
% % % for k=1:4
% % %     for l=1:4
% % %         counter=counter+1
% % %         counter1=0;
% % %         128*(k-1)+1+32*(j-1)
% % %         for i=1:4
% % %             for j=1:4
% % %                 counter1=counter1+1
% % %                 img1(128*(k-1)+1+32*(j-1):128*(k-1)+32*(j-1)+32,128*(l-1)+1+32*(i-1):128*(l-1)+32*(i-1)+32)=g(counter,counter1)*255/16;
% % %             end
% % %         end
% % %     end
% % % end
% % % figure,imshow(uint8(img1));
% % % BW=edge(uint8(img1),'canny');
% % % figure,imshow(BW);
% % %     
% % % %..........................................................................................................................................
% % % 
% % % % %fuzzy c means clustering
% % % % 
% % m1=1.5;
% % % u contains the degree to which i,j th element belongs to each of the clusters
% % u = rand(size (gabout1,1), size (gabout1,2),num_clusters);
% % flag(1:size(gabout1,1),1:size(gabout1,2))=0;
% % col_sum = sum(u,3);
% % for i=1:size(gabout1,1)
% %     for j=1:size(gabout1,2)
% %         u(i,j,:)=u(i,j,:)/col_sum(i,j);
% %     end
% % end
% % threshold=0.2;
% % %computation of centres of clusters
% % while(1)
% %     ua=u;
% % c(1:num_clusters,1:16)=0;
% % c1(1:num_clusters,1:16)=0;
% % for i=1:num_clusters
% %     numerator(1:16)=0;
% %     dummynum(1:16)=0;
% %     denominator=0;
% %     for j=1:size(gabout1,1)
% %         for k=1:size(gabout1,2)
% %             dummynum(:)=(u(j,k,i)^m1)*gabout1(j,k,:);
% %             numerator=dummynum+numerator;
% %             denominator=(u(j,k,i)^m1)+denominator;
% %         end
% %     end
% %     c(i,:)=numerator/denominator;
% % end
% % c;
% %        
% %         % calculation of u
% %         for i=1:size(gabout1,1)
% %             for j=1:size(gabout1,2)
% %                 for l=1:num_clusters
% %                 invu=0;
% % %                 for z=1:16
% % %                      num=((gabout1(i,j,z)-c(l,z))^2) + num;
% % %                 end
% % %                 num=sqrt(num);
% %                 c1(l,:)=gabout1(i,j,:);
% %                 num=norm(c1(l,:)-c(l,:));
% %                 for m=1:num_clusters
% % %                     for n=1:16
% % %                          denm=((gabout1(i,j,n)-c(m,n))^2) + denm;
% % %                     end
% % %                     denm=sqrt(denm);
% %                     c1(m,:)=gabout1(i,j,:);
% %                     denm=norm(c1(m,:)-c(m,:));
% %                     if denm>0
% %                     invu=((num/denm)^(2/(m1-1)))+invu;
% %                     end
% %                 end
% %                 u(i,j,l)=1/invu;
% %                 end
% %             end
% %         end
% %         
% %         delta=u-ua;
% %         norm1(1:num_clusters)=0;
% %         for i=1:num_clusters
% %         norm1(i)=norm(delta(:,:,i));
% %         end
% %         norm2=norm(norm1)
% %         if norm2<threshold
% %             break;
% %         end
% % end
% % 
% % for i=1:size(gabout1,1)
% %     for j=1:size(gabout1,2)
% %         temp=0;
% %         for k=1:num_clusters
% %             if u(i,j,k)>temp
% %                 temp=u(i,j,k);
% %                 flag(i,j)=k;
% %             end
% %         end
% %     end
% % end
% % flag
% % counter=0;
% % for k=1:4
% %     for l=1:4
% %         counter=counter+1
% %         counter1=0;
% %         128*(k-1)+1+32*(j-1)
% %         for i=1:4
% %             for j=1:4
% %                 counter1=counter1+1
% %                 img1(128*(k-1)+1+32*(j-1):128*(k-1)+32*(j-1)+32,128*(l-1)+1+32*(i-1):128*(l-1)+32*(i-1)+32)=flag(counter,counter1)*255/16;
% %             end
% %         end
% %     end
% % end
% % for i=1:size(img,1)
% %    for j=1:size(img,2)
% %      img1(i,j)=flag(i,j)/num_clusters;
% %     end
% %  end
% % % %             
% % % % 
% % % % 
% % % %             
% % % %         
% % % %         
% % % % 
% % % % 
% % % %             
% % % 
% % % 
% % % 
toc
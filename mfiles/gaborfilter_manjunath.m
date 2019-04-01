%clc;
clear all;
[I1,dim,dtype]=readanalyze('dataset2.img');

counter1=0;
%figure,imshow(img);


windowsize=7;
counter=0;
noofscales=3;
fmax=1.2;
fmin=0.3;
noofangles=4;
a=double(0);
for scales=0:2
a=double((fmax/fmin)^(1/double(noofscales-1)))
gsize=15;
u0=fmax/(a^(noofscales-scales));
Su=((a-1)*u0)/((a+1)*sqrt(2*log(2)));
Sx=1/(2*pi*Su)
Sv=tan(pi/(2*noofangles))*(u0-2*log(2)*(Su^2/u0))/(sqrt(2*log(2)-(2*log(2))^2*Su^2/u0^2));
Sy=1/(2*pi*Sv)
for countt=1:noofangles
    counter=counter+1;
    for i=1:110
    img=imrotate(uint8(I1(:,:,i)),90);
    img=im2double(img);
    I=img;
    theta=pi/noofangles*(countt-1);
    theta*180/pi ;
    if isa(I,'double')~=1 
        I = double(I);
    end
    clear G
    for x = -gsize:gsize
            for y = -gsize:gsize               
                xPrime = (x * cos(theta) + y * sin(theta));
                yPrime = (y * cos(theta) - x * sin(theta));
                G(gsize+x+1,gsize+y+1) = a^(noofscales-scales)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2))*cos(2*pi*u0*xPrime))/(2*pi*Sx*Sy);
                G1(gsize+x+1,gsize+y+1) = a^(noofscales-scales)*(exp(-.5*((xPrime/Sx)^2+(yPrime/Sy)^2))*sin(2*pi*u0*xPrime))/(2*pi*Sx*Sy);
             end
    end
    G=G-mean(mean(G))*ones(size(G));
     x=-gsize:gsize;
     y=-gsize:gsize;
     figure,mesh(x,y,G1);
    %figure,imshow(G1);
    %Gnet=fft2(G+i*G1);
%     x=-gsize:gsize;
%     y=-gsize:gsize;
%     figure,surf(x,y,G(:,:,1));
%     for i=1+gsize:size(img,1)-gsize
%         for j=1+gsize:size(img,2)-gsize
%             I=img(i-gsize:i+gsize,j-gsize:j+gsize);
%             I=double(I);     
%            
%      Regabout(i,j)=mean(mean(abs(conv2(I,G))));% conv2(I,G,'same');
%      Imgabout(i,j)=mean(mean(abs(conv2(I,G1))));% conv2(I,G1,'same');
%         end
%     end
Regabout=conv2(I,double(G),'same');
Imgabout=conv2(I,double(G1),'same');
    %Regabout(:,:,offset)=Regabout(:,:,offset)-mean(mean(Regabout(:,:,offset)))*ones(size(Regabout(:,:,offset)));
%      if (var(var(Regabout(:,:,offset)))<10^-4)
%          Regabout(:,:,offset)=zeros(size(Regabout(:,:,offset)));
%      end
    gaboutreal(:,:,i) = abs(Regabout);
    gaboutimag(:,:,i) = abs(Imgabout);
    end
    max(max(max(gaboutreal)))
%     writeanalyze(gaboutreal/20*255,strcat('dataset2_multi/featurereal',num2str(counter),'.img'),dim,dtype);
%     writeanalyze(gaboutimag/20*255,strcat('dataset2_multi/featureimag',num2str(counter),'.img'),dim,dtype);
    %gg=gaboutreal(:,:,counter);
    %gg=gg-mean(mean(gg));
 %figure,imshow(imadjust(gg/max(max(gg))))
end
end





% filt=fspecial('average',3); 
% for v=1:noofscales*noofangles
% %gg=(gaboutreal(:,:,v))-min(min(gaboutreal(:,:,v)))*ones(size(gaboutreal(:,:,v)));
% gg=(gaboutimag(:,:,v))+12.8;
%     %gg=imfilter(gaboutreal(:,:,v),filt);%abs(gaboutimag(:,:,v));
% %gg=gg-min(min(gg));
% %figure,imshow(gaboutreal(:,:,v));
% %figure,imshow(gaboutreal(:,:,v));
% % min(min(gaboutreal(:,:,v)))
% % max(max(gaboutreal(:,:,v)))
% %figure,imshow(imadjust(gg/max(max(gg))));
% figure,imshow(adapthisteq(gg/max(max(gg))));
% end

% gabout1=tanh(0.25*gabout);
% gabout2=abs(gabout1);
% matrix=ones(windowsize,windowsize)/(windowsize^2);

% for v=1:noofangles*nooffrequencies
% %gabout2(:,:,v)=(conv2(abs(gabout1(:,:,v)),matrix,'same'));
% figure,imshow(imadjust(gabout2(:,:,v)));
% %finalvalues(v)=gabout2(9,9,v);
% %figure,line([100 100+50*cos(pi*(v-1)/noofangles-pi/2)],[100 100-50*sin(pi*(v-1)/noofangles-pi/2)]);
% end
%x=1:noofangles*nooffrequencies;
%figure,plot(x,finalvalues);

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

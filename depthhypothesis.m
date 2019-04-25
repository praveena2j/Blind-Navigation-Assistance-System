clc;
clear all;
close all;
%%%%%%Reading an image %%%%%%%%%%%
I=rgb2gray(imread('test.jpg'));
I=imresize(I,[256 256]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Ensuring only two pixel values 0 and 255 in the image
for i=1:256
    for j=1:256
        if(I(i,j)==0)
            I1(i,j)=0;
        else
            I1(i,j)=255;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
imshow(I1);
[Ilabel num]=bwlabel(I1);%%%%counting number of objects
disp(num)
%%%%%creating bounding boxes for all the objects
Iprops=regionprops(Ilabel);
Ibox=[Iprops.BoundingBox];
Ibox=reshape(Ibox,[4 num]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m=1;%%%%%%%%discarding insignificant objects based on threshold and storing the corner pixels in Iobj
for l=1:num
    if (Ibox(3,l)>50)
        Iobj(:,m)=Ibox(:,l);
        m=m+1;
    end
end
 %%%%%%%%%%%%%%%%%%%%%%
hold on;
imshow(I1);
for cnt=1:m-1
    rectangle('position',Iobj(:,cnt),'edgecolor','r');
end
hold off;
%%%%%%%%%%
%%%%%%%%%%%forming the basic hypothesis
a=[];
n=0;
for i=1:256
    for j=1:256
        a(i,j)=n;
    end
    n=n+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r=uint8(a(:,7)); 
obj1=zeros(256,256);%%%creating an image with zero pixels
obj2=zeros(256,256);
%obj3=zeros(256,256);
for cnt=1:m-1
    if (cnt==1)
        %%%%%assigning the first object in Iobj to Iobj1 in the corresponding position 
        obj1(Iobj(2,cnt):Iobj(2,cnt)+Iobj(4,cnt),Iobj(1,cnt):Iobj(1,cnt)+Iobj(3,cnt))=I1(floor(Iobj(2,cnt)):floor(Iobj(2,cnt)+Iobj(4,cnt)),floor(Iobj(1,cnt)):floor(Iobj(1,cnt)+Iobj(3,cnt)));  
		l=1;
		%%%%%%%%%%%assigning the depth values for the first object
		for j=1:256
			for i=1:256       
				if (obj1(j,i)~=0)
					ref1(l)=a(j,i)+a(j-1,i);
					l=l+1;
				end
			end       
		end
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		%%%%%%%ASSIGNING depth values for no object space
		ref2=ref1(1);
		for j=1:256
			for i=1:256       
				if (obj1(j,i)==0)
					obj1(j,i)=a(j,i);
				else
					obj1(j,i)=ref2;
				end        
			end       
			ref2=ref2+1;
		end
		%%%%%%%%%%%%%%%%%%%%%%%%%%%
		figure;
		imshow(uint8(obj1));
	else(cnt==2)
        obj2(Iobj(2,cnt):Iobj(2,cnt)+Iobj(4,cnt),Iobj(1,cnt):Iobj(1,cnt)+Iobj(3,cnt))=I1(floor(Iobj(2,cnt)):floor(Iobj(2,cnt)+Iobj(4,cnt)),floor(Iobj(1,cnt)):floor(Iobj(1,cnt)+Iobj(3,cnt))); 
		l=1;
		for j=1:256
			for i=1:256       
				if (obj2(j,i)~=0)
					ref1(l)=a(j,i)+a(j-1,i);
					l=l+1;
				end
			end       
		end
		ref2=ref1(1);
		for j=1:256
			for i=1:256       
				if (obj2(j,i)==0)
					obj2(j,i)=a(j,i);
				else
					obj2(j,i)=ref2;
				end        
			end       
			ref2=ref2+1;
		end
		figure;
		imshow(uint8(obj2));
	
	end
end
%%%%%%%%%Merging the depth values of two objects
a(Iobj(2,1):Iobj(2,1)+Iobj(4,1),Iobj(1,1):Iobj(1,1)+Iobj(3,1))=obj1(Iobj(2,1):Iobj(2,1)+Iobj(4,1),Iobj(1,1):Iobj(1,1)+Iobj(3,1));  
a(Iobj(2,2):Iobj(2,2)+Iobj(4,2),Iobj(1,2):Iobj(1,2)+Iobj(3,2))=obj2(Iobj(2,2):Iobj(2,2)+Iobj(4,2),Iobj(1,2):Iobj(1,2)+Iobj(3,2)); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%eliminating the zero pixel s in the final row
for i=1:257
     a(i,257)=i;
end
a(257,:)=255;
%a(Iobj(2,3):Iobj(2,3)+Iobj(4,3),Iobj(1,3):Iobj(1,3)+Iobj(3,3))=obj3(Iobj(2,3):Iobj(2,3)+Iobj(4,3),Iobj(1,3):Iobj(1,3)+Iobj(3,3)); 
figure;
imshow(uint8(a));
imwrite(uint8(a),'ref.jpg','JPG','Quality',100);
%%%%%%%%%%%%%%%dividing into bands for detecting obstacles
for b=1:256
    if(b==1)
        grph=a(:,b:b+8);
            for i=1:257
                band1(i)=mean(grph(i,:));
            end    
    elseif(b==30)
        grph=a(:,b:b+8);
            for i=1:257
                band2(i)=mean(grph(i,:));
            end
    elseif(b==55)
        grph=a(:,b:b+8);
            for i=1:257
                band3(i)=mean(grph(i,:));
            end
    elseif(b==140)
        grph=a(:,b:b+8);
            for i=1:257
                band4(i)=mean(grph(i,:));
            end
    elseif(b==210)
        grph=a(:,b:b+8);
            for i=1:257
                band5(i)=mean(grph(i,:));
            end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
subplot(2,3,1);
plot(r);
% xlabel('x');
% ylabel('y');
title('(a)');
subplot(2,3,2);
plot(band1);
title('(b)');
% xlabel('x');
% ylabel('y');
subplot(2,3,3);
plot(band2);
title('(c)');
% xlabel('x');
% ylabel('y');
subplot(2,3,4);
plot(band3);
title('(d)');
% xlabel('x');
% ylabel('y');
subplot(2,3,5);
plot(band4);
title('(e)');
% xlabel('x');
% ylabel('y');
subplot(2,3,6);
plot(band5);
title('(f)');
% xlabel('x');
% ylabel('y');
    
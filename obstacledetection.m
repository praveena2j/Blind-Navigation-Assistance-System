clc;
clear all;
close all;
I=imread('test6.jpg');
I1=rgb2gray(imresize(I,[750 1125]));

I2=edge(I1,'canny',0.2);  %%%%%Edge detection
figure;
imshow(I2)
imwrite(I2,'pic_3.jpg','jpg','Quality',100);

se=strel('disk',15,6);

I3=imdilate(I2,se);%%%%dilation

I4=imfill(I3,'holes');

se=strel('disk',4,4);
BW=imerode(I4,se);
BW=imerode(BW,se);
BW=imerode(BW,se);
BW=imerode(BW,se);
BW=imerode(BW,se);
BW=imerode(BW,se);
BW1=bwmorph(BW,'clean');

figure;
imshow(BW1);
s = regionprops(BW1,'BoundingBox');
obstacle1=BW1(round(s(1).BoundingBox(1):s(1).BoundingBox(1)+s(1).BoundingBox(3)),round(s(1).BoundingBox(2):s(1).BoundingBox(2)+s(1).BoundingBox(4)));

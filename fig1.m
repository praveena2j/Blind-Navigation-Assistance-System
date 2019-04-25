clc;
clear all;
close all;
d=0.05;
I=imread('pic.jpg');
I1=rgb2gray(imresize(I,[750 1125]));
tight_subplot(1,2,1,[.01 .03],[.1 .1],[.01 .01]);
  for ii = 1:6; 
      axes(ha(ii)); 
      plot(randn(10,ii)); 
  end

imshow(uint8(I));
title('a');
tight_subplot(1,2,2,[.01 .03],[.1 .1],[.01 .01]);
imshow(uint8(I1));
title('b');
clear all;
clc;
Pic=imread('original.png');%原始图像
Pic_gray=rgb2gray(Pic);
figure(1);
imshow(Pic_gray);%显示灰度图像
L=3;%中值滤波方框边长
Pic_medfilted=medfilt2(Pic_gray,[L L]);
figure(2);
imshow(Pic_medfilted);%中值滤波之后的图像
threshold=graythresh(Pic_medfilted);
Pic_af_segment=imbinarize(Pic_medfilted,threshold);
figure(3);
imshow(Pic_af_segment);%阈值分割之后的图像
R=3;
SE=strel('disk',R,0);%腐蚀膨胀的模板
Pic_eroded=imerode(Pic_af_segment,SE);
Pic_dilated=imdilate(Pic_eroded,SE);
figure(4);
imshow(Pic_eroded);%腐蚀之后的图像
figure(5);
imshow(Pic_dilated);%膨胀之后的图像
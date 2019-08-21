clear all;
clc;
Pic=imread('original.png');%ԭʼͼ��
Pic_gray=rgb2gray(Pic);
figure(1);
imshow(Pic_gray);%��ʾ�Ҷ�ͼ��
L=3;%��ֵ�˲�����߳�
Pic_medfilted=medfilt2(Pic_gray,[L L]);
figure(2);
imshow(Pic_medfilted);%��ֵ�˲�֮���ͼ��
threshold=graythresh(Pic_medfilted);
Pic_af_segment=imbinarize(Pic_medfilted,threshold);
figure(3);
imshow(Pic_af_segment);%��ֵ�ָ�֮���ͼ��
R=3;
SE=strel('disk',R,0);%��ʴ���͵�ģ��
Pic_eroded=imerode(Pic_af_segment,SE);
Pic_dilated=imdilate(Pic_eroded,SE);
figure(4);
imshow(Pic_eroded);%��ʴ֮���ͼ��
figure(5);
imshow(Pic_dilated);%����֮���ͼ��
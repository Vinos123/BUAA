clear all;
clc;

Pic=imread('houghorg.bmp');%原始图像
Pic_gray=rgb2gray(Pic);
imwrite(Pic_gray,'houghorggray.bmp');%灰度图像1
m=0;
sigma=0.01;
Pic_gau=imnoise(Pic_gray,'gaussian',m,sigma);
imwrite(Pic_gau,'houghgau.bmp');%高斯噪声的图像2
density=0.05;
Pic_salt=imnoise(Pic_gray,'salt & pepper',density);
imwrite(Pic_salt,'houghsalt.bmp');%椒盐噪声图像3
Pic_gau_medfilted=medfilt2(Pic_gau,[9 9]);
Pic_salt_medfilted=medfilt2(Pic_salt,[9 9]);

figure(1);
subplot(1,2,1);
imshow(Pic_gau_medfilted);%高斯噪声经过中值滤波之后的图像
subplot(1,2,2);
imshow(Pic_salt_medfilted);%椒盐噪声经过中值滤波之后的图像

%%%%%%%利用类间方差最大进行二值化处理%%%%%%%%%%%%%
Pic_gau_medfilted_bin=imbinarize(Pic_gau_medfilted,graythresh(Pic_gau_medfilted));%高斯经过二值化处理之后的图像4
Pic_salt_medfilted_bin=imbinarize(Pic_salt_medfilted,graythresh(Pic_salt_medfilted));%椒盐经过二值化处理之后的图像5
%%%%%%%%roberts%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pic_gau_robert=edge(Pic_gau_medfilted_bin,'roberts');
Pic_salt_robert=edge(Pic_gau_medfilted_bin,'roberts');
figure(2);
subplot(1,2,1);
imshow(Pic_gau_robert);%6
subplot(1,2,2);%
imshow(Pic_salt_robert);%7
figure(3);%8
imshow(Pic_gau);
hold on;
step_r=1;
step_angle=0.1;
r_min=40;
r_max=100;
threshold=0.5;
[para,index_op]=hough_circle(Pic_gau_robert,step_r,...
    step_angle,r_min,r_max,threshold);
center=[para(:,2),para(:,1)];
Radi=para(:,3);
viscircles(center,Radi);
%%%%%%%Sobel%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pic_gau_sobel=edge(Pic_gau_medfilted_bin,'sobel');
Pic_salt_sobel=edge(Pic_gau_medfilted_bin,'sobel');
figure(4);
subplot(1,2,1);
imshow(Pic_gau_sobel);
subplot(1,2,2);
imshow(Pic_salt_sobel);
[H_g_s, THETA_g_s, RHO_g_s] = hough(Pic_gau_sobel);
[H_s_s, THETA_s_s, RHO_s_s] = hough(Pic_salt_sobel);
P_g_s=houghpeaks(H_g_s);
P_s_s=houghpeaks(H_s_s);
lines_g_s=houghlines(Pic_gau_sobel,THETA_g_s,RHO_g_s,P_g_s);
lines_s_s=houghlines(Pic_salt_sobel,THETA_s_s,RHO_s_s,P_s_s);

%%%%%%%log%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pic_gau_log=edge(Pic_gau_medfilted_bin,'log');
Pic_salt_log=edge(Pic_gau_medfilted_bin,'log');
figure(5);
subplot(1,2,1);
imshow(Pic_gau_log);
subplot(1,2,2);
imshow(Pic_salt_log);
[H_g_l, THETA_g_l, RHO_g_l] = hough(Pic_gau_log);
[H_s_l, THETA_s_l, RHO_s_l] = hough(Pic_salt_log);
P_g_l=houghpeaks(H_g_l);
P_s_l=houghpeaks(H_s_l);
lines_g_l=houghlines(Pic_gau_log,THETA_g_l,RHO_g_l,P_g_l);
lines_s_l=houghlines(Pic_salt_log,THETA_s_l,RHO_s_l,P_s_l);


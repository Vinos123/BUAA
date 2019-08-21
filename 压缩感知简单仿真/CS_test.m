ll=2000;
k=1;
filename='CS_final.gif';
for ii=200:100:ll
    [x1,x_0,y_0]=CS_1('cameraman.tif',ii);
    %figure(k);
    img{k}=uint8(reshape(x1,x_0,y_0));
    [temp,map]=gray2ind(img{k},256);
    if k==1
        imwrite(temp,map,filename,'gif','LoopCount',Inf,'Delaytime',0.3);
    else
        imwrite(temp,map,filename,'gif','WriteMode','append','DelayTime',0.3);
    end   
    k=k+1;
end
figure(3);
imshow('cameraman.tif');

   
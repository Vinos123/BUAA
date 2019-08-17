import numpy as np
from PIL import Image
from pylab import *
import matplotlib. pyplot as plt
def ZScan(img):#Z扫描函数
        Z = []
        i = j = 0
        while i < 8 and j < 8:
            if j < 7:
                j = j + 1
            else:
                i = i + 1
            while j >= 0 and i < 8:
                Z.append(img[i][j])
                i = i + 1
                j = j - 1
            i = i - 1
            j = j + 1
            if i < 7:
                i = i + 1
            else:
                j = j + 1
            while j < 8 and i >= 0:
                Z.append(img[i][j])
                i = i - 1
                j = j + 1
            i = i + 1
            j = j - 1
        return Z
def RLC(a):#游程编码函数
        temp = []
        numof0 = 0
        for num in a:
            if num == 0:
                numof0 += 1
            else:
                temp.append([numof0, num])
                numof0 = 0
        if numof0 != 0:
            temp.append([0, 0])
        return temp    
def DPCM(blocks):#差分编码函数
    temp_1 = np.empty(Length*Length)
    temp = np.empty((Length*Length))
    temp[0]=blocks[0,0]
    k=0
#     temp.append(blocks(0,0))
    for i in range(Length):
        for j in range(Length):
            temp_1[k]=blocks[i*8,j*8]
            k=k+1
    for ii in range(len(temp_1)-1):
        temp[ii+1]=temp_1[ii+1]-temp_1[ii]
    return temp
def DtoB(num):#十进制转二进制
#     num = int(num)
    s ='{0:b}'.format(abs(num))
    if num < 0:
        s2 = ''
        for c in s:
            s2 += '0' if c == '1' else '1'
        return s2
    else:
        return s
def VLI(num):#返回编码的位数
        if num == 0:
            return 0
        s = DtoB(num)
        return int(len(s))
pil_im=Image.open('/Users/kobezhe/Documents/MATLAB/cameraman.tif')#读入图片，实际使用时要根据具体电脑修改路径
# plt.imshow(pil_im)
N=8
DCT_mat=np.zeros((N,N))#初始化数组，8*8的DCT矩阵
DCT_mat[0,:]=np.sqrt(1/N)
for i in range(1,N):
    for j in range(N):
        DCT_mat[i,j]=np.cos(np.pi * i * (2*j+1) /(2*N)) * np.sqrt(2/N)#根据二维DCT公式计算DCT核矩阵
    
data_1=np.array(pil_im)
# data_1=data_1[64:128,64:128]#取一部分图像做处理
[x_1,y_1]=np.shape(data_1)
res_1=np.ones(np.shape(data_1))
Length=int(np.rint(x_1/N))
#DCT
for n in range(Length):
    for m in range(Length):
        res_1[(n*N):((n+1)*N),(m*N):((m+1)*N)]=np.dot(DCT_mat,data_1[(n*N):((n+1)*N),(m*N):((m+1)*N)])
        res_1[(n*N):((n+1)*N),(m*N):((m+1)*N)]=np.dot(res_1[(n*N):((n+1)*N),(m*N):((m+1)*N)],np.transpose(DCT_mat))
# imshow(res_1)
#亮度量化矩阵
Qua=([16,11,10,16,24,40,51,61],
     [12,12,14,19,26,58,60,55],
     [14,13,16,24,40,57,69,56],
     [14,17,22,29,51,87,80,62],
     [18,22,37,56,68,109,103,77],
     [24,35,55,64,81,104,113,92],
     [49,64,78,87,103,121,120,101],
     [72,92,95,98,112,100,103,99]
    )
Qua=np.array(Qua)#转换为数组形式
for n in range(Length):
    for m in range(Length):
        res_1[(n*N):((n+1)*N),(m*N):((m+1)*N)]=res_1[(n*N):((n+1)*N),(m*N):((m+1)*N)]/Qua
res_2=np.rint(res_1)#对元素取整

k=0
[x,y]=np.shape(res_2)
Z=np.zeros((x*y-Length*Length))
for i in range(Length):
    for j in range(Length):
    #   print(np.array(ZScan(list((res_2[(i*N):(i+1)*N,(j*N):(j+1)*N])))))
        Z[(k*63):((k+1)*63)]=np.array(ZScan(list((res_2[(i*N):(i+1)*N,(j*N):(j+1)*N]))))
        k=k+1
        #进行Z形扫描

AC=RLC(Z)#取AC系数进行游程编码
DC=DPCM(res_2)#取DC系数进行DPCM编码
DC=np.array(DC)
DC_1=np.empty(np.shape(DC))
DC_2=np.empty(np.shape(DC))
Bit=0
[x_AC,y_AC]=np.shape(AC)
for ii in range(len(DC)):
    Bit=Bit+int(VLI(int(DC[ii])))#得到DC系数的总位数
for jj in range(x_AC):
    Bit=Bit+int(VLI(int(AC[jj][1])))
    Bit=Bit+int(VLI(int(AC[jj][0])))
#得到压缩后的总位数
Rate=x_1*y_1*8/Bit
print("压缩率为：",Rate)#压缩率
#恢复量化
res_3=np.zeros(np.shape(res_2))
for n in range(Length):
    for m in range(Length):
        res_3[(n*N):((n+1)*N),(m*N):((m+1)*N)]=np.array(res_2[(n*N):((n+1)*N),(m*N):((m+1)*N)])*Qua
#IDCT
for n in range(Length):
    for m in range(Length):
        res_3[(n*N):((n+1)*N),(m*N):((m+1)*N)]=np.dot(np.transpose(DCT_mat),res_3[(n*N):((n+1)*N),(m*N):((m+1)*N)])
        res_3[(n*N):((n+1)*N),(m*N):((m+1)*N)]=np.dot(res_3[(n*N):((n+1)*N),(m*N):((m+1)*N)],DCT_mat)

res_3=Image.fromarray(res_3)#转化为图像格式
plt.figure()
# plt.rcParams['font.sas-serif']=['SimHei']#显示中文标签
# plt.rcParams['font.sans-serif']=['SimHei']
# plt.rcParams['axes.unicode_minus'] = False
# plt.rcParams['font.sans-serif'] = ['SimHei']
# plt.rcParams['axes.unicode_minus'] = False
plt.subplot(2,2,1)
plt.imshow(pil_im)
plt.title('Original')
plt.axis('off')
plt.subplot(2,2,2)
plt.imshow(res_1)
plt.title('DCT&Quatization')
plt.axis('off')
plt.subplot(2,2,3)
plt.imshow(res_2)
plt.title('Int')
plt.axis('off')
plt.subplot(2,2,4)
plt.imshow(res_3)
plt.title('result')
plt.axis('off')
show()#显示恢复后的图片
import pandas as pd 
import os
from openpyxl import Workbook,load_workbook
import re

path = r'D:/Tang/vtm7.xlsx'#这个是所有excel文件夹的路径
pathfile = 'D:/Tang'#这个比上面那个多了个/，修改的化改这两个就行
data_list=[]
Depth_list=[]
f=open(path,'rb')
data=pd.read_excel(f)
x=data.shape
length=x[0]
data_list=list(data.iloc[0:length-1,0])
for data_temp in data_list:
    if(data_temp.find('Depth')!=-1):
        Depth_list.append(data_temp)

print(Depth_list)
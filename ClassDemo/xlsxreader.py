#excel read test
import re
import xlrd


data = xlrd.open_workbook('/Users/kobezhe/Downloads/class.xls')
sheet1 = data.sheets()[0]
rows=sheet1.nrows
cols=sheet1.ncols
rowvalue = sheet1.row_values(0)
colvalue = sheet1.col_values(0)
Classstore=[[0 for rowx in range (rows)] for colx in range (cols)]
for rowx in range (rows):
    for colx in range (cols):
        Classstore[rowx][colx]=sheet1.cell(rowx,colx)

pattern = re.compile(r'\d+')#匹配至少一个数字

class_week_begin=[[0 for rowx in range (rows)] for colx in range (cols)]
class_week_end = [[0 for rowx in range (rows)] for colx in range (cols)]

class_begin=[]
class_end=[]
class_time=[]
class_weekday=[]
class_inform=[]
class_name=[]
for colx in range (2,cols):
    for rowx in range (2,cols):
        if(Classstore[rowx][colx].value !='' ):
            class1=pattern.findall(Classstore[rowx][colx].value)
            class_time.append(rowx-1)
            class_weekday.append(colx-1)
            Classstore[rowx][colx] = re.sub(r'\n',"",Classstore[rowx][colx].value)
            class_inform.append(Classstore[rowx][colx])
            if(class1!=[]):
                # print(class1)
                class_begin.append(class1[0])
                class_end.append(class1[1])
                # print(class_begin)
                # print(class_end)

headStr = '{\n"classInfo":[\n'
tailStr = ']\n}'
classInfoStr = ''
itemheadStr='{\n'
itemtailStr='\n}'

class_weekday=[str(i) for i in class_weekday]
class_time = [str(i) for i in class_time]
ii=0
classInfoStr += headStr
for inform in class_inform:
    itemClassinfostr = ""
    itemClassinfostr = itemheadStr + ' "className":" ' + inform +' ", '
    itemClassinfostr +='"week":{\n"startWeek":' + class_begin[ii] + ',\n'
    itemClassinfostr +='"endWeek":' + class_end[ii] + '\n},\n'
    itemClassinfostr +='"weekday":' + class_weekday[ii] + ',\n'
    itemClassinfostr +='"classTime":' + class_time[ii] + '\n'
    itemClassinfostr +=itemtailStr
    classInfoStr += itemClassinfostr
    if ii!=len(class_inform)-1:
        classInfoStr +=","
    ii += 1
classInfoStr += tailStr

with open('/Users/kobezhe/Downloads/BUAA/BUAA/ClassDemo/conf_classInfo.json','w') as f:
    f.write(classInfoStr)
    f.close()
print("\nALL DONE !")
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torchvision import datasets, transforms
import matplotlib.pyplot as plt
import numpy as np
torch.__version__

BATCH_SIZE=512 
EPOCHS=10 # 总共训练批次
#DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu") 
# global test_loss_list,correct_list

train_loss_list=[]
test_loss_list=[]
correct_list=[]#存储损失函数和准确率

train_dataset=datasets.MNIST('data', train=True, download=False, 
                       transform=transforms.Compose([
                           transforms.ToTensor(),
                           transforms.Normalize((0.1307,), (0.3081,))#均值和标准差
                       ]))
train_loader = torch.utils.data.DataLoader(train_dataset,
        batch_size=BATCH_SIZE, shuffle=True)

test_dataset=datasets.MNIST('data', train=False, transform=transforms.Compose([
                           transforms.ToTensor(),
                           transforms.Normalize((0.1307,), (0.3081,))
                       ]))
test_loader = torch.utils.data.DataLoader(test_dataset,
        batch_size=BATCH_SIZE, shuffle=True)

class ConvNet(nn.Module):##conv模型
    def __init__(self):
        super().__init__()
        # 1,28x28
        self.conv1=nn.Conv2d(1,10,5) # 10, 24x24
        self.conv2=nn.Conv2d(10,20,3) # 128, 10x10
        self.fc1 = nn.Linear(20*10*10,500)
        self.fc2 = nn.Linear(500,10)
    def forward(self,x):
        in_size = x.size(0)
        out = self.conv1(x) #24
        out = F.relu(out)
        out = F.max_pool2d(out, 2, 2)  #12
        out = self.conv2(out) #10
        out = F.relu(out)
        out = out.view(in_size,-1)
        out = self.fc1(out)
        out = F.relu(out)
        out = self.fc2(out)
        out = F.log_softmax(out,dim=1)
        return out

model = ConvNet()#.to(DEVICE)
optimizer = optim.Adam(model.parameters())##利用adam优化器更新权重
#####训练#############
def train(model, train_loader, optimizer, epoch):
    model.train()
    for batch_idx, (data, target) in enumerate(train_loader):
        #data, target = data.to(device), target.to(device)
        optimizer.zero_grad()
        output = model(data)
        loss = F.nll_loss(output, target)
        train_loss_list.append(loss)
        loss.backward()
        optimizer.step()
        if(batch_idx+1)%30 == 0: 
            print('Train Epoch: {} [{}/{} ({:.0f}%)]\tLoss: {:.6f}'.format(
                epoch, batch_idx * len(data), len(train_loader.dataset),
                100. * batch_idx / len(train_loader), loss.item()))
#####测试###############
def test(model, test_loader):
    model.eval()

    test_loss = 0
    correct = 0

    with torch.no_grad():
        for data, target in test_loader:
           # data, target = data.to(device), target.to(device)
            output = model(data)#给出对各个数字预测的概率
            test_loss += F.nll_loss(output, target, reduction='sum').item() # 将一批的损失相加
            pred = output.max(1, keepdim=True)[1] # 找到概率最大的下标，即预测的结果

            correct += pred.eq(target.view_as(pred)).sum().item()

    test_loss /= len(test_loader.dataset)
    
    test_loss_list.append(test_loss)
#     pred_list=pred_list.append(pred)
    correct_list.append(100.*correct/len(test_loader.dataset))
    
    print('\nTest set: Average loss: {:.4f}, Accuracy: {}/{} ({:.0f}%)\n'.format(
        test_loss, correct, len(test_loader.dataset),
        100. * correct / len(test_loader.dataset)))

    
# checkpoint=torch.load('/Users/kobezhe/Documents/torchcache/mnist.pt')
# model.load_state_dict(checkpoint['net'])
# optimizer.load_state_dict(checkpoint['optimizer'])
# start_epoch=checkpoint['epoch']+1
# test(model,test_loader)


for epoch in range(1, EPOCHS + 1):
    train(model, train_loader, optimizer, epoch)
    test(model,test_loader)
#保存网络参数
state={
    'epoch':epoch,
    'net':model.state_dict(),
    'optimizer':optimizer.state_dict()
}
torch.save(state,'/Users/kobezhe/Documents/torchcache/mnist.pt')

########绘制损失值曲线################
fig=plt.figure()
ax=fig.add_subplot(111)
ax.set(title='loss',xlabel='Number',ylabel='loss')
train_loss_list
train_num=range(len(train_loss_list))
plt.plot(train_num,train_loss_list)
plt.title('loss')
########绘制准确率曲线################
fig1=plt.figure()
epoch2show=range(len(correct_list))
ax2=fig1.add_subplot(121)
ax2.set(title='Accuracy',xlabel='Epoch',ylabel='Accuracy')
plt.plot(epoch2show,correct_list)
###########添加噪声#######################
import skimage as sk
correct_list=[]
for jj in range(0,20):
    test_list=list(test_dataset)
    vari=0.1*jj
    print(vari)
    for ii in range(0,10000):
        test_list[ii][0][0]=torch._C.from_numpy(sk.util.random_noise(test_list[ii][0][0],mode='gaussian',clip=True,seed=None,var=vari))
    test_loader_list=torch.utils.data.DataLoader(test_list,batch_size=BATCH_SIZE,shuffle=False)
    test(model,test_loader_list)
#     test_list[ii][0][0]=test_list[ii][0][0]+sigma*torch.randn(test_dataset[0][0][0].size())

##########绘制准确率随噪声方差变化的曲线#############
fig2=plt.figure()
# epoch2show=range(len(correct_list))
ax3=fig2.add_subplot(121)
ax3.set(title='Accuracy~Noise',xlabel='Var',ylabel='Accuracy')
correct2plot=np.arange(0,len(correct_list)*0.1,0.1)
plt.plot(correct2plot,correct_list)
plt.show()
#########显示添加噪声后的图像########
plt.imshow(test_list[0][0][0],cmap='gray')
plt.show()
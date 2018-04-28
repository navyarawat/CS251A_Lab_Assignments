from sys import argv
import numpy as np
import matplotlib.pyplot as plt

#STEP ONE
train, test = argv[1:]
handle = open(train)
lines = handle.read().split('\n')
lines.pop(0)
lines.pop()
n_train = len(lines)

features = []
labels = []
for line in lines:
	if line == '':
		continue
	x,y = map(float,line.split(','))
	features.append(x)
	labels.append(y)

x_train = np.vstack(features)
y_train = np.vstack(labels)
shape = (len(x_train),1)
new_x_train = np.append(np.ones(shape, dtype = np.int),x_train,axis = 1)

#STEP TWO
w = np.random.rand(2,1)

#STEP THREE
plt.title("Plot after random intialization of weights")
plt.plot(x_train, y_train,'r.')
a = np.matmul(new_x_train,w)
plt.plot(x_train,a)
plt.show()

#STEP 4
w_direct = np.matmul(np.linalg.inv(np.matmul(new_x_train.T,new_x_train)),np.matmul(new_x_train.T,y_train))

plt.title("Result of direct method")
b = np.matmul(new_x_train,w_direct)
plt.plot(x_train, y_train,'r.')
plt.plot(x_train,b,)
plt.show()

#STEP FIVE
eta = 1e-8
epoch = 1
for nepoch in xrange(epoch):
	for j in xrange(n_train):
		x = new_x_train[j].reshape(1,-1)
		y = labels[j]
		w = w - eta*(np.dot(x,w)-y)*(x.T)
		if j%100 == 0:
			plt.title("Training......")
			plt.plot(x_train, y_train,'r.')
			plt.plot(x_train,np.matmul(new_x_train,w))
			

#STEP 6
plt.title("Training Done")
plt.plot(x_train, y_train,'r.')
plt.plot(x_train,np.matmul(new_x_train,w))
plt.show()

#STEP 7
Handle = open(test)
Lines = Handle.read().split('\n')
Lines.pop(0)
n_test = len(Lines)

Features = []
Labels = []
for line in Lines:
	if line == '':
		continue
	x,y = map(float,line.split(','))
	Features.append(x)
	Labels.append(y)

x_test = np.vstack(Features)
y_test = np.vstack(Labels)
shape = (len(x_test),1)
new_x_test = np.append(np.ones(shape, dtype = np.int),x_test,axis = 1)

y1_pred = np.matmul(new_x_test,w)				#start testing
y2_pred = np.matmul(new_x_test,w_direct)
#print w, w_direct
print "RMSE between y1_pred and y_test:{0}".format(np.linalg.norm(y1_pred-y_test)/np.sqrt(len(y_test)))
print "RMSE between y2_pred and y_test:{0}".format(np.linalg.norm(y2_pred-y_test)/np.sqrt(len(y_test)))

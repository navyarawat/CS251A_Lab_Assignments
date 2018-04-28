from __future__ import print_function
import numpy as np
import matplotlib.pyplot as plt
import argparse

#parsing arguments
parser = argparse.ArgumentParser(description='Name of files')

parser.add_argument('--train', type=str, 
                    help='Path to Train data file')
parser.add_argument('--test', type=str,
                    help='Path to Test data file')

args = parser.parse_args()

if args.train:
    train = args.train
else:
    train = 'train.csv'

if args.test:
    test = args.test
else:
    test = 'test.csv'

#Loading training data
x_train, y_train = np.loadtxt(train, delimiter=',', skiprows=1).T
x_train = np.c_[np.ones(x_train.shape),x_train]

#Random intialization of weights
w = np.random.rand(2,)

#Plotting after intializing weights
plt.title("Plot after random intialization of weights")
plt.plot(x_train[:,1], y_train, color='red')
plt.plot(x_train[:,1], np.matmul(x_train,w), color='blue')
plt.show()


#direct method
w_direct = np.matmul(np.linalg.pinv(np.matmul(x_train.T,x_train)),np.matmul(x_train.T,y_train))


#Plotting result of direct method
plt.title("Result of direct method")
plt.plot(x_train[:,1], y_train, color='red')
plt.plot(x_train[:,1], np.matmul(x_train,w_direct), color='blue')
plt.show()


#hyperparameters
eta = 1e-8
epoch = 1

#SGD
for nepoch in range(epoch):
    for j,(x,y) in enumerate(zip(x_train,y_train)):
        w = w - eta*(np.dot(x,w)-y)*(x.T)
        
        #if j%100 == 0:
           # plt.title("Training ......")
           # plt.plot(x_train[:,1], y_train, color='red')
           # plt.plot(x_train[:,1], np.matmul(x_train,w), color='blue')
           # plt.pause(0.000001)
plt.title("Training Done")
plt.show()
print(w,w_direct)
#Plotting result of SGD
plt.title("Result of SGD")
plt.plot(x_train[:,1], y_train, color='red')
plt.plot(x_train[:,1], np.matmul(x_train,w), color='blue')
plt.show()


#Loading test data
x_test, y_test = np.loadtxt(test, delimiter=',', skiprows=1).T
x_test = np.c_[np.ones(x_test.shape),x_test]

#Testing
y1_pred = np.matmul(x_test,w)
print("RMSE error between y1_pred and y_test:{0}".format(np.linalg.norm(y1_pred-y_test)/np.sqrt(len(y_test))))

y2_pred = np.matmul(x_test,w_direct)
print("RMSE error between y2_pred and y_test:{0}".format(np.linalg.norm(y2_pred-y_test)/np.sqrt(len(y_test))))

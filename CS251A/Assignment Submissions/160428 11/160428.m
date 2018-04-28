file = csvread('train.csv');

x_train = file(2:end,1);
y_train = file(2:end,2);
vector_1 = ones(rows(x_train),1);
new_x_train = [vector_1,x_train];

%step 2
w = rand(2,1);

%step 3
plot(x_train,y_train);
title('Plot after random intialization of weights');
hold on;
a = new_x_train * w;
plot(x_train,a,'r');
print('fig1.pdf');
figure;

%step 4
w_direct = inv(new_x_train' * new_x_train) * (new_x_train' * y_train);
b = new_x_train * w_direct;
scatter(x_train,y_train,'k');
title('Result of direct method');
hold on;
plot(x_train,b,'g');
print('fig2.pdf');
figure;

%step 5
Eta = 1e-8;
epoch = 2;

for nepoch = 1:epoch
    hold on;
    plot(x_train,y_train);
    title('Training......');
    for j = 1:rows(x_train)
        x = new_x_train(j,:);
        y = y_train(j,:);
        w = w - Eta * (dot(x',w) - y) * (x');
        if (rem(j,100) == 0 && j < 1001)
            plot(x_train,new_x_train * w);
        endif
    endfor
endfor

%step 6
print('fig3.pdf');
figure;
plot(x_train, y_train,'k');
title('Training Done');
hold on;
plot(x_train,new_x_train*w);
print('fig4.pdf');

%step 7
file2 = csvread('test.csv');
x_test = file2(2:end,1);
y_test = file2(2:end,2);
vector_1 = ones(rows(x_test),1);
new_x_test = [vector_1,x_test];
y1_pred = new_x_test * w;
y2_pred = new_x_test * w_direct;

rms1 = norm(y1_pred - y_test)/sqrt(rows(y_test));
rms2 = norm(y2_pred - y_test)/sqrt(rows(y_test));

printf('RMSE between y1_pred and y_test = %f\n',rms1);
printf('RMSE between y2_pred and y_test = %f\n',rms2);

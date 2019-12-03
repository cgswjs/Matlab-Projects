clear all;
clc;
close all;

%% Load Data and Initialize Variables
fprintf('Loading data and initializing variables');
t = cputime;
data = load('housing_training.csv');
X = data(:, 1:13); % Features
y = data(:, 14); % Medium Value
m = length(y); % Number of training examples
d = size(X,2); % Number of features.
theta = zeros(d+1,1); % Initialize slope theta to zero.
alpha = 0.05; % Learning rate
numIters = 5000; % How long gradient descent should run for
fprintf('...done\n');

%% Calculate Theta from Normal Equation
fprintf('Calculating theta via normal equation');
XNormEqn = [ones(m,1) X];
thetaNormEqn = NormalEquation(XNormEqn,y);%Intercept and coefficients
fprintf('...done\n');
fprintf('Intercept and Coefficients:\n');
disp(thetaNormEqn)%Intercept and coefficients

%% Feature Normalization
fprintf('Normalizing Features for gradient descent');
[X, mu, stddev] = featureNormalize(X);
fprintf('...done\n');

%% Prdeiction of test house prices
data_pred=load('housing_test.csv');
X_pred=data_pred(:,1:13);%extract features from test data
eg1=zeros(size(X_pred,1),15);%create a table to store test results
eg1(:,14)=data_pred(:,14);%put 14 column to new table
for i=1:size(X_pred,1)
    eg1(i,1:13)=X_pred(i,:);%extract features for each row
    price = (eg1(i,1:13))*thetaNormEqn(2:14)+thetaNormEqn(1);%get predict price for each row
    eg1(i,15)=price;%set the last column 
    
end

RMSE=sqrt(sum((eg1(:,14)-eg1(:,15)).^2)/m);
fprintf('RMSE Calculated for test data:\n')
disp(RMSE)
PredictTest=eg1;

figure('Name','Original Value')
plot(eg1(:,14),'o')
ylabel('Ground Truth')
title('Test Data Original Value')

figure('Name','Prediction')
plot(eg1(:,15),'x')
ylabel('Prediction')
title('Prediction Value after Linear Regression')
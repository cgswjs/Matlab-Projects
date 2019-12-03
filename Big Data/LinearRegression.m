clear all;
clc;
close all;

%% Load data into the initializing procedure
fprintf('Load data and Initialize');
data = load('housing_training.csv');
X = data(:, 1:13); % columns of features
y = data(:, 14); % Median value of the homes in $1000
N = length(y); % Number of the training data (300 in this case)
NumOfFeatures = size(X,2); 
Coef = zeros(NumOfFeatures+1,1); 

%% Using the NormalEquation to calculate coefficients
fprintf('Using the NE to calculate coefficients');
X_NE = [ones(N,1) X];  %add one colomn to the most left colomn to store intercept
Coef_NE = NormalEquation(X_NE,y);  %intercept and coefficients
fprintf('Intercept and Coefficients:\n');
disp(Coef_NE)  

%% Prdeiction of test house pricing
data_pred=load('housing_test.csv'); %load test data
X_pred=data_pred(:,1:13);  %extract features from test data
eg1=zeros(size(X_pred,1),15);  %create a matrix to store test results
eg1(:,14)=data_pred(:,14);  %put test data to new matrix
for i=1:size(X_pred,1)
    eg1(i,1:13)=X_pred(i,:);  %extract features for each row
    price = (eg1(i,1:13))*Coef_NE(2:14)+Coef_NE(1); %get predict price for each row
    eg1(i,15)=price;  %store the predicted price to the last column    
end

RMSE=sqrt(sum((eg1(:,14)-eg1(:,15)).^2)/size(X_pred,1));
fprintf('RMSE Calculated for test data:\n')
disp(RMSE)


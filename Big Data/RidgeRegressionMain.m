clear all;
clc;
close all;

%% Load data into the initializing procedure
images = load('MNIST_15_15.csv');%load image
labels = load('MNIST_LABEL.csv');%load label
% imagesc(reshape(images(1,:),15,15)); %show 1st MNIST picture
figure
hold on
for NoT=1:10 %train 10 times
    fprintf('Load MNIST data and Initialize training sequence %.0f\n',NoT);
    dfs=10;%training data update rate
    N=round(size(images,2)/2)+(NoT-1)*dfs; %number of training data
    X = images(1:N,:); % features
    y = labels(1:N,1); % labels
    NumOfFeatures = size(X,2);
    Coef = zeros(NumOfFeatures+1,1);
    
    %% Using the NormalEquation to calculate coefficients
    fprintf('Using the NE to calculate coefficients\n');
    X_NE = [ones(N,1) X];  %add one colomn to the most left colomn to store intercept
    
    %% Ridge Regression
    %Constants
    Thr=0.02;%threshold for coefficients
    
    %Ridge coefficients calculation
    lambda=0;%initial value of lambda
    dlambda=0.01;%change of lambda for each iteration
    iterNum=200;%iteration time
    %     figure('Name','Ridge Regression')
    %     hold on
    for i=1:iterNum
        lambdaM(i)=lambda;%store lambda for each iteration
        Ridge_Coef=RidgeCoef(X_NE,y,lambda)';
        Ridge_CoefM(i,:)=Ridge_Coef(:);%store Ridge_Coef_1 for each iteration for debug
        lambda=lambda+dlambda;%update lambda
%         plot(lambda,Ridge_Coef(1),'o')
        plot(lambda,Ridge_Coef(1),'d')
        drawnow  
    end
    
    %     stem(Ridge_Coef,'diamond','MarkerSize',4,'LineWidth',0.3)
    %     ylim([-1 1])
    %     yline(Thr,'k--','LineWidth',2);
    %     yline(-Thr,'k--','LineWidth',2);
    
    %% Thresholding and Prediction
    X_predf=images(N+1:size(images,1),:); %extract features from test data
    X_predp=labels(N+1:size(images,1),1); %store test label
    count=1;%a counter to keep track on thresholding results
    Icpt=Ridge_Coef(1);%intercept
    
    %thresholding
    for i=1:size(images,2)
        %check coefficients' significance
        if abs(Ridge_Coef(i))>Thr
            Coef_Thr{NoT}(1,count)=i;%keep track of coefficient number
            Coef_Thr{NoT}(2,count)=Ridge_Coef(i);%store significant coefficients
            X_pred_Thr{NoT}(:,count)=X_predf(:,i);
            count=count+1;
        end
    end
    
    %prediction
    for i=1:size(X_pred_Thr{NoT},1)
        eg1(i,1:size(X_pred_Thr{NoT},2))= X_pred_Thr{NoT}(i,:);  %extract features for each row
        price = (eg1(i,1:size(X_pred_Thr{NoT},2))*Coef_Thr{NoT}(2,:)')+Icpt; %get predict price for each row
        X_predp(i,2)=price;  %store the predicted price to the last column
    end
    
    Training_Sample_No(NoT)=N;
    RMSE(NoT)=sqrt(sum((X_predp(:,1)-X_predp(:,2)).^2)/size(X_predp,1));
end
yline(Thr,'k--','LineWidth',2);
yline(-Thr,'k--','LineWidth',2);
hold off

fprintf('Number of training samples for each training session\n')
disp(Training_Sample_No)
fprintf('RMSE for each training case is\n')
disp(RMSE)

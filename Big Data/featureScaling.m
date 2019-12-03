function [X_N, x_bar, stdv] = featureScaling(X)
X_N = X;
x_bar = zeros(1, size(X, 2));
stdv = zeros(1, size(X, 2));

% Mean and standard deviation for each feature
for i=1:size(x_bar,2)
    x_bar(1,i) = mean(X(:,i)); %create x_bar matrix to store mean values
    stdv(1,i) = std(X(:,i));  %create stdv matrix to store computed standard deviation values
    X_N(:,i) = (X(:,i)-x_bar(1,i))/stdv(1,i);  %Normalization/feature scaling procedure
end
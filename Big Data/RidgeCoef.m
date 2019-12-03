function [Ridge_Coef]=RidgeCoef(X_NE,y,lambda)
Is=size(pinv((X_NE')*X_NE));
Ridge_Coef = pinv(((X_NE')*X_NE)+lambda*eye(Is))*X_NE'*y;
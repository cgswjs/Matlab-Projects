function coef_NE = NormalEquation(X_NE,y)
% Using the NormalEquation to calculate coefficients

coef_NE = pinv((X_NE')*X_NE)*X_NE'*y;
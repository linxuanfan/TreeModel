function RMSE = get_en_rmse(X,Y,w,b, SY)

y_pred = X * w + b;
RMSE = sqrt(mean((y_pred - Y) .^ 2)) * SY;

end
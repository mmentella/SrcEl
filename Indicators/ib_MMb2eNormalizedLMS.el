Inputs: price(MedianPrice),len(10),mu(1),epsilon(0.1),PlotRegressor(0);

array: w[50](0),u[50](0);

vars: j(0),k(0),norm2(0),gain(0),num(0),den(0),clms(0);

once begin
 cleardebug;
 ClearPrintLog;
end;

for j = len - 1 downto 0 begin
 
 MM.LA.FillArrayFromSerie(u,price,j+1,len);
 
 num = mu * (price[j] - MM.LA.InnerProduct(w,u,len));
 den = epsilon + MM.LA.SquareNorm(u,len);
 
 MM.LA.RescaleArray(u,num/den,len);
 
 MM.LA.SumArray(w,u,len);
 
end;

MM.LA.FillArrayFromSerie(u,price,0,len);

clms = MM.LA.InnerProduct(w,u,len);

plot1(clms,"Normalized LMS");

if plotregressor = 1 then
 plot2(price,"Regressor");

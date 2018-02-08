inputs: period(30), threshold(600), normcolor(blue), highcolor(red);

vars:
  int pace(0),
  int indx(0);
  


pace = 0;
indx = 0; 
while(indx < CurrentBar) begin
  value1 = time_s - time_s[indx];
  if(value1 < 0) then value1 = time_s + 240000 - time_s[indx];
  if(value1 < period) then pace = pace + barinterval
  else break;
  indx = indx + 1; 
end;

plot1(pace,"pace",iff(pace > threshold,highcolor,normcolor));

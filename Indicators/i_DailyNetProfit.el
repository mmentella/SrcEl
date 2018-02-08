vars: start(0),now(0);
vars: staro(0),noo(0);

if d <> d[1] then begin 
 
 staro = noo; 
 start = now;
 
end;

now = i_ClosedEquity;
noo = i_OpenEquity;

plot1(0,"Flat");
plot2(now - start,"Closed Equity");
plot3(noo - staro,"Open Equity");

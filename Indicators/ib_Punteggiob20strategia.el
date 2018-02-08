vars: maxeq(0),maxeqc(0),dwdq(0),dwdt(0),count(0),pq(0.00),pt(0.00);

maxeq = maxlist(maxeq,i_OpenEquity);

dwdq = maxlist(dwdq,maxeq-i_OpenEquity);
pq   = iff(dwdq>0,(maxeq - i_OpenEquity)/dwdq,0);

maxeqc = maxlist(maxeqc,i_ClosedEquity);

if d > d[1] then begin
 if i_ClosedEquity < maxeqc then begin
  count = count + 1;
  dwdt  = maxlist(dwdt,count);
 end else begin
  count = 0;
 end;
end;
pt = iff(dwdt>0,(count/dwdt),0);

if d <> d[1] then begin
 plot1(100*pq,"DWDQ",rgb(255,255 - intportion(255*pq),255 - intportion(255*pq)));
 plot2(100*pt,"DWDT",rgb(255,255 - intportion(255*pt),255 - intportion(255*pt)));
 plot3(100*(pt+pq),"PUNTEGGIO",rgb(255,255 - intportion(255*(pt+pq)/2),255 - intportion(255*(pt+pq)/2)));
end;

plot4(100,"Limit");

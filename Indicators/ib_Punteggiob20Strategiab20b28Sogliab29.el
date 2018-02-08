inputs: LevelDWDQ(40000),LevelDWDT(200);

vars: maxeq(0),maxeqc(0),dwdq(0),dwdt(0),pq(0.00),pt(0.00);

maxeq = maxlist(maxeq,i_OpenEquity);

dwdq  = maxeq - i_OpenEquity;
pq    = iff(LevelDWDQ>0,dwdq/LevelDWDQ,100);

maxeqc = maxlist(maxeqc,i_ClosedEquity);

if d > d[1] then begin
 if i_ClosedEquity < maxeqc then begin
  dwdt  = dwdt + 1;
 end else begin
  dwdt  = 0;
 end;
end;
pt = iff(LevelDWDT>0,dwdt/LevelDWDT,100);

if d <> d[1] then begin
 plot1(100*pq,"DWDQ",rgb(255,255 - intportion(255*pq),255 - intportion(255*pq)));
 plot2(100*pt,"DWDT",rgb(255,255 - intportion(255*pt),255 - intportion(255*pt)));
 plot3(100*(pt+pq),"PUNTEGGIO",rgb(255,255 - intportion(255*(pt+pq)/2),255 - intportion(255*(pt+pq)/2)));
end;


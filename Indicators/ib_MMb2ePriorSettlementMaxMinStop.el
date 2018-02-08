vars: sym(MidStr(getsymbolname,0,2)),settle(false),maxstp(0),minstp(0),plotmax(-1),plotmin(-1);

if sym = "LE" then begin
 
 if d <> d[1] then begin
  settle  = false;
  plotmax = maxstp;
  plotmin = minstp;
 end;
 
 if not settle and t >= 2000 then begin
  settle = true;
  maxstp = c + 3;
  minstp = c - 3;
 end;
 
end else if sym = "ZW" then begin
 
 if d > d[1] then begin
  settle  = false;
  plotmax = maxstp;
  plotmin = minstp;
 end;
 
 if not settle and t >= 2015 then begin
  settle = true;
  maxstp = c + 60;
  minstp = c - 60;
 end;
 
end else if sym = "ZS" then begin
 
 if d > d[1] then begin
  settle  = false;
  plotmax = maxstp;
  plotmin = minstp;
 end;
 
 if not settle and t >= 2015 then begin
  settle = true;
  maxstp = c + 70;
  minstp = c - 70;
 end;
 
end else if sym = "ZC" then begin
 
 if d > d[1] then begin
  settle  = false;
  plotmax = maxstp;
  plotmin = minstp;
 end;
 
 if not settle and t >= 2015 then begin
  settle = true;
  maxstp = c + 30;
  minstp = c - 30;
 end;
 
end else if sym = "CL" then begin
 
 if d > d[1] then begin
  maxstp = c[1] + 10;
  minstp = c[1] - 10;
  
  plotmax = maxstp;
  plotmin = minstp;
 end;
 
end;

if plotmax > 0 and plotmin > 0 then begin
 plot1(plotmax,"DAILY LIMIT - MAX");
 plot2(plotmin,"DAILY LIMIT - MIN");
end;

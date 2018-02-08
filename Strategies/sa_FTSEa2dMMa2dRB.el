vars: dhh(0),dll(0),yrange(0),yyrange(0),yhh(0),yll(0),trades(0);

if d <> d[1] then begin
 yhh = dhh;
 yll = dll;
 
 yyrange = yrange;
 yrange = yhh - yll;
  
 dhh = h;
 dll = l;
 
 trades = 0;
end else begin
 
 if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;
 
 if h > dhh then dhh = h;
 if l < dll then dll = l;

end;

if trades < 1 and yrange < yyrange then begin
 buy next bar at yhh stop;
 sellshort next bar at yll stop;
end;

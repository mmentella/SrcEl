vars: yh(0),yl(0),yo(0),yc(0);

vars: x(0),pvl(0),pvh(0);

if d <> d[1] then begin
 yc = c[1];
 
 x = .2*(yo + yl + yh + 2*yc);
 pvl = 2*x - yh;
 pvh = 2*x - yl;
 
 yh = h;
 yl = l;
 yo = o;
 
 value1 = 0;
end;

yh = maxlist(yh,h);
yl = minlist(yl,l);

if barssinceentry = 0 and marketposition <> 0 then value1 = value1 + 1;

if value1 < 1 then begin
 buy next bar at pvh stop;
 sellshort next bar at pvl stop;
end;

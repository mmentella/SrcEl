vars: yh(0),yl(0),yo(0),yc(0);

vars: x(0),pvl(0),pvh(0){,adxval(0,data2),dmip(0,data2),dmim(0,data2),dmix(0,data2)};

//if barstatus(2) = 2 then DirMovement(h,l,c,14,dmip,dmim,dmix,adxval,value2,value3)data2;

if d <> d[1] then begin
 yc = c[1];
 
 x = .2*(yo + yl + yh + 2*yc);
 pvl = 2*x - yh;
 pvh = 2*x - yl;
 
 //plot3(yh,"YH");
 //plot4(yl,"YL");
 //plot5(yo,"YO");
 //plot6(yc,"YC");
 
 yh = h;
 yl = l;
 yo = o;
end;

yh = maxlist(yh,h);
yl = minlist(yl,l);


plot1(pvl,"Support");
plot2(pvh,"Resistence");

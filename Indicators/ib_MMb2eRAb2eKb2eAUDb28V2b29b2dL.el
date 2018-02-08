inputs: lenl(3),kl(0.15),lens(3),ks(3.57),alfa(.2);
vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),mcp(0);

if barstatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 
 upperk = alfa*upperk + (1-alfa)*upperk[1];
 lowerk = alfa*lowerk + (1-alfa)*lowerk[1];
end;

plot1(upperk,"Upperk");
plot2(lowerk,"LowerK");

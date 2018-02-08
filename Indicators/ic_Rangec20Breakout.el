vars: pvt(0),hh(0),ll(0);

if c data2 > o data2 then begin
 hh = (2*h data2 + l data2 + c data2)/2 - l data2;
 ll = (2*h data2 + l data2 + c data2)/2 - h data2;
end else begin
 hh = (h data2 + 2*l data2 + c data2)/2 - l data2;
 ll = (h data2 + 2*l data2 + c data2)/2 - h data2;
end;
 
plot1(hh,"HH");
plot2(ll,"LL");

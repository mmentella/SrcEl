var: hh(o),ll(o),medianp(o),tc(0),max(1),min(-1);

if d > d[1] then begin 
 hh  =  o;
 ll  =  o;
 max =  1;
 min = -1;
end;

if c > hh then begin
 hh = c;
 medianp = 0.5*(hh + ll);
end else if c < ll then begin
 ll = c;
 medianp = 0.5*(hh + ll);
end;

tc  = (c - medianp) / (MinMove points);
max = maxlist(max,tc);
min = minlist(min,tc);

if tc > 0 then
 plot1(100*tc / max,"Tick Counter % Adaptive",green)
else
 plot1(-100*tc / min,"Tick Counter % Adaptive",red)

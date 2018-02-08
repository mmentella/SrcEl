inputs: length(8);

vars: num(0),den(0),count(0),rvi(0),max(0),min(0),var0(0),var1(0),var2(0),var3(0);

var0 = .1666*((c - o) + 2*(c[1] - o[1]) + 2*(c[2] - o[2]) + (c[3] - o[3]));
var1 = .1666*((h - l) + 2*(h[1] - l[1]) + 2*(h[2] - l[2]) + (h[3] - l[3]));

for count = 0 to length - 1 begin
 num = num +  var0[count];
 den = den + var1[count];
end;

if den <> 0 then rvi = num/den;

max = highest(rvi,length);
min = lowest(rvi,length);

if max <> min then var2 = (rvi - min)/(max - min);
var2 = .1*(4*var2 + 3*var2[1] + 2*var2[2] + var2[3]);
var3 = 2*(var2 - .5);

plot1(var3,"RVI");
plot2(.96*(var3[1] + .02),"Trigger");
plot3(0,"Ref");

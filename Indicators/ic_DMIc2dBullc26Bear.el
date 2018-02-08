Inputs: lenl(3),consl(4),diffl(38),lens(21),conss(3),diffs(25.4);

Vars: ddp(0),ddm(0);

ddp = DMIPlus(lenl) - DMIMinus(lenl);
ddm = DMIMinus(lens) - DMIPlus(lens);

plot1(ddp,"DMI+ - DMI-",white);
plot2(ddm,"DMI- - DMI+",white);
plot3(0,"Ref");

plot4(diffl,"LE",rgb(77,77,255));
plot5(diffs,"SE",rgb(166,42,42));

if ddp[consl] > 0 and ddp > diffl and CountIf(ddp > ddp[1],consl) = consl then
 for value1 = 0 to consl begin
  plot1[value1](ddp[value1],"DMI+ - DMI-",rgb(65,105,225));
 end;

if ddm[conss] > 0 and ddm > diffs and CountIf(ddm > ddm[1],conss) = conss then
 for value1 = 0 to conss begin
  plot2[value1](ddm[value1],"DMI+ - DMI-",rgb(192,0,0));
 end;  

inputs: price(MedianPrice);

vars: q1(0),i1(0),phase(0),diff(0),period(0);

q1 = .0962*price + .5769*price[2] - .5769*price[4] - .0962*price[6];
i1 = price[3];

if i1 <> 0 then phase = arctangent(q1/i1);
diff = absvalue(phase - phase[1]);
if diff <> 0 then period = 360/diff;

//plot1(i1,"InPhase");
//plot2(q1,"Quadrature");
plot3(phase,"Phase");

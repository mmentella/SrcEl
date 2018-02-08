Inputs: Length(10);

vars: avgmom(0),h2(0),h1(0),l2(0),l1(0);

avgmom = Average(absvalue(c - c[1]),length);

h1 = c[1] + avgmom;
h2 = h1 + avgmom;
l1 = c[1] - avgmom;
l2 = l1 - avgmom;

plot1(h1,"H1");
plot2(h2,"H2");
plot3(l1,"L1");
plot4(l2,"L2");

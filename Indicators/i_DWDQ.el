[intrabarordergeneration = true];
vars: intrabarpersist maxeq(0),intrabarpersist dwdq(0);

maxeq = maxlist(maxeq,i_OpenEquity);

dwdq = maxlist(dwdq,maxeq-i_OpenEquity);

plot1(dwdq,"DWDQ");

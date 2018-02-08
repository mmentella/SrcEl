Inputs: pctl(.173),pcts(.718);

if pctl <> 0 then plot1(c data2 - (range data2)*pctl,"Level Long");
if pcts <> 0 then plot2(c data2 + (range data2)*pcts,"Level Short");

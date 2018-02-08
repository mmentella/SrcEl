Inputs: price(c),len(10),prev(2),alpha(.25);

vars: lmsp(0);

lmsp = LMS(price,len,prev,.25);

plot1(lmsp,"LMS");

var: return(0),trend(0),trigger(0);

return = c/c[1] - 1;
MM.ITrend(return,0.07,trend,trigger);

plot1(trend,"Trend");
plot2(trigger,"Trigger");

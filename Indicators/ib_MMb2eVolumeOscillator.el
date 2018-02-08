vars: vol(0),osc(0);

vol = iff(bartype>=2,Volume,Ticks);

osc = MM.Cycle(vol,.07);

plot1(osc,"Volume Oscillator");
plot2(osc[1],"Volume Trigger");
plot3(0,"Ref");

Inputs: kl(2),ks(2),alphal(.07),alphas(.07),displace(-1);

vars: upk(0),ih(0),lok(0),il(0),itr(0),var0(0);

MM.ITrend(h,alphal,ih,var0);
MM.ITrend(truerange,alphal,itr,var0);

upk = ih + kl*itr;

MM.ITrend(l,alphas,il,var0);
MM.ITrend(truerange,alphas,itr,var0);

lok = il - ks*itr;

plot1[displace](upk,"UpperK");
plot2[displace](lok,"LowerK");

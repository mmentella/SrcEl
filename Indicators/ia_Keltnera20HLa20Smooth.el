Inputs: lenl(20),kl(2),lens(20),ks(2),alphal(.2),alphas(.2);

vars: upk(0),lok(0);

if currentbar > maxlist(lenl,lens) then begin

 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
 
 upk = MM.Smooth(upk,alphal);
 lok = MM.Smooth(lok,alphas);

end else begin
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
end;
plot1(upk,"Upper");
plot2(lok,"Lower");

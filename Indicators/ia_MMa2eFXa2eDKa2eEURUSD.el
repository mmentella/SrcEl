Inputs: FL(0.2),FS(1.2),KLenL(33),KLenS(27),MinLen(9),MaxLen(50),ShowPlot(true);

vars: UpperK(0),LowerK(0),K(0),SD(0),lenl(MinLen),lens(MinLen);
vars: idl(0),ids(0);

if currentbar = 1 then begin
 idl = text_new(d,t,c,"");
 ids = text_new(d,t,c,"");
 
 text_setstyle(idl,0,1);
 text_setcolor(idl,white);
 
 text_setstyle(ids,0,1);
 text_setcolor(ids,white);
end;

sd = StdDev(h,klenl);
if sd <> 0 then k = 1 - sd[1]/sd;

lenl = lenl*(1 + k);
lenl = MinList(lenl,MaxLen);
lenl = MaxList(lenl,MinLen);
lenl = floor(lenl);

UpperK = KeltnerChannel(h,lenl,fl);
 
sd = StdDev(l,klens);
if sd <> 0 then k = 1 - sd[1]/sd;

lens = lens*(1 + k);
lens = minlist(lens,maxlen);
lens = maxlist(lens,minlen);
lens = floor(lens);

lowerk = KeltnerChannel(l,lens,-fs);

if ShowPlot then begin
 plot1[-1](upperk,"UPK");
 plot2[-1](lowerk,"LOK");
end;

if LastBarOnChart then begin
 
 //if i_marketposition < 1 then begin
  text_setstring(idl,{NumToStr(lenl,0) + " => }"Buy at " + NumToStr(upperk,4));
  text_setlocation(idl,d,t+100,upperk);
  
  //text_setstring(ids,"");
 //end;
 
 //if i_marketposition > -1 then begin
  text_setstring(ids,{NumToStr(lens,0) + " => }"SellShort at " + NumToStr(lowerk,4));
  text_setlocation(ids,d,t+100,lowerk);
  
  //text_setstring(ids,"");
 //end;
 
end;

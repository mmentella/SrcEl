input: lenl(41),lens(22),EL_ReleaseDate(1111006);

var: hrl(0),hh(0);
var: hrs(0),ll(0);
var: id(0),start(0);

if hrl = 0 then begin

 hrl = AvgTrueRange(lenl);
 hrs = AvgTrueRange(lens);
 ll  = Lowest(l,lenl);
 hh  = Highest(h,lens);
 
 id    = text_new(0,0,0,"");
 
 text_setstyle(id,0,2);
 text_setsize(id,10);
 text_setcolor(id,white);
 text_setattribute(id,2,true);
 text_setattribute(id,1,true);
 
end else begin

 if marketposition < 1 and TrueRange > hrl and c > o and l < ll and DownTicks > UpTicks then
  buy next bar o;
  
 if marketposition > -1 and TrueRange > hrs and c < o and h > hh and UpTicks > DownTicks then
  sell short next bar o;
  
 hrl = AvgTrueRange(lenl);
 hrs = AvgTrueRange(lens);
 ll  = Lowest(l,lenl);
 hh  = Highest(h,lens);
 
 if getappinfo(aioptimizing) = 0 and d > EL_ReleaseDate then begin 
  
  if start = 0 then start = i_OpenEquity
  else begin
   text_setstring(id,NumToStr(i_OpenEquity - start,2));
   text_setlocation(id,d,t,c);
  end;
  
 end;

end;

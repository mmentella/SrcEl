var: counter(0),min(-1),max(1),tc(0),color(0);

if d = currentdate then begin 
 
 if d > d[1] then begin
  counter =  0;
  min     =  1;
  max     = -1;
 end else begin
  
  if c > c[1] then counter = counter + 1 
  else if c < c[1] then counter = counter - 1;
  
  if counter > 0 then  begin
   tc    = counter / max;
   color = green;
  end else begin
   tc    = -counter / min;
   color = red;
  end;
  
  plot1(100*tc,"Tick Counter",color);
  
  max = maxlist(max,counter);
  min = minlist(min,counter);
 
 end;
 
end; 

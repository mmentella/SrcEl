var: counter(0),ref(c);

if d = currentdate then begin 
 
 if d > d[1] then begin
  counter = 0;
  ref     = c;
 end else begin
  
  counter = (c - ref) / ( MinMove points);
  
  plot1(counter,"Tick Counter",iff(counter < 0,red,green));
 
 end;
 
end;

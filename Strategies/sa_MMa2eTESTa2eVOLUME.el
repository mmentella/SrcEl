var: vol(0),volup(0),voldw(0);

if vol = 0 then begin
 vol   = Volume;
 volup = UpTicks;
 voldw = DownTicks;
end else begin
 
 if marketposition < 1 and c < o and volup > voldw then
  buy this bar c;
 
 if marketposition > -1 and c > o and voldw > volup then
  sell short this bar c;

end;

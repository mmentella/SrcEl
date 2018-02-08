if marketposition = 0 then begin
 if mod(t,2) = 1 then buy next bar at market
 else sellshort next bar at market;
end;

if barssinceentry > 0 then begin
 if marketposition = 1 then sell next bar at market;
 if marketposition = -1 then buytocover next bar at market;
end;

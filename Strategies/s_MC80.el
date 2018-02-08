input: gapLperc(0.2);
input: gapSperc(0.2);

var: gapL(true),patternL(true);
var: gapS(true),patternS(true);

var: lastbar(0);

if t = sessionendtime(0,1) then
 lastbar = currentbar; 

if d > d[1] then begin 
 gapL = c[1] < o and (o - c[1])/o >= 0.01*gapLperc;
 gapS = c[1] > o and (c[1] - o)/o >= 0.01*gapSperc;
 
 patternL = false;
 patternS = false;
end;

if currentbar = lastbar + 2 or currentbar = lastbar + 3 then begin 
 patternL = l < l[1] and l[1] < l[2]; 
 patternS = h > h[1] and h[1] > h[2];
end else begin
 patternL = false;
 patternS = false;
end;

if marketposition < 1 and gapL and patternL then begin
 buy("el") next bar h + 2*MinMove point stop;
 sell("xl.stp") next bar l stop;
end;

if marketposition > -1 and gapS and patternS then begin
 sell short("es") next bar l - 2*MinMove point stop;
 buy to cover("xs.stp") next bar h stop;
end;

if marketposition = 1 then
 sell("xl") this bar c;

if marketposition = -1 then
 buy to cover("xs") this bar c;

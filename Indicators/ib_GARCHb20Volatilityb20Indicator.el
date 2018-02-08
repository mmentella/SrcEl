{|||||||||||||||||||||||||||||||||||||||||||||||||||||
~ GARCH Volatility Indicator
~ EasyLanguage code for Omega TradeStation
~ whiteline Group Copyright (c) 2004
|||||||||||||||||||||||||||||||||||||||||||||||||||||}
Input:
    period(30);
var:
    d1(0.3),
    d2(0.3),
    d3(0.2),
    d4(0.1),
    d5(0.1),
    r1(0.3),
    r2(0.3),
    r3(0.2),
    r4(0.1),
    r5(0.1),
    ii(0),
    Base(0),
    Diff(0),
    AvgDiff(0),
    ARCH(0),
    GARCH(0);
Diff = log(c/c[1]);
AvgDiff = Average(Diff, period);
Base = 0;
for ii = 0 to period-1
begin
    Base = Base + 365*Square(Diff[ii] - AvgDiff)/period;
end;
ARCH = 0.5*Base + 0.5*365*(
    (Square(Diff[0])+Square(Diff[1]))*d1 +
    (Square(Diff[2])+Square(Diff[3]))*d2 +
    (Square(Diff[4])+Square(Diff[5]))*d3 +
    (Square(Diff[6])+Square(Diff[7]))*d4 +
    (Square(Diff[8])+Square(Diff[9]))*d5
    )/2;
GARCH = 0.4*ARCH + 0.6*(
    (GARCH[1]+GARCH[2])*r1 +
    (GARCH[3]+GARCH[4])*r2 +
    (GARCH[5]+GARCH[6])*r3 +
    (GARCH[7]+GARCH[8])*r4 +
    (GARCH[9]+GARCH[10])*r5
    )/2;
plot1(SquareRoot(GARCH), "GARCH Vola", red);

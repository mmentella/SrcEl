Inputs: f1(0.1),f2l(.2),f2s(.2),f3l(.3),f3s(.3),xdiv(2);

Vars: SetupS(0,Data2), SetupL(0,Data2), EnterL(0,Data2), EnterS(0,Data2), BreakL(0,Data2), BreakS(0,Data2);
Vars: DayLowest(0,Data2), DayHighest(0,Data2);

if barstatus(2) = 2 then begin
 DayHighest = High of Data2;
 DayLowest = Low of Data2;
 
 SetupS = DayHighest + f1 * ( Close of Data2 - DayLowest );
 SetupL = DayLowest - f1 * ( DayHighest - Close of Data2 );
 EnterL = ( ( 1 + f2s ) / 2 ) * ( DayLowest + Close of Data2 ) - f2s * DayHighest;
 EnterS = ( ( 1 + f2l ) / 2 ) * ( DayHighest + Close of Data2 ) - f2l * DayLowest;
 BreakL = SetupS + f3l * ( SetupS - SetupL );
 BreakS = SetupL - f3s * ( SetupS - SetupL );
end;

plot1(SetupL,"SetupL");
plot2(SetupS,"SetupS");
plot3(EnterL,"EnterL");
plot4(EnterS,"EnterS");
plot5(BreakL,"BreakL");
plot6(BreakS,"BreakS");

var: mySum(0),counter(0),myAverage(0);

mySum = 0.0;
For counter = 0    to        9 begin
   mySum = mySum + Close [counter];
end;



{
or
mySum = 0.0
For counter = 9   downto       0
      mySum = mySum + Close [counter];
end;
myAverage = mySum/10.0
}


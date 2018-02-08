DEFINEDLLFUNC: "MCDLL.dll", void, "Initialize";
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFLenL", double, double;
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFKL", double, double;
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFLenS", double, double;
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFKS", double, double;

DEFINEDLLFUNC: "kernel32.dll", int, "GetTickCount";

//vars: tstart(0),tstop(0);

once begin
 //tstart = GetTickCount;
 
 Initialize;
 
 //tstop = GetTickCount;
end;

plot1(GetRBFKS(l,TrueRange),"MCDLL");

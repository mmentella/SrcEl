DEFINEDLLFUNC: "MCDLL.dll", void, "Initialize";
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFLenL", double, double;
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFKL", double, double;
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFLenS", double, double;
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFKS", double, double;

vars: upk(0),lok(0);
vars: rbfLenL(0),rbfKL(0),rbfLenS(0),rbfKS(0);

once begin
 Initialize;
end;

rbfLenL = maxlist(1,minlist(MaxBarsBack, IntPortion(GetRBFLenL(h,truerange) + 0.5)));
rbfKL   = GetRBFKL(h,truerange);
rbfLenS = maxlist(1,minlist(MaxBarsBack, IntPortion(GetRBFLenS(l,truerange) + 0.5)));
rbfKS   = GetRBFKS(l,truerange);

upk = KeltnerChannel(h,rbfLenL,rbfKL);
lok = KeltnerChannel(l,rbfLenS,-rbfKS);

plot1[-1](upk,"UPK");
plot2[-1](lok,"LOK");

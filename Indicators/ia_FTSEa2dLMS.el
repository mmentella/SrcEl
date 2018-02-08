Inputs: LenL(3),PreL(2),LenS(11),PreS(2);

Vars: LSSigH(0),LSSigL(0);

LSSigH = lms(High,LenL,PreL,.25);
LSSigL = lms(Low,LenS,PreS,.25);

plot1(LSSigH,"LMS High");
plot2(LSSigL,"LMS Low");

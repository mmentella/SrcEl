[IntrabarOrderGeneration = true]
Inputs: alpha(0.07),alpml(0.10),alpdl(0.05),alpms(0.10),alpds(0.05);

vars: skewl(0),skews(0),trnd(0),trgr(0);
{***************************}
{***************************}
if barstatus(1) = 2 then begin
 MM.ITrend(c,alpha,trnd,trgr);
 
 skewl = MM.Skewness(c,alpml,alpdl);
 skews = MM.Skewness(c,alpms,alpds);
{***************************}
{***************************}
 if trgr > trnd and skewl < 0 then
  buy this bar c;
 
 if trgr < trnd and skews > 0 then
  sell short this bar c;
end;
{***************************}
{***************************}
MM.SendControlMessage("forex");;

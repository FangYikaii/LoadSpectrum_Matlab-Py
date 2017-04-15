
function Z=getconstraints(fnonlin,u)
% 罚常数 >> 1
PEN=10^15;
lam=PEN; lameq=PEN;

Z=0;
% 非线性约束
[g,geq]=fnonlin(u);

%通过不等式约束建立罚函数
for k=1:length(g),
    Z=Z+ lam*g(k)^2*getH(g(k));
end
% 等式条件约束
for k=1:length(geq),
   Z=Z+lameq*geq(k)^2*geteqH(geq(k));
end

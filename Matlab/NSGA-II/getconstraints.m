
function Z=getconstraints(fnonlin,u)
% ������ >> 1
PEN=10^15;
lam=PEN; lameq=PEN;

Z=0;
% ������Լ��
[g,geq]=fnonlin(u);

%ͨ������ʽԼ������������
for k=1:length(g),
    Z=Z+ lam*g(k)^2*getH(g(k));
end
% ��ʽ����Լ��
for k=1:length(geq),
   Z=Z+lameq*geq(k)^2*geteqH(geq(k));
end

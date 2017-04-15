% P=intp(X1,Y1,X2,Y2)
% 求两组离散点序列的交点
% X1,Y1为第一组的横纵坐标，X2,Y2为第二组横纵坐标，横坐标必须为有序数列。
% 返回值P为交点坐标，两列矩阵，第一列为横坐标，第二列为纵坐标。
function P=intp(X1,Y1,X2,Y2)
X1=X1(:);    % 变为列向量
X2=X2(:);
Y1=Y1(:);
Y2=Y2(:);
if max(X1)<min(X2) || max(X2)<min(X1)
    P=[];       % 两个区间没有重叠，不可能有交点
    return;
end
a=max(min(X1),min(X2));
b=min(max(X1),max(X2));
a1=find(X1>=a); a1=a1(1);
a2=find(X2>=a); a2=a2(1);
b1=find(X1<=b); b1=b1(end);
b2=find(X2<=b); b2=b2(end);
x=unique([X1(a1:b1); X2(a2:b2)]);
y1=interp1(X1,Y1,x,'linear');
y2=interp1(X2,Y2,x,'linear');    % 找出公共部分
d=y1-y2;
ind0=find(d==0);    % 差为0的是交点。
P1=[x(ind0), y1(ind0)];
d1=sign(d);         % 求符号，负数为-1，正数为1, 0为0
d2=abs(diff(d1));
ind1=find(d2==2);   % 相邻符号相差2的，交点在此区间内
P2=zeros(length(ind1),2);
for k=1:length(ind1)
    i1=ind1(k);
    i2=ind1(k)+1;
    x1=x(i1);
    x2=x(i2);
    ya1=y1(i1);
    ya2=y1(i2);
    yb1=y2(i1);
    yb2=y2(i2);   % 两条线段四个端点坐标
    A=[ ya1-ya2, -(x1-x2)
        yb1-yb2, -(x1-x2)];  % 二元一次方程组系数矩阵
    B=[ (ya1-ya2)*x1-(x1-x2)*ya1
        (yb1-yb2)*x1-(x1-x2)*yb1];   % 常数项矩阵
    P2(k,:)=(A\B)';     % 解方程组，得到交点坐标
end
P=[P1;P2];            % 两种情况的交点合并
P=sortrows(P,1);      % 按横坐标排序
% 函数到此结束，保存到intp.m文件中
%  
%  
% % 下面是接你的主程序来的,就是添在你画图那段程序后面
% XA=AAAA;
% YA=normpdf(AAAA,AA,AAA);
% XB=BBBB;
% YB=normpdf(BBBB,BB,BBB);
% XC=CCCC;
% YC=normpdf(CCCC,CC,CCC);
% P1=intp(XA,YA,XB,YB);     % A,B交点，调用上面保存的那个intp函数
% P2=intp(XB,YB,XC,YC);     % B,C交点
% P3=intp(XC,YC,XA,YA);     % C,A交点
% P=[P1;P2;P3];
% % plot(XA,YA,XB,YB,XC,YC)
% hold on
% plot(P(:,1),P(:,2),'ro')
% hold off
% str=cell(size(P,1),1);
% for k=1:size(P,1)
%     str{k}=sprintf(' (%2.2g,%2.2g)',P(k,1),P(k,2));
% end
% text(P(:,1),P(:,2),str)
% % 主程序到此结束 
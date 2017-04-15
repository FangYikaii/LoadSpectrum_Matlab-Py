% P=intp(X1,Y1,X2,Y2)
% ��������ɢ�����еĽ���
% X1,Y1Ϊ��һ��ĺ������꣬X2,Y2Ϊ�ڶ���������꣬���������Ϊ�������С�
% ����ֵPΪ�������꣬���о��󣬵�һ��Ϊ�����꣬�ڶ���Ϊ�����ꡣ
function P=intp(X1,Y1,X2,Y2)
X1=X1(:);    % ��Ϊ������
X2=X2(:);
Y1=Y1(:);
Y2=Y2(:);
if max(X1)<min(X2) || max(X2)<min(X1)
    P=[];       % ��������û���ص����������н���
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
y2=interp1(X2,Y2,x,'linear');    % �ҳ���������
d=y1-y2;
ind0=find(d==0);    % ��Ϊ0���ǽ��㡣
P1=[x(ind0), y1(ind0)];
d1=sign(d);         % ����ţ�����Ϊ-1������Ϊ1, 0Ϊ0
d2=abs(diff(d1));
ind1=find(d2==2);   % ���ڷ������2�ģ������ڴ�������
P2=zeros(length(ind1),2);
for k=1:length(ind1)
    i1=ind1(k);
    i2=ind1(k)+1;
    x1=x(i1);
    x2=x(i2);
    ya1=y1(i1);
    ya2=y1(i2);
    yb1=y2(i1);
    yb2=y2(i2);   % �����߶��ĸ��˵�����
    A=[ ya1-ya2, -(x1-x2)
        yb1-yb2, -(x1-x2)];  % ��Ԫһ�η�����ϵ������
    B=[ (ya1-ya2)*x1-(x1-x2)*ya1
        (yb1-yb2)*x1-(x1-x2)*yb1];   % ���������
    P2(k,:)=(A\B)';     % �ⷽ���飬�õ���������
end
P=[P1;P2];            % ��������Ľ���ϲ�
P=sortrows(P,1);      % ������������
% �������˽��������浽intp.m�ļ���
%  
%  
% % �����ǽ��������������,���������㻭ͼ�Ƕγ������
% XA=AAAA;
% YA=normpdf(AAAA,AA,AAA);
% XB=BBBB;
% YB=normpdf(BBBB,BB,BBB);
% XC=CCCC;
% YC=normpdf(CCCC,CC,CCC);
% P1=intp(XA,YA,XB,YB);     % A,B���㣬�������汣����Ǹ�intp����
% P2=intp(XB,YB,XC,YC);     % B,C����
% P3=intp(XC,YC,XA,YA);     % C,A����
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
% % �����򵽴˽��� 
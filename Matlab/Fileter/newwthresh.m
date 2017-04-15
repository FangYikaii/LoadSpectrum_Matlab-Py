function y=newwthresh(x,sorh,t)
switch sorh
    %软阀值函数
    case 's'
        tmp=(abs(x)-t);
        tmp=(tmp+abs(tmp))/2;
        y=sign(x).*tmp;
    %硬阀值函数
    case 'h'
        y=x.*(abs(x)>t);
    %新阀值函数
    case 'newthr'
        a=0.2;
        n=4;
        alpha=1+exp(abs(x./t).^n-1);
        tmp=abs(x)-t./alpha;
        y=x.*(1-a)+a.*sign(x).*tmp.*(abs(x)>=t);
    otherwise
        error('Invalid argument value.');
end
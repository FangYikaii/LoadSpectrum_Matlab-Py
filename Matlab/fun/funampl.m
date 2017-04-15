function y=funampl(xz,cd,yz,x)
    y=(xz/cd)*((x-yz)/cd)^(xz-1)*exp(-((x-yz)/cd)^xz);
end
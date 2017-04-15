function y=funmean(u,sgm,x)
    y=(1/(sqrt(2*pi)*sgm))*exp(-(x-u).^2/(2*sgm.^2));
end
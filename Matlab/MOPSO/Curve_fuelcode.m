function z=Curve_fuelcode(x,y)
    b=[344.339594676198;3.97621139009381e-05;-0.108392070032490;0.000120023339415041;-0.153674380752910;-2.50269179523567e-05];
    z = b(1)+ b(2)*x.*x+b(3)*x + b(4)*y.*y + b(5)*y + b(6)*x.*y;
end
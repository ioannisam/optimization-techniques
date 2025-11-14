f1 = @(x) 5*x + (2 - cos(x)).^2;
f2 = @(x) (x - 1).^2 + exp(x) - 5*sin(x+3);
f3 = @(x) exp(-3*x) - (sin(x-2)-2).^2;

df1 = @(x) 5 + 2*(2 - cos(x)).*sin(x);
df2 = @(x) 2*(x-1) + exp(x) - 5*cos(x+3);
df3 = @(x) -3*exp(-3*x) - 2*(sin(x-2)-2).*cos(x-2);

funcs = {f1, f2, f3};
dfuncs = {df1, df2, df3};
fnames = {'f1','f2','f3'};

a0 = -1; b0 = 3;
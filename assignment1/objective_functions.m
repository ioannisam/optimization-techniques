syms x

f1_sym = 5^x + (2-cos(x))^2;
f2_sym = (x-1)^2 + exp(x-5)*sin(x+3);
f3_sym = exp(-3*x) - (sin(x-2)-2)^2;

df1_sym = diff(f1_sym, x);
df2_sym = diff(f2_sym, x);
df3_sym = diff(f3_sym, x);

f1 = matlabFunction(f1_sym);
f2 = matlabFunction(f2_sym);
f3 = matlabFunction(f3_sym);

df1 = matlabFunction(df1_sym);
df2 = matlabFunction(df2_sym);
df3 = matlabFunction(df3_sym);

funcs = {f1, f2, f3};
dfuncs = {df1, df2, df3};
fnames = {'f1','f2','f3'};

a0 = -1; b0 = 3;
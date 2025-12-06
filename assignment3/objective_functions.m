syms x1 x2

f_sym  = (1/3)*x1^2 + 3*x2^2;
gf_sym = gradient(f_sym, [x1, x2]);

f  = matlabFunction(f_sym,  'Vars', {x1, x2});
gf = matlabFunction(gf_sym, 'Vars', {x1, x2});

f_wr  = @(v) f(v(1), v(2));
gf_wr = @(v) reshape(gf(v(1), v(2)), [], 1);

P = @(v) [min(max(v(1), -10), 5); min(max(v(2), -8), 12)];

initial_points = {
    [5,  -5];
    [-5, 10];
    [8, -10];
};

e = 1e-3;
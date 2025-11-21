syms x y

f_sym  = x^3*exp(-x^2 - y^4);
gf_sym = gradient(f_sym, [x, y]);
hf_sym = hessian(f_sym, [x, y]);

f  = matlabFunction(f_sym,  'Vars', {x, y});
gf = matlabFunction(gf_sym, 'Vars', {x, y});
hf = matlabFunction(hf_sym, 'Vars', {x, y});

f_wr = @(v) f(v(1), v(2));
gf_wr = @(v) reshape(gf(v(1), v(2)), [], 1);
hf_wr = @(v) hf(v(1), v(2));

initial_points = {
    [ 0,  0];
    [-1, -1];
    [ 1,  1];
};
npoints = numel(initial_points);

methods = {'fixed','optimal','armijo'};
nmethods = numel(methods);

gamma_fixed = 0.1;
e = 1e-6;
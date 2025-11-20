syms x y

f_sym  = x^3*exp(-x^2 - y^4);
gf_sym = gradient(f_sym, [x, y]);
hf_sym = hessian(f_sym, [x, y]);

f  = matlabFunction(f_sym,  'Vars', {x, y});
gf = matlabFunction(gf_sym, 'Vars', {x, y});
hf = matlabFunction(hf_sym, 'Vars', {x, y});

initial_points = {
    [ 0,  0];
    [-1, -1];
    [ 1,  1];
};
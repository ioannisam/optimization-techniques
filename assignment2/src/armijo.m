function [gk, fevals, mk] = armijo(f, xk, dk, gfx, sigma, alpha, beta)

    if ~(isa(f,'function_handle'))
        error('Input f must be a function handle.');
    end

    xk = double(xk(:));
    dk = double(dk(:));
    gfx = double(gfx(:));
    n = numel(xk);
    if numel(dk) ~= n || numel(gfx) ~= n
        error('xk, dk, and gk must be vectors of the same length.');
    end

    if ~(isscalar(sigma) && sigma > 0)
        error('sigma must be a positive scalar.');
    end
    if ~(isscalar(alpha) && alpha > 0) % usually in [1e-5, 1e-1]
        error('alpha must be a positive scalar.');
    end
    if ~(isscalar(beta) && beta > 0 && beta < 1) % usually in [0.1, 0.5]
        error('beta must be in (0,1).');
    end

    mk = 0;
    fx = f(xk); fevals = 1;
    gprod = gfx'*dk;

    while true
        gk_candidate = sigma * beta^mk;
        f_trial = f(xk + gk_candidate*dk);
        fevals = fevals + 1;

        if f_trial <= fx + alpha*gk_candidate*gprod
            gk = gk_candidate;
            break;
        end

        mk = mk + 1;
        if mk > 2000
            warning('Maximum number of backtracks reached.');
            gk = gk_candidate;
            break;
        end
    end
end
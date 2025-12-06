function [xk, k, evals, history] = steepest_descend_projection(f, gf, P, x, sk, gamma_fixed, e)

    if ~(isa(f,'function_handle'))
        error('Input f must be a function handle.');
    end
    if ~(isa(gf,'function_handle'))
        error('Input gf must be a function handle.');
    end
    if ~(isa(P,'function_handle'))
        error('Input P must be a projection function handle.');
    end
    
    if ~(isscalar(sk) && sk > 0)
        error('Input sk must be a positive scalar.');
    end
    if ~(isscalar(gamma_fixed) && gamma_fixed > 0)
        error('Input gamma_fixed must be a positive scalar.');
    end
    if ~(isscalar(e) && e > 0)
        error('Input e must be a positive scalar.');
    end
    
    k = 1;
    evals.fevals = 0; % function evaluations
    evals.gevals = 0; % gradient evaluations

    xk = double(x(:));
    history.x = xk;
    fx = f(xk); evals.fevals = evals.fevals + 1;
    history.f = fx;
    history.gamma = [];

    gfx = gf(xk); evals.gevals = evals.gevals + 1;
    gfx = gfx(:);

    while true
        x_bar = P(xk - sk*gfx);
        dk = x_bar - xk;

        if norm(dk) < e
            break;
        end

        xk = xk + gamma_fixed*dk;
        k = k + 1;

        fx = f(xk); evals.fevals = evals.fevals + 1;
        history.x(:,end+1) = xk;
        history.f(end+1,1) = fx;

        gfx = gf(xk); evals.gevals = evals.gevals + 1;
        gfx = gfx(:);

        if k >= 1e6
            warning('Maximum number of iterations reached.');
            break;
        end
    end
end
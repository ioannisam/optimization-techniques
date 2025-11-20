function [xk, k, evals, history] = newton(f, gf, hess, x, gamma_fixed, e, method)

    if ~(isa(f,'function_handle'))
        error('Input f must be a function handle.');
    end
    if ~(isa(gf,'function_handle'))
        error('Input gf must be a function handle.');
    end
    if ~(isa(hess,'function_handle'))
        error('Input hess must be a function handle.');
    end

    if ~(isscalar(gamma_fixed) && gamma_fixed > 0)
        error('Input gamma_fixed must be a positive scalar.');
    end
    if ~(isscalar(e) && e > 0)
        error('Input e must be a positive scalar.');
    end

    valid_methods = {'fixed','optimal','armijo'};
    if ~ischar(method) || ~ismember(method, valid_methods)
        error('Input method must be one of: ''fixed'', ''optimal'', ''armijo''.');
    end
    
    k = 1;
    evals.fevals = 0; % function evaluations
    evals.gevals = 0; % gradient evaluations
    evals.sevals = 0; % search   evaluations

    xk = double(x(:));
    history.x = xk;
    fx = f(xk); evals.fevals = evals.fevals + 1;
    history.f = fx;
    history.gamma = [];

    grad = gf(xk); evals.gevals = evals.gevals + 1;
    grad = grad(:);

    while norm(grad) > e
        H = hess(xk);
        if ~all(eig(H) > 0)
            warning('Hessian is not positive definite. Ending execution.');
            break;
        end

        dk = -H \ grad;

        switch method
            case 'fixed'
                gk = gamma_fixed;
            case 'optimal'
                step_fun = @(g) f(xk + g*dk);
                [aK, bK, ~, evaluations, ~] = golden_section(step_fun, 0, 1, 0.01);
                gk = 0.5*(aK + bK);
                evals.sevals = evals.sevals + evaluations;
            case 'armijo'
                [gk, evaluations, ~] = armijo(f, xk, dk, grad, gamma_fixed, 0.01, 0.3);
                evals.sevals = evals.sevals + evaluations;
            otherwise
                error('Unknown method.');
        end

        xk = xk + gk*dk;
        k = k + 1;

        fx = f(xk); evals.fevals = evals.fevals + 1;
        history.x(:,end+1) = xk;
        history.f(end+1,1) = fx;
        history.gamma(end+1) = gk;

        grad = gf(xk); evals.gevals = evals.gevals + 1;
        grad = grad(:);

        if k >= 1e6
            warning('Maximum number of iterations reached.');
            break;
        end
    end
end
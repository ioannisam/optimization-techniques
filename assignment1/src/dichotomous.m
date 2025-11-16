function [aK,bK,k,fevals,history] = dichotomous(f,a,b,l,e)
   
    if ~(isa(f,'function_handle'))
        error('Input f must be a function handle.');
    end
    if ~(isscalar(a) && isscalar(b) && a < b)
        error('Inputs a,b must be scalars with a < b.');
    end
    if ~(isscalar(l) && l > 0 && isscalar(e) && e > 0)
        error('Inputs l and e must be positive scalars.');
    end

    k = 1;
    fevals = 0;
    history.a = a;
    history.b = b;

    while (b-a) > l
        m = (a+b) / 2;
        x1 = m - e;
        x2 = m + e;
        f1 = f(x1);
        f2 = f(x2);
        fevals = fevals + 2;

        if f1 < f2
            b = x2; % minimum in [a, x2]
        else
            a = x1; % minimum in [x1, b]
        end

        k = k + 1;
        history.a(end+1) = a;
        history.b(end+1) = b;

        if k > 1e6
            warning('Maximum number of iterations reached.');
            break;
        end
    end

    aK = a;
    bK = b;
end
function [aK,bK,k,fevals,history] = golden_section(f,a,b,l)

    if ~(isa(f,'function_handle'))
        error('Input f must be a function handle.');
    end
    if ~(isscalar(a) && isscalar(b) && a < b)
        error('Inputs a,b must be scalars with a < b.');
    end
    if ~(isscalar(l) && l > 0)
        error('Input l must be a positive scalar.');
    end

    gr = (sqrt(5)-1) / 2;
    x1 = b - gr*(b-a);
    x2 = a + gr*(b-a);
    f1 = f(x1);
    f2 = f(x2);

    k = 0;
    fevals = 2;
    history.a = a;
    history.b = b;

    while (b - a) > l
        if f1 < f2
            b = x2;
            x2 = x1;
            f2 = f1;
            x1 = b - gr*(b-a);
            f1 = f(x1);
        else
            a = x1;
            x1 = x2;
            f1 = f2;
            x2 = a + gr*(b-a);
            f2 = f(x2);
        end

        fevals = fevals + 1;  % one function eval per iteration
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
function [aK,bK,k,fevals,history] = fibonacci(f,a,b,l)

    if ~(isa(f,'function_handle'))
        error('Input f must be a function handle.');
    end
    if ~(isscalar(a) && isscalar(b) && a < b)
        error('Inputs a,b must be scalars with a < b.');
    end
    if ~(isscalar(l) && l > 0)
        error('Input l must be a positive scalar.');
    end

    F = [1, 1];  % fibonacci sequence
    n = 2;
    while F(n) < (b-a)/l
        F(n+1) = F(n) + F(n-1);
        n = n + 1;
    end

    x1 = a + (F(n-2)/F(n))*(b-a);
    x2 = a + (F(n-1)/F(n))*(b-a);
    f1 = f(x1);
    f2 = f(x2);

    k = 0;
    fevals = 2;
    history.a = a;
    history.b = b;

    for k = 1:(n-2) 
        if f1 < f2
            b = x2;
            x2 = x1;
            f2 = f1;
            x1 = a + (F(n-k-2)/F(n-k))*(b-a);
            f1 = f(x1);
        else
            a = x1;
            x1 = x2;
            f1 = f2;
            x2 = a + (F(n-k-1)/F(n-k))*(b-a);
            f2 = f(x2);
        end

        fevals = fevals + 1;

        history.a(end+1) = a;
        history.b(end+1) = b;
    end

    aK = a;
    bK = b;
end
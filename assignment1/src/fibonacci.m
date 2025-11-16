function [aK,bK,k,fevals,history] = fibonacci(f,a,b,l,e)

    if ~(isa(f,'function_handle'))
        error('Input f must be a function handle.');
    end
    if ~(isscalar(a) && isscalar(b) && a < b)
        error('Inputs a,b must be scalars with a < b.');
    end
    if ~(isscalar(l) && l > 0)
        error('Input l must be a positive scalar.');
    end

    F = [1 1];  % fibonacci sequence
    while F(end) < (b-a)/l
        F(end+1) = F(end) + F(end-1);
    end
    n = length(F);

    x1 = a + (F(n-2)/F(n))*(b-a);
    x2 = a + (F(n-1)/F(n))*(b-a);
    f1 = f(x1);
    f2 = f(x2);

    fevals = 2;
    history.a = a;
    history.b = b;

    for k = 1:(n-3) 
        if f1 > f2
            a = x1;
            x1 = x2;
            f1 = f2;
            x2 = a + (F(n-k-1)/F(n-k))*(b-a);
            f2 = f(x2); 
        else
            b = x2;
            x2 = x1;
            f2 = f1;  
            x1 = a + (F(n-k-2)/F(n-k))*(b-a);
            f1 = f(x1);        
        end

        fevals = fevals + 1;
        history.a(end+1) = a;
        history.b(end+1) = b;
    end

    x2 = x1 + e;
    f2 = f(x2);
    if f1 > f2
        aK = x1;
        bK = b;
    else
        aK = a;
        bK = x1;
    end
    
    history.a(end+1) = aK;
    history.b(end+1) = bK;
end
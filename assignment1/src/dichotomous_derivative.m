function [aK,bK,k,fevals,history] = dichotomous_derivative(df,a,b,l)

    if ~(isa(df,'function_handle'))
        error('Input df must be a function handle.');
    end
    if ~(isscalar(a) && isscalar(b) && a < b)
        error('Inputs a,b must be scalars with a < b.');
    end
    if ~(isscalar(l) && l > 0)
        error('Input l must be a positive scalar.');
    end

    n = ceil(log2((b-a) / l));
    fevals = 0;
    history.a = a;
    history.b = b;

    for k = 1:n
        x = (a+b) / 2;
        df_m = df(x);
        fevals = fevals + 1;

        if df_m > 0
            b = x; % minimum the left
        elseif df_m < 0
            a = x; % minimum the right
        else
            % exact minimum
            a = x;
            b = x;
            history.a(end+1) = a;
            history.b(end+1) = b;
            aK = a;
            bK = b;
            return;
        end

        history.a(end+1) = a;
        history.b(end+1) = b;
    end

    aK = a;
    bK = b;
end
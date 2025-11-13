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

    k = 0;
    fevals = 0;
    history.a = a;
    history.b = b;

    while (b-a) > l
        m = (a+b) / 2;
        df_m = df(m);
        fevals = fevals + 1;

        if df_m > 0
            b = m; % minimum the left
        elseif df_m < 0
            a = m; % minimum the right
        else
            % exact minimum
            a = m;
            b = m;
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
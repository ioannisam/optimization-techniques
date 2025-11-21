function [hfx_lm, mk] = cholesky(hfx, mk)

    n = size(hfx, 1);
    hfx = 0.5*(hfx + hfx.'); % ensure symmetry
    hfx_lm = hfx + mk*eye(n);

    while true
        [~, p] = chol(hfx_lm);
        if p == 0
            break;
        end
        mk = mk * 1.5;
        if mk > 1e20
            error('ensure_mk: mk grew too large');
        end
        hfx_lm = hfx + mk*eye(n);
    end
end
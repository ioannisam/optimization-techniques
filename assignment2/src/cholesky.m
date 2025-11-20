function [hfx_lm, mk] = ensure_mk(hfx, mk)

    n = numel(hfx);
    hfx = 0.5*(hfx + hfx.'); % ensure symmetry
    hfx_lm = hfx + mk*eye(n);

    while true
        [~, p] = chol(hfx_lm);
        if p == 0
            break;
        end
        mk = mk * 10;
        if mk > 1e20
            error('ensure_mk: mk grew too large');
        end
        hfx_lm = hfx + mk*eye(n);
    end
end
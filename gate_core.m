function [a1, b1, a2, b2, s0n, pn] = gate_core(D, Tp, td, s0, p)
    cu   = [0; D(1); D(3); D(3) + D(2)];
    u    = mod(cu*Tp/2, Tp);
    d    = mod((cu + 1)*Tp/2, Tp);
    NONE = 2*Tp;
    a1 = NONE*ones(8,1);   b1 = a1;   a2 = a1;   b2 = a1;
    s0n = false(4,1);   pn = zeros(4,1);
    for leg = 1:4
        E = zeros(1,3);   nE = 0;
        want = u(leg) > d(leg);
        if logical(s0(leg)) ~= want, nE = 1;   E(1) = 0; end
        tt = sort([u(leg), d(leg)]);
        for q = 1:2
            if nE > 0 && tt(q) == E(nE), nE = nE - 1;
            else, nE = nE + 1;   E(nE) = tt(q);
            end
        end
        hs = NaN(1,3);   he = NaN(1,3);   ls = NaN(1,3);   le = NaN(1,3);   nh = 0;   nl = 0;
        st = p(leg);   lv = logical(s0(leg));
        for i = 1:nE+1
            if i <= nE, en = E(i); else, en = Tp; end
            if lv, nh = nh + 1;   hs(nh) = st;   he(nh) = en;
            else,  nl = nl + 1;   ls(nl) = st;   le(nl) = en;
            end
            if i <= nE, st = E(i);   lv = ~lv; end
        end
        h = on_intervals(hs, he, td, Tp, NONE);
        l = on_intervals(ls, le, td, Tp, NONE);
        a1(2*leg-1) = h(1);  b1(2*leg-1) = h(2);  a2(2*leg-1) = h(3);  b2(2*leg-1) = h(4);
        a1(2*leg)   = l(1);  b1(2*leg)   = l(2);  a2(2*leg)   = l(3);  b2(2*leg)   = l(4);
        s0n(leg) = lv;
        if nE > 0, pn(leg) = E(nE) - Tp; else, pn(leg) = p(leg) - Tp; end
    end
end

function v = on_intervals(s, e, td, Tp, NONE)
    v = NONE*ones(1,4);   n = 0;
    for k = 1:3
        if ~isnan(s(k)) && n < 2
            x = s(k) + td;
            if max(0, x) < e(k)
                a = max(0, x);   b = e(k);
                if x <= 0,     a = -Tp;  end
                if e(k) == Tp, b = NONE; end
                v(2*n+1) = a;   v(2*n+2) = b;   n = n + 1;
            end
        end
    end
end

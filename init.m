f_sw = 20e3;
s_f  = 50e3/f_sw;
Tp   = 1/f_sw;

Tsolver = 20e-9;
TFIX    = 20e-9;
tdead   = 200e-9;

Ron      = 3.5e-3;
Rd_diode = 8e-3;
Vf_diode = 3.0;
Rs_snub  = 1e5;
Cs_snub  = inf;

Vi = 800;
Ri = 100e-3;
Ro = 100e-3;
Li = 10e-6*s_f;
Lo = 10e-6*s_f;
Ci = 30e-6*s_f;
Co = 44e-6*s_f;
ESR_Ci = 2e-3;
ESR_Co = 2e-3;

n  = 1.7;
Ls = 15e-6*s_f;
Rs = 25e-3;
TR_Pn = 30e3;
TR_fn = f_sw;
TR_Vb = 100;
TR_Rm = 1e6;
TR_Lm = 1;
TR_W1 = [n*TR_Vb, Rs, Ls];
TR_W2 = [TR_Vb, 0, 0];

D1_OL = 0.985714;
D2_OL = 1;
D3_OL = 0.045188;
V_BAT = 450;
Vo    = V_BAT;
I_OP  = 44.444;

T_STOP    = 15e-3;
T_AVG     = 3e-3;
TFIX_LIST = [20 50 100 200]*1e-9;

IL0_i = Vo*I_OP/Vi;  IL0_o = I_OP;
V_cap_init = Vi - Ri*IL0_i;
V_out_init = Vo + Ro*I_OP;

for h = TFIX_LIST
    if abs(Tp/h - round(Tp/h)) > 1e-6, error('TFIX = %g ns does not divide Tp', h*1e9); end
end
OP = struct('D1',D1_OL,'D2',D2_OL,'D3',D3_OL,'V_BAT',V_BAT,'T_STOP',T_STOP,'T_AVG',T_AVG,'Tp',Tp);
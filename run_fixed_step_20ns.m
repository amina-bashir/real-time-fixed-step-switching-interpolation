clear; clc; close all;
init;

MODEL = 'dab_openloop_variable_step';
load_system(MODEL);
pg = [MODEL '/powergui'];

h = 20e-9;
TFIX = h;
in = Simulink.SimulationInput(MODEL);
in = in.setBlockParameter(pg,'SimulationMode','Discrete', pg,'SampleTime','TFIX', pg,'AutomaticDiscreteSolvers','off', ...
                          pg,'SolverType','Tustin', pg,'Interpol','off', pg,'ExternalGateDelay','off');
in = in.setVariable('TFIX', h);
in = in.setModelParameter('SolverType','Fixed-step','Solver','FixedStepDiscrete','FixedStep','TFIX', ...
                          'StopTime',num2str(T_STOP,17));

fprintf('fixed step %.0f ns ... ', h*1e9);
t1 = tic;  out = sim(in);  trun = toc(t1);

tv = out.sim_vbus.Time;         vb = squeeze(out.sim_vbus.Data);
ti = out.sim_ibat.Time;         ib = squeeze(out.sim_ibat.Data);
tl = out.simout_analytic.Time;  il = squeeze(out.simout_analytic.Data);
if size(vb,1) ~= numel(tv), vb = vb.'; end

vs = interp1(tv, vb(:,2), ti);
pw = -vs.*ib;
tA = T_STOP - round(T_AVG/Tp)*Tp;
w  = ti >= tA - 1e-12;
dT = ti(find(w,1,'last')) - ti(find(w,1));
P  = trapz(ti(w), pw(w))/dT;
I  = -trapz(ti(w), ib(w))/dT;
k  = tl >= T_STOP - 2*Tp - 1e-12;

R = struct('kind','fixed_step','TFIX',h,'P',P,'I',I, ...
           't_ils',tl(k)-tl(find(k,1)),'ils',il(k),'trun',trun);
fprintf('P = %.1f W, I_bat = %.3f A (%.0f s)\n', P, I, trun);
fn = sprintf('result_fixed_step_%.0fns.mat', h*1e9);
save(fn, 'R', 'OP');
fprintf('saved %s\n', fn);

clear; clc; close all;
root = fileparts(mfilename('fullpath'));
fdir = fullfile(root, 'figures');
if ~isfolder(fdir), mkdir(fdir); end

V  = load('result_variable_step.mat');
H  = [20 100];
dc = @(R) trapz(R.t_ils, R.ils)/(R.t_ils(end) - R.t_ils(1));
c1 = [0.85 0.10 0.10];  c2 = [0 0.447 0.741];

fprintf('variable step: DC offset %+.4f A | peaks %+.2f / %+.2f A\n\n', dc(V.R), max(V.R.ils), min(V.R.ils));
fprintf('%6s | %-30s | %-30s\n', 'T_sim', 'fixed step', 'fixed step, interpolation');
fprintf('%6s | %10s %9s %9s | %10s %9s %9s\n', '', 'DC (A)', 'max (A)', 'min (A)', 'DC (A)', 'max (A)', 'min (A)');
fprintf('%s\n', repmat('-',1,72));

f  = figure('Color','w','Position',[100 100 760 480]);
ax = axes(f);  hold(ax,'on');  grid(ax,'on');
cf = {[0.93 0.55 0.15], [0.85 0.10 0.10]};
ci = {[0.30 0.75 0.93], [0 0.447 0.741]};
sf = {'--', '--'};  si = {'-.', ':'};
g  = plot(ax, V.R.t_ils*1e6, V.R.ils, 'k-', 'LineWidth', 1.8);
L  = {'variable step'};
for q = 1:2
    F  = load(sprintf('result_fixed_step_%dns.mat', H(q)));
    FI = load(sprintf('result_fixed_step_interpolation_%dns.mat', H(q)));
    fprintf('%3d ns | %+10.4f %+9.2f %+9.2f | %+10.4f %+9.2f %+9.2f\n', H(q), ...
            dc(F.R), max(F.R.ils), min(F.R.ils), dc(FI.R), max(FI.R.ils), min(FI.R.ils));
    g(end+1) = plot(ax, F.R.t_ils*1e6,  F.R.ils,  sf{q}, 'Color', cf{q}, 'LineWidth', 1.3);
    g(end+1) = plot(ax, FI.R.t_ils*1e6, FI.R.ils, si{q}, 'Color', ci{q}, 'LineWidth', 1.5);
    L(end+1:end+2) = {sprintf('fixed step %d ns', H(q)), sprintf('fixed step %d ns, interpolation', H(q))};
end
uistack(g(1), 'bottom');
xlabel(ax, 't (\mus)');  ylabel(ax, 'i_p (A)');
legend(ax, g, L, 'Location','northoutside', 'NumColumns', 2, 'FontName','Times New Roman', 'FontSize', 10);
set(ax, 'FontName','Times New Roman', 'FontSize', 11, 'Box','on', 'TickDir','in', ...
        'LineWidth', 0.75, 'XColor','k', 'YColor','k');
ax.Toolbar.Visible = 'off';  drawnow;
exportgraphics(f, fullfile(fdir, 'link_current.png'), 'Resolution', 300);
fprintf('\nsaved figures/link_current.png\n');
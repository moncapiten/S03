filename = 'data002.txt';
% data import and creation of variance array
rawData = readmatrix(strcat("../Data/", filename));

tt = rawData(:, 1);
vi = rawData(:, 2);
vo = rawData(:, 3);

% preparation of fitting function and p0 parameters
function y = funcSine(params, t)
    w = 2 * pi * params(2);
    y = params(1) * sin( w*t + params(3)) + params(4);

end

R1 = 1491.2;
R2 = 14947;
G = -R2/R1;

f0 = 1e3;
ai = 0.4;
ao = G * ai;
ph0 = 0;
oi = 0;
oo = G * oi;

p0i = [ ai, f0, ph0, oi];
p0o = [ ao, f0, ph0, oo];


% fit and k^2 calculation
[betai, Ri, ~, covbetai] = nlinfit(tt, vi, @funcSine, p0i);
[betao, Ro, ~, covbetao] = nlinfit(tt, vo, @funcSine, p0o);
betao



% plot seffing and execution
t = tiledlayout(2, 1);

% plot of the data, prefit and fit
ax1 = nexttile([1 1]);

plot(tt, vi, 'o', Color="#0072BD");
hold on
plot(tt, vi, 'o', Color="Red");

%plot(tt, funcSine(p0i, tt), '--', Color = 'cyan');
plot(tt, funcSine(p0o, tt), '--', Color = '#FFa500');

%plot(tt, funcSine(betai, tt), '-', Color = '#0047AB');
plot(tt, funcSine(betao, tt), '-', Color = 'Magenta');
hold off
grid on
grid minor


% residual plots for both fits
ax2 = nexttile;
plot(tt, repelem(0, length(tt)), '--', Color= 'black');
hold on
plot(tt, Ri, 'o', Color= '#0072BD');
%errorbar(ff, Ra, s_a, Color= '#0072BD');
%set(gca, 'XScale','log', 'YScale','lin')
hold off
grid on
grid minor


% plot seffings
title(t, 'Fit and residuals of Amplitude Fit');
t.TileSpacing = "tight";
linkaxes([ax1, ax2], 'x');


%xlabel(ax1, 'frequency [Hz]')
ylabel(ax1, 'Gain [pure]')
legend(ax1, 'data', 'model - p0', 'model - fitted', Location= 'ne')
dim = [.15 .6 .3 .3];
%str = ['$ k^2 $ = ' sprintf('%.2f', ka) ];
%annotation('textbox', dim, 'interpreter','latex','String',str,'FitBoxToText','on');


xlabel(ax2, 'frequency [Hz]');
ylabel(ax2, 'Amplitude - Residuals [V]');


% image saving
mediaposition = '../Media/';
medianame = 'Misura_CRRC';

%fig = gcf;
%orient(fig, 'landscape')
%print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf');

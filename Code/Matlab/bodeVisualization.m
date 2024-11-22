% data import
dataPosition = '../Data/';
filename = 'CRRCBufferOP77';

mediaposition = '../Media/';
medianame = 'CRRCBufferOP77';

rawData = readmatrix(strcat( dataPosition, filename, '.txt'));

ff = rawData(:, 1);
a = rawData(:, 2);
%s_a = repelem(5e-4, length(a));
ph = rawData(:, 4);


t = tiledlayout(2, 1);

% plot of the data, prefit and fit

ax1 = nexttile;
%errorbar(ff, a, s_a, 'o', Color= '#0072BD');
loglog(ff, a, 'o', Color= "#0027BD");
%hold on
%hold off
grid on
grid minor


% residual plots for both fits
ax2 = nexttile;
semilogx(ff, ph, 'o', Color= "#0027BD");
%hold on
%hold off
grid on
grid minor


% plot seffings
title(t, 'Amplitude and Phase of the CRRC filter with buffer - OP77');
t.TileSpacing = "tight";
linkaxes([ax1, ax2], 'x');

title(ax1, 'Gain')
ylabel(ax1, 'Gain [pure]')
legend(ax1, 'data', Location= 'ne')
ylim(ax1, [0.1 1.1])

title(ax2, 'Phase')
xlabel(ax2, 'frequency [Hz]')
ylabel(ax2, 'Phase, [radians]')
%yticks(ax2, [-pi/4, -pi/2, 0])
%yticklabels(ax2, ['-pi/4', '-pi/2', '0'])
ylim(ax2, [-2/3*pi 2/3*pi])

yticks(ax2, [-pi/2 -pi/4 0 pi/4, pi/2])
yticklabels(ax2, {'-\pi/2', '-\pi/4', '0', '\pi/4', '\pi/2'})
legend(ax2, 'data', Location= 'ne')


%dim = [.15 .6 .3 .3];
%str = ['$ k^2 $ = ' sprintf('%.2f', ka) ];
%annotation('textbox', dim, 'interpreter','latex','String',str,'FitBoxToText','on');


% image saving


fig = gcf;
orient(fig, 'landscape')
print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf');

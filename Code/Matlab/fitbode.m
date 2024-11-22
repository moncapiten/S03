% data import and creation of variance array
rawData = readmatrix("../Data/CRRCBufferOP77.txt");

ff = rawData(:, 1);
a = rawData(:, 2);
s_a = repelem(3.5e-2, length(a));
ph = rawData(:, 4);

% preparation of fitting function and p0 parameters
function y = tf1(params, f)

    w = 2*pi.*f;
    y = 1i*w*params(1) ./ ( (1+1i*w*params(2)) .* (1+1i*w*params(3)) );

end

function y = ampl1(params, f)
    
    y = abs(tf1(params, f));

end


function y = lpf(params, f)
    
    w = 2 * pi .* f;
    y =  1 ./ (1+1i*w*params(1)) ;

end

function y = alpf(params, f)

    y = abs( lpf(params(1), f) );

end


function y = hpf(params, f)

    w = 2 * pi .* f;
    y =  1i * w * params(1) ./ ( 1 + 1i * w * params(1) ) ;

end

function y = bpf(params, f)
    
    y = abs( hpf(params(1), f) .* lpf(params(2), f) );

end




tlpf = 1e3;
p0lpf = [1/tlpf];




R1 = 100.28 * 1e3;
R2 = 995.9;
C1 = 109.9 * 1e-9;
C2 = 54.03 * 1e-9;

t1 = R1*C1;
t2 = R2*C2;

A = t1+t2+R1*C2;

tb = 0.5 * ( A + sqrt( A^2 - 4*t1*t2) );
ta = t1*t2/tb;

p0a = [t1, ta, tb];
p0b = [t1, t2];

% fit and k^2 calculation
[betaa, Ra, ~, covbetaa] = nlinfit(ff, a, @ampl1, p0a);
[betab, Rb, ~, covbetab] = nlinfit(ff, a, @bpf, p0b);
%[betalpf, Rlpf, ~, covbetalpf] = nlinfit(ff, a, @alpf, p0lpf);


betaa
covbetaa

betab
covbetab



ka = 0;
for i = 1:length(Ra)
    ka = ka + Ra(i)^2/s_a(i)^2;
end
ka = ka/(length(ff)-3);
ka

kb = 0;
for i = 1:length(Rb)
    kb = kb + Rb(i)^2/s_a(i)^2;
end
kb = kb/(length(ff)-2);
kb

%klpf = 0;
%for i = 1:length(Rlpf)
%    klpf = klpf + Rlpf(i)^2/s_a(i)^2;
%end
%klpf = klpf/(length(ff)-1);
%klpf

% plot seffing and execution
t = tiledlayout(2, 1);

% plot of the data, prefit and fit
ax1 = nexttile([1 1]);

errorbar(ff, a, s_a, 'o', Color= 'black');
set(gca, 'XScale','log', 'YScale','log')
hold on
loglog(ff, ampl1(p0a, ff), '--', Color= 'magenta');
loglog(ff, ampl1(betaa, ff), '-', Color= 'red');

%loglog(ff, lpf(p0lpf, ff), '--', Color= 'red');
%loglog(ff, lpf(betalpf, ff), '-', Color= 'green');

loglog(ff, bpf(p0b, ff), '--', Color= 'cyan');
loglog(ff, bpf(betab, ff), '-', Color= '#0027BD');
hold off
grid on
grid minor


% residual plots for both fits
ax2 = nexttile;
plot(ff, repelem(0, 100), '--', Color= 'black');
hold on
errorbar(ff, Ra, s_a, Color= 'red');
errorbar(ff, Rb, s_a, Color= '#0072BD');
%errorbar(ff, Rlpf, s_a, Color= 'green');
set(gca, 'XScale','log', 'YScale','lin')
hold off
grid on
grid minor


% plot seffings
title(t, 'Fit and residuals of Gain Fit - AD8031');
t.TileSpacing = "tight";
linkaxes([ax1, ax2], 'x');


%xlabel(ax1, 'frequency [Hz]')
ylabel(ax1, 'Gain [pure]')
legend(ax1, 'data', 'model - p0', 'model - fitted', Location= 'sw')
dim = [.15 .6 .3 .3];
str = ['$ k^2 $ = ' sprintf('%.2f', ka) ];
annotation('textbox', dim, 'interpreter','latex','String',str,'FitBoxToText','on');


xlabel(ax2, 'frequency [Hz]');
ylabel(ax2, 'Gain - Residuals [Pure]');

%betalpf


% image saving
mediaposition = '../Media/';
medianame = 'bodeFitCRRCAD8031';

%fig = gcf;
%orient(fig, 'landscape')
%print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf');



fclb = 1/(2*pi*betab(1))
fchb = 1/(2*pi*betab(2))

fcla = 1/(2*pi*betaa(1))
t2_ = betaa(2)*betaa(3)/betaa(1);%ta*tb/t1
fcha = 1/(2*pi*t2_)




R1*C1
R2*C2

betab(1)
betab(2)

betaa(1)
t2_




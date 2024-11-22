dataPosition = '../Data/';
filename = 'data006';

mediaposition = '../Media/';
medianame = strcat('plot', filename);

flagSave = true;
flagFit = false;
% data import and creation of variance array
rawData = readmatrix(strcat(dataPosition, filename, '.txt'));

tt = rawData(:, 1);
vi = rawData(:, 2);
s_i = repelem(1.2e-3, length(tt));
vo = rawData(:, 3);
s_o = repelem(2e-3, length(tt));

% preparation of fitting function and p0 parameters
function y = funcSine(params, t)
    w = 2 * pi * params(2);
    y = params(1) * sin( w*t + params(3)) + params(4);

end

R1 = 1491.2;
R2 = 14947;
G = 1+R2/R1;

f0 = 1e3;
ai = 0.1;
ao = G * ai;
ph0 = pi;
oi = 0;
oo = G * oi;


p0i = [ ai, f0, ph0, oi];
p0o = [ ao, f0, ph0, oo];


% fit and k^2 calculation
[betai, Ri, ~, covbetai] = nlinfit(tt, vi, @funcSine, p0i);
[betao, Ro, ~, covbetao] = nlinfit(tt, vo, @funcSine, p0o);


ki = 0;
for i = 1:length(Ri)
    ki = ki + Ri(i)^2/s_i(i)^2;
end
ki = ki/(length(tt)-4);

ko = 0;
for i = 1:length(Ro)
    ko = ko + Ro(i)^2/s_o(i)^2;
end
ko = ko/(length(tt)-4);


ki
ko

if flagFit
    
else
    errorbar(tt, vi, s_i, 'o', Color= "#0027BD");
    hold on
    errorbar(tt, vo, s_o, 'o', Color= "Red");
    grid on
    grid minor
    

    title(strcat('Data plot - ', filename))
    xlabel('time [s]');
    ylabel('Amplitude [V]')
    legend('data - in', 'data - out');
    hold off



end

% image saving
if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end


betai
betao




betao(1)
sqrt(covbetao(1))
betai(1)
sqrt(covbetai(1))
%sqrt(covbetao(1))/sqrt(covbetai(1))



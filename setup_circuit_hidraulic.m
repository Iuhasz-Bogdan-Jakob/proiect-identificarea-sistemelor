%%
% Nume si prenume: Iuhasz Bogdan
%

clearvars
clc

%% Magic numbers (replace with received numbers)
m = 5; 
n = 6; 

%% Process data (fixed, do not modify)
c1 = (1000+n*300)/10000;
c2 = (1.15+2*(m+n/10)/20);
a1 = 2*c2*c1;
a2 = c1;
b0 = (1.2+m+n)/5.5;

rng(m+10*n)
x0_slx = [2*(m/2+rand(1)*m/5); m*(n/20+rand(1)*n/100)];

%% Experiment setup (fixed, do not modify)
Ts = 10*c2/c1/1e4*1.5; % fundamental step size
Tfin = 30*c2/c1;

gain = 10;
umin = 0; umax = gain; % input saturation
ymin = 0; ymax = b0*gain/1.5; % output saturation

whtn_pow_in = 1e-6*5*(((m-1)*8+n/2)/5)/2*6/8; % input white noise power and sampling time
whtn_Ts_in = Ts*3;
whtn_seed_in = 23341+m+2*n;
q_in = (umax-umin)/pow2(10); % input quantizer (DAC)

whtn_pow_out = 1e-5*5*(((m-1)*25+n/2)/5)*6/80*(0.5+0.3*(m-2)); % output white noise power and sampling time
whtn_Ts_out = Ts*5;
whtn_seed_out = 23342-m-2*n;
q_out = (ymax-ymin)/pow2(9); % output quantizer (ADC)

u_op_region = (m/2+n/5)/2; % operating point

%% Input setup (can be changed/replaced/deleted)
u0 = 0;        % fixed
ust = 4;    %4 % must be modified (saturation)
t1 = 10*c2/c1; % recommended 

%% Data acquisition (use t, u, y to perform system identification)
out = sim("circuit_hidraulic_R2022b_P1.slx");

t = out.tout;
u = out.u;
y = out.y;

plot(t,u,t,y)
shg

%% System identification
i1 = 6296;
i2 = 6655;
i3 = 12386;
i4 = 12996;

u0 = mean(u(i1:i2));
ust = mean(u(i3:i4));
y0 = mean(y(i1:i2));
yst = mean(y(i3:i4));

%K = (yst-y0) / (ust-u0);
K = 2.235

%% T1 (dominanta)
i5 = 6851; % se alege punct de la inceputu treptei (unde se declanseaza treapta, pe iesire aprox de unde incepe sa urce)
i6 = 9290; % asta trebe putin modificat (se alege punct din spre final, in zona dinainte de stabilizare, dar mai jos)

t_reg = t(i5:i6);
y_reg = log(yst-y(i5:i6));

figure
plot(t_reg,y_reg)
ylabel('log(yst-y(t)')

Areg = [sum(t_reg.^2),sum(t_reg);
    sum(t_reg),length(t_reg)];
breg = [sum(y_reg.*t_reg); sum(y_reg)];
theta = inv(Areg)*breg

T1 = -1/theta(1)

%%
i7 = 6667; %se alege punct fix din u(t0) adica de unde porneste treapta in momentu 0 
i8 = 7130; %se alege punct unde e punctul de inflexiune
Ti = t(i8) - t(i7)

T2vec = 0.1:0.1:10.5;
Y_ecuatie = T1*T2vec.*log(T2vec) - T2vec*(Ti+T1*log(T1)) + T1*Ti;

figure
plot(T2vec,Y_ecuatie)
grid on

T2 = 2.07 %e ales de pe acea curba cand valoarea in acel timp este 0 (adica pentru acel T2 ecuatia este = 0)

%% Validare
H = tf(K,[T1*T2,T1+T2,1]);

ysim = lsim(H,u,t);

figure
plot(t,u,t,y,t,ysim)

J1 = 1/sqrt(length(t))*norm(y-ysim)
eMPN1 = norm(y-ysim)/norm(y-mean(y))*100;

A = [0,1;-1/T1/T2,-(1/T1+1/T2)];
B = [0;K/T1/T2];
C = [1,0];
D = 0;

sys = ss(A,B,C,D);
ysim2 = lsim(sys,u,t,[y(1),1.95])

figure
plot(t,u,t,y,t,ysim2) 

J = 1/sqrt(length(t))*norm(y-ysim2)
eMPN = norm(y-ysim2)/norm(y-mean(y))*100;
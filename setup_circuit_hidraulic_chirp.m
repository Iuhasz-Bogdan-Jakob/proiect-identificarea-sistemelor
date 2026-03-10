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
Tfin = 30*c2/c1*10; % simulation duration

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
wf = 1/10.9; %1/(~constanta de timp dominanta); usor de preluat
fmin = wf/2/pi/10;
fmax = wf/2/pi*10;
Ain = 1.6;

%% Data acquisition (use t, u, y to perform system identification)
out = sim("circuit_hidraulic_R2022b.slx");

t = out.tout;
u = out.u;
y = out.y;

plot(t,u,t,y)
shg

%% System identification
yst = (4.41+3.78)/2
ust = 1.85; %u_op_region
K = yst/ust;

w1 = pi/(671.325-661.99);
DeltaT1 = 666.891 - 661.99;
% sin(w*t+phi)
phi1 = -rad2deg(w1*DeltaT1);

w2 = pi/(452.906 - 439.494);
DeltaT2 = 445.989 - 439.494;
phi2 = -rad2deg(w2*DeltaT2);

w3 = pi/(527.813 - 515.812);
DeltaT3 = 521.877 - 515.812;
phi3 = -rad2deg(w3*DeltaT3);%cel mai aproape de -90 grade

Ay = (5.19 - 2.97)/2;
Au = 1.6; % data la intrare din proiectare Ain
Im = -Ay/Au;

wn = w3;
zeta = -K/2/Im; %zeta trebuie sa fie peste 1 dar nu prea aproape de 1

%% Validare 
H = tf(K*wn^2,[1,2*zeta*wn,wn^2]);
zpk(H)

T1 = 1/0.09223;
T2 = 1/0.743;

ysim1 = lsim(H,u,t);

A = [0,1;-1/T1/T2,-(1/T1+1/T2)];
B = [0;K/T1/T2];
C = [1,0];
D = 0;

sys = ss(A,B,C,D);
ysim2 = lsim(sys,u,t,[y(1),2.9]);

figure
plot(t,u,t,y,t,ysim1)
figure
plot(t,u,t,y,t,ysim2) 


J1 = 1/sqrt(length(t))*norm(y-ysim1);
eMPN1 = norm(y-ysim1)/norm(y-mean(y))*100;

J2 = 1/sqrt(length(t))*norm(y-ysim2);
eMPN2 = norm(y-ysim2)/norm(y-mean(y))*100;

nyquist(H)

%parameters NLMS filter
N_q = 4;
L_QAM = 100;
u = 1; % stepsize of filter
delta = 0.5; %Deviation of initial value of W_k

%DDequalization
DDequalization

pause on;
pause;

%% Transmit pic test 1
%transmit pic parameters
N = 512;
N_q = 4;
Lt = 20;
L = ceil(N/2);
BWusage = 100;

transmit_pic

pause;

%% Transmit pic test 2
%transmit pic parameters
N = 512;
N_q = 4;
Lt = 20;
L = ceil(N/2);
BWusage = 50;

transmit_pic
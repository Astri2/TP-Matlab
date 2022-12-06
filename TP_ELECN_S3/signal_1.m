%   SIG - Initiation Traitement Signal - TP1    %
clear all;  % efface toutes les variables déjÃ  créées 
close all;  % ferme toutes les figures
clc;        % efface l'historique des commandes

% A executer une fois dans la fenetre de commandes si sur Octave
% pkg load signal;

%% Partie 1 : Convolution et Transformee de Fourier

%% 1/
% Initialisation
fe = 1024;                            % Frequence d'echantillonage en Hz
te = 1/fe;                            % Periode d'echantillonage en s
D = 1;                                % Durée du signal en s
t = -D/2 : te : (D/2)-te;             % Creation de l'axe temporel
T = 25;                               % Largeur de la porte en nb d'echantillons

% Création du signal s
s = ones(size(t));
s(t > (T/fe)) = 0;
s(t < -(T/fe)) = 0;

% Affichage du signal
figure(1);
plot(t, s);
ylim([0 2])
title('Signal s');
xlabel('temps (s)');
ylabel('amplitude');

%% 2/
f = -fe/2 : fe/length(s) : fe/2 - fe/length(s); % Creation de l'axe des frequences
S = fft(s);                                     % TF du signal s

% Affichage
figure(2);
subplot(2, 1, 1); plot(f, abs(S));
xlabel('fréquences (Hz)');
ylabel('spectre de s');
title('Module et phase de la TF de s');
subplot(2, 1, 2); plot(f, angle(S));
xlabel('fréquences (Hz)');
ylabel('phase');

%% 3/
Y = fftshift(S);    % Permutation a l'aide de fftshift
figure(3);
subplot(2, 1, 1); plot(f, abs(Y));
xlabel('fréquences (Hz)');
ylabel('spectre de y');
title('Module et phase de Y');
subplot(2, 1, 2); plot(f, angle(Y));
xlabel('fréquences (Hz)');
ylabel('phase');

%% 4/
y_prime = ifft(Y);  % ITF de Y, Y etant fftshift(S)
s_prime = ifft(S);  % ITF de S
figure(4);
subplot(1, 2, 1); plot(t , y_prime);
ylim([-2 2]);
xlabel('temps (s)');
ylabel('amplitude');
title('Signal y_{prime}');
subplot(1, 2, 2); plot(t, s_prime);
ylim([-2 2]);
xlabel('temps (s)');
ylabel('amplitude');
title('Signal s_{prime}');

%% 5/
x = conv(s, s, 'same'); % Produit de convolution, l'argument 'same' permet 
                        % de retourner la convolution sur le meme nombre de 
                        % points que le signal de depart.
figure(5);
plot(t, x);
xlabel('temps (s)');
ylabel('amplitude');
title('Signal x');

%% 6/
X = fft(x);         % TF de x
S_carre = S.*S;     % Elevation au carre de S

figure(6);
plot(f, fftshift(X)); hold on; % affiche abs(X) pour avoir une superposition des courbes
plot(f, fftshift(S_carre), '--');
xlabel('fréquences (Hz)');
ylabel('spectres de X et S_{carre}');
legend('X','S\_carre')
title('Signaux X et S_{carre}');

%% Partie 2 : TF d'un signal carre

%% 1/
% Initialisation
fe = 1000;                      % Fréquence d'echantillonage en Hz
F = 100;                        % Fréquence du signal en Hz
te = 1/fe;                      % Periode d'echantillonage en s
N = 10;                         % Nombre de périodes
D = N/F;                        % Duree du signal en s
t = 0 : te : D-te;              % Creation de l'axe temporel

s = square(2*pi*F*t);
figure(7);
plot(t, s);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal carre s');

%% 2/
nb_points_fft = 2^10;                                    % Nombre de points de la FFT
f = -fe/2 : fe/nb_points_fft : fe/2 - fe/nb_points_fft;  % creation du vecteur frequentiel associe

S = fft(s, nb_points_fft);  % FFT de s
figure(8);
plot(f, fftshift(abs(S)));
xlabel('fréquences (Hz)');
ylabel('spectre de s');
title('Module de la TF de s');


%% 2-extra/
%% En utilisant un signal à fréquence plus faible, on arrive à générer 
%  un vrai carré
F_p = 10;                        % Frequence du signal en Hz
f_p = -fe/2 : fe/1000 : fe/2-fe/1000 ;
D_p = N/F_p;
t_p = 0 : te : D_p-te;

s = square(2*pi*F_p*t_p);

figure(25);
plot(t_p, s);
xlabel('Temps (s)');
ylabel('Amplitude');
title('Signal carre s');
figure(26);
plot(f_p, fftshift(abs(fft(s))));
xlabel('fréquences (Hz)');
ylabel('spectre de s');
title('Module de la TF de s');


%% Partie 3 : Debruitage d'un signal par FFT

% TF et TF inverse
% Initialisation
fe = 1000;                      % Frequence d'echantillonnage en Hz
F = 10;                         % Frequence du signal en Hz
te = 1/fe;                      % Periode d'echantillonage en s
D = 1;                          % Duree du signal en s
A = 3;                          % Amplitude du signal
t = 0 : te : D - te;            % Creation de l'axe temporel


%s = cos(2*pi*10*t) + 3*cos(2*pi*55*t) - 6*cos(2*pi*122*t) % triple sinus
s = A*sin(2*pi*F*t); % sinus 
figure(9);
plot(t, s);
xlabel('Temps (s)');
ylabel('Amplitude (Amplitude (Amplitude))');
title('Signal sinusoidal s');

%% 1/
f = -fe/2 : fe/length(s) : fe/2 - fe/length(s); % Creation de l'axe des frequences
S = fft(s);  % FFT de s
figure(10);
plot(f, fftshift(abs(S)));
xlabel('fréquences (Hz)');
ylabel('spectre de s');
title('Module de la TF s');

%% 2/
s_i = ifft(S);
figure(11);
plot(t, s_i);
xlabel('temps (s)');
ylabel('Amplitude');
title('Signal s_prime issu de la ITF de la TF de s');

%% Bruit Blanc
%3/
bruit = 1*rand(1,D*fe)-0.5;  % Creation d'un bruit blanc centre d'ampitude 1
figure(12);
subplot(2, 1, 1); plot(t, bruit);
xlabel("temps (s)");
ylabel("amplitude");
title("signal et spectre du bruit");
subplot(2, 1, 2); plot(f, fftshift(abs((fft(bruit)))));
xlabel("frequence (Hz)");
ylabel("amplitude");


%% Bruitage du signal
% 4/
signal_bruite = s+0.5*A*bruit;
SIGNAL_BRUITE = fft(signal_bruite);
figure(13);
subplot(2, 1, 1); plot(t, signal_bruite);
xlabel("temps (s)");
ylabel("amplitude");
title("signal et spectre du signal bruité");
subplot(2, 1, 2); plot(f, fftshift(abs(SIGNAL_BRUITE)));
xlabel("fréquence (Hz)");
ylabel("amplitude");

%% Filtrage par FFT
%5/ et 6/

M = max(abs(SIGNAL_BRUITE));  % Amplitude maximale de la TF du signal bruite
S = 0.1;                      % Seuil à 10%
H = zeros(size(f));
for n = 1:length(f)
   if SIGNAL_BRUITE(n) > S*M
       H(n) = 1;
   end
end

SIGNAL_BRUITE_FILTRE = SIGNAL_BRUITE.*H;
signal_bruite_filtre = ifft(SIGNAL_BRUITE_FILTRE);
figure(14); 
subplot(2, 1, 1); plot(f, fftshift(abs(SIGNAL_BRUITE_FILTRE)));
xlabel("fréquence (Hz)");
ylabel("amplitude");
title("spectre et signal filtré");
subplot(2, 1, 2); plot(t, ifft(SIGNAL_BRUITE_FILTRE));
xlabel("temps (s)");
ylabel("amplitude");

% Exporte les figures ouvertes en images dans le repertoire courant
% export_figures();


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SIG - Initiation Traitment Signal : TP2 Extraction ECG
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

pkg load image;
pkg load signal;

%% 1/
% Chargement des données
load('ECG_TP_repos.mat');
load('ECG_TP_effort.mat');

%% 2/
% Initialisation : les deux fichiers ont exactement la meme duree, donc pas
% besoin de creer des variables separees.
fe = 1000;                      % Frequence d'echantillonnage en Hz
N = length(X_ECG_Rep);          % Taille du vecteur
t = linspace(0, N/fe, N);       % Echelle temporelle

% Affichage des series temporelles
figure(1);
subplot(2, 1, 1); plot(t, X_ECG_Rep);
xlabel('Temps (s)'); ylabel('Amplitude (mV)'); title('Signal ECG au repos')
subplot(2, 1, 2); plot(t, X_ECG_Eff);
xlabel('Temps (s)'); ylabel('Amplitude (mV)'); title('Signal ECG pendant effort')

%% 3/
NFFT = 2 .^ nextpow2(N);                   % Next power of 2 from length of x
FFT_ECG_Rep = fft(X_ECG_Rep, NFFT);        % TF repos
FFT_ECG_Eff = fft(X_ECG_Eff, NFFT);        % TF effort
f = fe/2 * linspace(0, 1, NFFT/2);         % Semie-echelle fréquentielle

% Affichage des spectres (module uniquement, pas la phase)
figure(2);
subplot(2, 1, 1); plot(f, 2*abs(FFT_ECG_Rep(1:NFFT/2)));
xlabel('Frequency (Hz)'); ylabel('|FFTECGRep(f)|');
title('Single-Sided Amplitude Spectrum of XECGRep');
subplot(2, 1, 2); plot(f, 2*abs(FFT_ECG_Eff(1:NFFT/2)));
xlabel('Frequency (Hz)'); ylabel('|FFTECGEff(f)|');
title('Single-Sided Amplitude Spectrum of XECGEff');

%% 4/ Extraction de la série temporelle RR
% Etape 1 : Seuillage
seuil_Rep = max(X_ECG_Rep)*0.6;
seuil_Eff = max(X_ECG_Eff)*0.6;

figure(3);
subplot(211);
plot(t, X_ECG_Rep);  hold on
plot(t, zeros(1,length(X_ECG_Rep))+seuil_Rep, 'linewidth', 2)
xlabel('Temps')
ylabel('amplitude')
legend("signal","seuil")
title('signal repos')
subplot(212);
plot(t, X_ECG_Eff); hold on
plot(t, zeros(1,length(X_ECG_Eff))+seuil_Eff, 'linewidth', 2)
xlabel('Temps')
ylabel('amplitude')
legend("signal","seuil")
title('signal effort')
%etape 2
Diag_ECG_Rep = X_ECG_Rep > seuil_Rep;
Diag_ECG_Eff = X_ECG_Eff > seuil_Eff;

figure(4);
subplot(211);
plot(t, Diag_ECG_Rep);
title('vecteur logique repos')
subplot(212);
plot(t, Diag_ECG_Eff);
title('vecteur logique effort')


%% Etapes 3 :
% Repos
Diff_Diag_ECG_Rep_P = find(diff(Diag_ECG_Rep) == 1); Diff_Diag_ECG_Rep_P(end) = [];
Diff_Diag_ECG_Rep_N = find(diff(Diag_ECG_Rep) == -1);
A_Rep = [];
B_Rep = [];
for k = 1 : length(Diff_Diag_ECG_Rep_P)
    [A_Rep(k), B_Rep(k)] = max(X_ECG_Rep(Diff_Diag_ECG_Rep_P(1, k) : Diff_Diag_ECG_Rep_N(1, k)));
    B_Rep(k) = B_Rep(k) + Diff_Diag_ECG_Rep_P(1, k);
end
Peak_ECG_Rep = zeros(size(X_ECG_Rep));
Peak_ECG_Rep(B_Rep) = X_ECG_Rep(B_Rep);

% Effort
Diff_Diag_ECG_Eff_P = find(diff(Diag_ECG_Eff) == 1); Diff_Diag_ECG_Eff_P(end) = [];
Diff_Diag_ECG_Eff_N = find(diff(Diag_ECG_Eff) == -1);
A_Eff = [];
B_Eff = [];
for k = 1 : length(Diff_Diag_ECG_Eff_P)
    [A_Eff(k), B_Eff(k)] = max(X_ECG_Eff(Diff_Diag_ECG_Eff_P(1, k) : Diff_Diag_ECG_Eff_N(1, k)));
    B_Eff(k) = B_Eff(k) + Diff_Diag_ECG_Eff_P(1, k);
end
Peak_ECG_Eff = zeros(size(X_ECG_Eff));
Peak_ECG_Eff(B_Eff) = X_ECG_Eff(B_Eff);

figure(1);  % Reprise de la figure 1
subplot(2, 1, 1); hold on; plot(t(B_Rep), Peak_ECG_Rep(B_Rep), 'r*');
subplot(2, 1, 2); hold on; plot(t(B_Eff), Peak_ECG_Eff(B_Eff), 'r*');

%% Etape 4 :
RR_ECG_Rep = diff(t(B_Rep));
RR_ECG_Eff = diff(t(B_Eff));

figure(5);
plot(0:length(RR_ECG_Rep)-1,RR_ECG_Rep);
hold on
plot(0:length(RR_ECG_Eff)-1,RR_ECG_Eff,'r');
legend('Rep','Eff')
ylabel('Time between 2 pulses')
xlabel('Pulse number')

%% 5/
fc1 = 0.4;    % Fréquence de coupure haute
fc2 = 0.04;   % Fréquence de coupure basse
fe_RR = 1;    %Freq d'echantillonnage theorique de la série RR

%Filtarge des series RR entre 0.04 Hz ET 0.4 Hz
RR_ECG_Rep_filtre = bandf(RR_ECG_Rep, (fc1*2)/fe_RR, (fc2*2)/fe_RR);
RR_ECG_Eff_filtre = bandf(RR_ECG_Eff, (fc1*2)/fe_RR, (fc2*2)/fe_RR);

% TF des signaux
nb_points_fft = 128;
f = fe_RR/2 * linspace(0, 1, nb_points_fft/2);
TF_RR_ECG_Rep_filtre = fft(RR_ECG_Rep_filtre, nb_points_fft);
TF_RR_ECG_Eff_filtre = fft(RR_ECG_Eff_filtre, nb_points_fft);

figure(6);
subplot(2,1,1)
plot(f, fftshift(abs(TF_RR_ECG_Rep_filtre(1:nb_points_fft/2))))
xlabel("frequence")
ylabel("spectre")
title("Spectre du signal repos filtré entre 0.04 et 0.4Hz")
subplot(2,1,2)
plot(f, fftshift(abs(TF_RR_ECG_Eff_filtre(1:nb_points_fft/2))))
xlabel("frequence")
ylabel("spectre")
title("Spectre du signal effort filtré entre 0.04 et 0.4Hz")

%% 6/
[PSD_RR_ECG_Rep_filtre, ff] = abs(fft(RR_ECG_Rep_filtre.*hann(length(RR_ECG_Rep_filtre))',nb_points_fft)).^2;
[PSD_RR_ECG_Eff_filtre, ff2] = abs(fft(RR_ECG_Eff_filtre.*hann(length(RR_ECG_Eff_filtre))',nb_points_fft)).^2;

figure(7);
% Affichage PSD des series RR filtrees
subplot(2,1,1)
plot(ff, abs(PSD_RR_ECG_Rep_filtre(1:nb_points_fft/2)))
xlabel("fréquences")
ylabel("spectre")
title("densité spectrale du signal repos")
subplot(2,1,2)
plot(ff2, abs(PSD_RR_ECG_Eff_filtre(1:nb_points_fft/2)))
xlabel("fréquences")
ylabel("spectre")
title("densité spectrale du signal effort")

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auteur : Sandie Cabon               
% But :  Segmentation et caractérisation des pleurs
% Description : Energie, fft
% Date : 09/03/2018                
% Version : 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear

%% Chargement du fichier

[extrait, FS] = audioread('crying_beeps.wav');
t_start = 0;
t_end = length(extrait) / FS;
t = t_start : 1/FS : t_end - 1/FS;

%% 1. Segmentation à partir de l'energie du signal
N = 30;
seuil = 0.0021;
[output_signal, logical_vector] = segmentation_energie_glissante(extrait, FS, N, seuil);

% enregistrement de l'extrait
audiowrite('crying_beeps_segmente.wav', output_signal, FS);

%% 2. Segmentation à partir de la FFT
[output_signal_fft] = segmentation_fft(output_signal, logical_vector, FS);

% enregistrement de l'extrait
audiowrite('crying_beeps_segmente_fft.wav', output_signal_fft, FS);

%% Affichage
figure(1);

subplot(3, 1, 1);
plot(t, extrait);
xlabel('temps (s)');
ylabel('signal brut');
title('Pleurs de bebe');

subplot(3, 1, 2);
plot(t, output_signal);
xlabel('temps (s)');
ylabel('signal segmente');

subplot(3, 1, 3);
plot(t, output_signal_fft);
xlabel('temps (s)');
ylabel('rejet des bips');

%% Calcul de la durée moyenne des pleurs

% On divise le temps passé a pleurer (H) par le nombre de pleurs (passage
% de 0 à une autre valeur) -> moyenne du temps des pleurs
H = sum(output_signal_fft ~= 0)/FS;
nb_pleurs = 0;
for i = 1:length(output_signal_fft)-1
    if output_signal_fft(i) == 0 && output_signal_fft(i+1) ~= 0
        nb_pleurs = nb_pleurs + 1;
    end
end

moyenne = H/nb_pleurs;


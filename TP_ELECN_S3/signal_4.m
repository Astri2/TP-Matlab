clear all
close all

% pkg load signal
%% 1.1
[extrait, FS] = audioread('extrait.wav');

figure(1);
t = (0:1:length(extrait)-1)*1/FS;
plot(t, extrait);
xlabel('Temps (s)');
ylabel('Amplitude');
title('signal sonore');

%% 1.2

taille_fenetre = 256;
recouvrement = 128;
nb_pt_fft = 256;

figure(2);
spectrogram(extrait, taille_fenetre, recouvrement, nb_pt_fft, FS, 'yaxis');
xlabel('Temps (s)');
ylabel('Fr�quence (Hz)');
title('Spectrograme du signal sonore');

%% 1.3.4

%downsample
extrait_down_2 = downsample(extrait, 2);
figure(3)
subplot(211)
plot((0:2:length(extrait)-1)*1/FS, extrait_down_2);
xlabel('Temps (s)');
ylabel('Amplitude');
title('signal sonore - downsample 2');
subplot(212)
spectrogram(extrait_down_2, taille_fenetre, recouvrement, nb_pt_fft, FS/2, 'yaxis');
xlabel('Temps (s)');
ylabel('Fr�quence (Hz)');
title('Spectrograme du signal sonore - downsample 2');

audiowrite('extrait_downsample_2.wav', extrait_down_2, FS/2)

extrait_down_4 = downsample(extrait, 4);
figure(4)
subplot(211)
plot((0:4:length(extrait)-1)*1/FS, extrait_down_4);
xlabel('Temps (s)');
ylabel('Amplitude');
title('signal sonore - downsample 4');
subplot(212)
spectrogram(extrait_down_4, taille_fenetre, recouvrement, nb_pt_fft, FS/4, 'yaxis');
xlabel('Temps (s)');
ylabel('Fr�quence (Hz)');
title('Spectrograme du signal sonore - downsample 4');

audiowrite('extrait_downsample_4.wav', extrait_down_4, FS/4);

%% 1.5

%decimate
extrait_decimate_2 = decimate(extrait, 2);
figure(5)
subplot(211)
plot((0:2:length(extrait)-1)*1/FS, extrait_decimate_2);
xlabel('Temps (s)');
ylabel('Amplitude');
title('signal sonore - decimate 2');
subplot(212)
spectrogram(extrait_decimate_2, taille_fenetre, recouvrement, nb_pt_fft, FS/2, 'yaxis');
xlabel('Temps (s)');
ylabel('Fr�quence (Hz)');
title('Spectrograme du signal sonore - decimate 2');

audiowrite('extrait_decimate_2.wav', extrait_decimate_2, FS/2)

extrait_decimate_4 = decimate(extrait, 4);
figure(6)
subplot(211)
plot((0:4:length(extrait)-1)*1/FS, extrait_decimate_4);
xlabel('Temps (s)');
ylabel('Amplitude');
title('signal sonore - decimate 4');
subplot(212)
spectrogram(extrait_decimate_4, taille_fenetre, recouvrement, nb_pt_fft, FS/4, 'yaxis');
xlabel('Temps (s)');
ylabel('Fr�quence (Hz)');
title('Spectrograme du signal sonore - decimate 4');

audiowrite('extrait_decimate_4.wav', extrait_decimate_4, FS/4);


%% 1.6
tau_2 = length(extrait_decimate_2)/length(extrait);
tau_4 = length(extrait_decimate_4)/length(extrait);

%% 2.1

bruit = 0.05 * randn(length(extrait),1);

%% 2.2

extrait_bruite = extrait + bruit;

figure(7);
subplot(311);
plot(t, extrait);
title('signal')
subplot(312);
plot(t, bruit);
title('bruit')
subplot(313);
plot(t, extrait_bruite);
title('signal bruite')

audiowrite('extrait_bruite.wav', extrait_bruite, FS)

%% 2.3

[DSP, f] = DensSpecPuiss(bruit, FS);

figure(8);
plot(f, DSP);
xlabel('fr�quences');
ylabel('DSP(f)');
title('DSP du bruit');

%% 2.4

% Fenetre de Hamming
th = 1:256;
hamming = 0.54-0.46*cos(2*pi*th/256);
figure(9);
plot(th, hamming(th));
xlabel('point');
title('fen�tre de haming');

%% 2.5

[den,den1,den2,hamx1,hamx2] = SoustractionSpe(extrait_bruite, hamming, DSP);

%% 2.6

figure(10);
subplot(311)
plot(t, den)
title('den')
subplot(312)
plot(t, den1)
title('den1')
subplot(313)
plot(t, den2)
title('den2')

den3 = (den+den1+den2)/3;

audiowrite('den.wav',  den,  FS);
audiowrite('den1.wav', den1, FS);
audiowrite('den2.wav', den2, FS);
audiowrite('den3.wav',den3, FS);

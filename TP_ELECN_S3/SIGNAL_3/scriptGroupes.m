close all

load('donnees_bebe.mat')

sain = data(1:length(data)/2,2);
perte = data(length(data)/2+1:length(data),2);

figure(50)
boxplot([sain,perte])
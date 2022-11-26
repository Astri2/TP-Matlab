%vider la memoire 
clear all;
%fermer les figures
close all;
%vider la console
clc;
%appliquer le format numerique long aux nombres, pour avoir plus de digits
format long;

%%%%%%%%%%%%%%%%%
% Configuration %
%%%%%%%%%%%%%%%%%

%Le polynome sous forme de lambda, qu'on utilise dans les algo de di/trichotomie
fun=@(x)x.^3+4.*x.^2-10; 
%Sa derivee
deriv=@(x)3*x.^2+8*x;

%Le meme polynome sous forme de vecteur, qu'on utilise pour calculer les racines
poly = [1 4 0 -10];
%Chercher toutes les racines du polynome
R = roots(poly);
%Ne garder que les racines reelles
R = R(imag(R)==0); 

%options d execution pour les differentes methodes utilisee:

%point de depart pour les methodes du point fixe et de newton
p0=1;
%bornes inf et sup pour les methodes de dicho, tricho, secante et fausse pos
a = 0;
b = 5;
%conditions de sortie des algorithmes:
%erreur maximal sur les abscices pour sortir de l'algorithme
tol=1e-3;
%nombre maximum d'iterations apres lesquelles abandonner la methode.
iMax=100;

%Booleen pour savoir si on execute la methode ou non
FaireDicoTricho=1;
FairePointFixe=1;
FaireNewton=1;
FaireSecante=1;
DoFalsePos=1;

%Boolean pour savoir si on affiche toutes les valeurs derreurs
DispAllErr=0;
%nombre de fois ou on fait tourner les methodes pour calculer leur temps dexecution
nbIterationMethodes=100;
%Boolean pour savoir si on affiche le graphe des erreurs
DispGraph=1;
%Boolean pour savoir si on afficher l erreur maximal de la dicho/tricho ou juste lerreur effective
DispErrMaxDichoTricho=0;

fprintf('Format de l affichage :\nxFinal | iterations | temps moyen | log10(err)\n\n')

if(FaireDicoTricho == 1)
    fprintf('Dichotomie\n')
    
    %lance le chronometre
    tic 
    % on execute fois la methode pour calculer le temps moyen dexecution
    for k = 1:nbIterationMethodes
        [xD, iD, errD, errDMax, failD] = dichotomic_func(a,b,tol,iMax, R, fun);
    end
    %on arrette le chronometre et on divise par nbIterationMethodes pour faire la moyenne
    tD = toc/nbIterationMethodes;
    
    %si la methode n'a pas reussi a trouver la racine apres n iterations, on affiche un warning
    if(failD) fprintf('La methode de la dichotomie a echoue apres %d iterations\n',iMax) endif
    %on affiche les stats de la methode
    fprintf('xD: %.10f | iD: %d | tD: %.10f | errD: %.10f\n',xD,iD,tD,log10(errD(end)))
    %si la configuration le demande, on affiche toutes les erreurs des i iterations
    if(DispAllErr) disp(errD) endif      
    
    %les autres methodes vont suivre cette facon de faire.
    
    fprintf('\nTrichotomie\n')

    tic
    for k = 1:nbIterationMethodes
        [xT, iT, errT, errTMax, failT] = dichotomic2_func(a,b,tol,iMax, R, fun);
    end
    tT = toc/nbIterationMethodes;
    
    if(failT) fprintf('La methode de la trichotomie a echoue apres %d iterations\n',iMax) endif
    fprintf('xT: %.10f | iT: %d | tT: %.10f | errT: %.10f\n',xT,iT,tT,log10(errT(end)))
    if(DispAllErr) disp(errT) endif
  
    % dic2 a une meilleure convergence, mais a plus de if, donc une iteration
    % pourrait prendre plus de temps que pour dic.
    %   -> Confirme par les test
end

if(FairePointFixe == 1)
    fprintf('\npoint fixe\n')
    
    g1=@(x)sqrt((-x.^3+10)./4); % marche
    g2=@(x)sqrt(10./(x+4)); %marche, cest le meilleur des deux
    
    %marche pas : 10/(x^2+4x) | (-4*x^2+10)/(x^2) | VERIFIER LES DIVERGENCES VIA THM PT FIXE
    
    tic
    for k = 1:nbIterationMethodes
        [ xP1, iP1, errP1, failP1 ] = fixedPoint_func(g1, p0, iMax, tol, R);
    end
    tP1 = toc/nbIterationMethodes;
    
    tic
    for k = 1:nbIterationMethodes
        [ xP2, iP2, errP2, failP2 ] = fixedPoint_func(g2, p0, iMax, tol, R);
    end
    tP2 = toc/nbIterationMethodes;
    
    if(failP1) fprintf('La methode du point fixe 1 a echoue apres %d iterations\n',iMax) endif
    fprintf('xP1 : %.10f | iP1 : %d | tP1 : %.10f | errP1: %.10f\n',xP1,iP1,tP1,log10(errP1(end)))
    if(DispAllErr) disp(errP1) endif
    
    if(failP2) fprintf('La methode du point fixz 2 a echoue apres %d iterations\n',iMax) endif
    fprintf('xP2 : %.10f | iP2 : %d | tP2 : %.10f | errP2: %.10f\n',xP2,iP2,tP2,log10(errP2(end)))
    if(DispAllErr) disp(errP2) endif
    
    gTP=@(x)x-((x.^3+4*x.^2-10)/(3*x.^2+8*x));
    
    tic
    for k = 1:nbIterationMethodes
        [ xTP, iTP, errTP, failTP ] = fixedPoint_func(gTP, p0, iMax, tol, R);
    end
    tTP = toc/nbIterationMethodes;
    
    if(failTP) fprintf('La methode du point fixe TP a echoue apres %d iterations\n',iMax) endif
    fprintf('xTP : %.10f | iTP : %d | tTP : %.10f | errTP: %.10f\n',xTP,iTP,tTP,log10(errTP(end)))
    if(DispAllErr) disp(errTP) endif
end

if(FaireNewton == 1)
  fprintf('\nnewton\n')
  
  tic
  for k = 1:nbIterationMethodes
  [ xN, iN, errN, failN ] = newton_func(fun,deriv,p0, iMax, tol, R);
  endfor
  tN = toc/nbIterationMethodes;
   
  if(failN) fprintf('La methode de Newton a echoue apres %d iterations\n',iMax) endif 
  fprintf('xN : %.10f | iN : %d | tN : %.10f | errN: %.10f\n',xN,iN,tN, log10(errN(end)))
  if(DispAllErr) disp(errN) endif
end

if(FaireSecante == 1)
  fprintf('\nsecante\n')
  
  tic
  for k = 1:nbIterationMethodes
  [ xS, iS, errS, failS ] = secante_func(fun,a,b,iMax,tol,R);
  endfor
  tS = toc/nbIterationMethodes;
  
  if(failS) fprintf('La methode de la secante a echoue apres %d iterations\n',iMax) endif
  fprintf('xS : %.10f | iS : %d | tS : %.10f | errS: %.10f\n\n',xS,iS,tS, log10(errS(end)))
  if(DispAllErr) disp(errS) endif
end

if(DoFalsePos == 1)
  fprintf('\nfausse pos\n')
  
  tic
  for k = 1:nbIterationMethodes
  [ xFP, iFP, errFP, failFP ] = falsePos_func(fun,a,b,iMax,tol,R);
  endfor
  tFP = toc/nbIterationMethodes;
  
  if(failFP) fprintf('La methode de la fausse position a echoue apres %d iterations\n',iMax) endif
  fprintf('xFP : %.10f | iFP : %d | tFP : %.10f | errFP : %.10f\n',xFP,iFP,tFP,log10(errFP(end)))
  if(DispAllErr) disp(errFP) endif
end

%si la configuration le demande, on affiche le graphe des erreurs
if(DispGraph)
  %on initialise la legende
  legends = [''];
  %les courbes seront pleines ou non selon si la methode a reussi ou non
  markers = ['-',':'];
  %on demande a matlab de supperposer des courbes
  hold on
  if(FaireDicoTricho)
    %on le log10 de l'erreur des n iterations de la methode
    plot(1:length(errD),log10(errD),markers(failD+1));
    plot(1:length(errT),log10(errT),markers(failT+1));
    %et on complete la legende
    legends = [ legends; 'dichotomie'; 'trichotomie'];
    if(DispErrMaxDichoTricho)
      plot(1:length(errDMax),log10(errDMax),"b--");
      plot(1:length(errTMax),log10(errTMax),"r--");
      legends = [ legends; 'dichoMax';'trichoMax'];
    endif
  endif
  if(FairePointFixe)
    plot(1:length(errP1),log10(errP1),markers(failP1+1));
    plot(1:length(errP2),log10(errP2),markers(failP2+1));
    legends = [ legends; 'point fixe 1';'point fixe 2'];
  endif
  if(FaireNewton)
    plot(1:length(errN),log10(errN),markers(failN+1));
    legends = [ legends; 'newton'];
  endif
  if(FaireSecante)
    plot(1:length(errS),log10(errS),markers(failS+1));
    legends = [ legends; 'secante'];
  endif
  if(DoFalsePos)
    plot(1:length(errFP),log10(errFP),markers(failFP+1));
    legends = [ legends; 'fausse pos'];
  endif
  %finalement on affecte notre legende a la figure
  legend(legends,'FontSize',20);
  title ("Log de l'erreur en fonction de l'itération n",'FontSize',40);
  xlabel("itération n",'FontSize',30);
  ylabel("Log10 de l'erreur absolue",'FontSize',30);
  grid on
  hold off
endif
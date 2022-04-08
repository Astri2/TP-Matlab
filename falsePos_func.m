function[xFinal, i, err, fail] = falsePos_func(fun, a, b, iterMax, tol, trueValue)
%   Fonction de la fausse position
% 
% * Entree :
%     -> fun - handle - Pointeur de fonction a traiter
%     -> a - Float - Borne inf de l intervalle de recherche
%     -> b - Float - Borne sup de l intervalle de recherche
%     -> iterMax - Int - Maximum d iterations de notre algorithme
%     -> tol - Float - critere d arret
%     -> trueValue - Float - veritable valeur de la racine

%
% * Sortie :
%     -> xFinal - Float - L approximation de notre racine
%     -> i - Int - Nombre d iterations necessaire pour trouver la bonne valeur approchee
%     -> err - [Float] - Valeur de l erreur entre l element calcule et la veritable valeur
%     -> fail - Boolean - Vrai si la methode a echoue apres iterMax iterations


  fail = 0;
  err = [];
  i = 1;
  
  if a == b
    error('les deux points de depart ne peuvent pas etre egaux')
  endif
  
  while i <= iterMax
    %on calcule f(b)
    FB = fun(b);
    
    %on calcule le taux d'accroissement entre b et a
    Fp = (FB - fun(a)) / (b - a);
    %on applique la formule de la secante
    c = b - FB/Fp;
    %on calcule limage du point calcule
    FC = fun(c);
    
    %on met a jour lerreur
    err = [err,abs(c-trueValue)];
    
    %si limage calculee est assez faible, on return
    if(abs(FC) < tol)
      xFinal = c;
      return
    endif
    
    %si FC et FB sont du meme signe, on met b a c 
    if(FC*FB > 0)
      b = c;
    %sinon a a c
    else
      a = c;
    endif
    %on incremente i
    i=i+1;
  end
  %si on a echoue, on affichera un warning
  fail = 1;
  xFinal = c;
end
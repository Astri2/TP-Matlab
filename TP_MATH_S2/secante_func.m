function[xFinal, i, err, fail] = secante_func(fun, a, b, iterMax, tol, trueValue)
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
  %     -> i - Int - Nombre d iterations necessaire pour trouver la bonne valeur
  %     -> err - [Float] - Valeur de l erreur entre l element calcule et la veritable valeur
  %     -> fail - Boolean - Vrai si la methode a echoue apres iterMax iterations
  
  fail = 0;
  err = [];
  i = 1;
  
  if(a == b)
    error('les deux points de depart ne peuvent pas etre egaux')
  endif
  
  while i <= iterMax
    %on stock b dans une variable temporaire
    tmp = b;
    FB = fun(b);
    %on calcule le taux daccroissement entre a et b
    FpB = (FB - fun(a)) / (b - a);
    %on calcule b via la suite de la methode de newton
    b = b - FB/FpB;
    %on met a a lancienne valeur de b
    a = tmp;

    %on met a jour lerreur
    err = [err,abs(b - trueValue)];
    
    %si on a atteint le 0, on return
    if(abs(fun(b)) < tol)
      xFinal = b;
      return
    endif
    
    %on incremente i
    i=i+1;
  end
  %si on a echoue, on affichera un warning
  fail = 1;
  xFinal = b;
end
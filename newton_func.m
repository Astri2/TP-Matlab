function [ xFinal, i, err, fail ] = newton_func( fun, deriv, p0, iterMax, tol, trueValue)
%   Fonction de newton 
%
%   * Entree :
%       -> fun - handle - Pointeur de fonction a traiter
%       -> deriv - handle - Pointeur sur la derivee de fonction a traiter
%       -> p0 - Float - premiere approximation
%       -> tol - Float - critere d arret
%       -> iterMax - Int - Maximum d iterations de notre algorithme
%       -> trueValue - Float - veritable valeur de la racine
%
% * Sortie :
%     -> xFinal - Float - L approximation de notre racine
%     -> i - Int - Nombre d iterations necessaire pour trouver la bonne valeur approchee
%     -> err - [Float] - Valeur de l erreur entre l element calcule et la veritable valeur
%     -> fail - Boolean - Vrai si la methode a echoue apres iterMax iterations

    fail = 0;
    err = [];
    i = 1;
    while(i <= iterMax)
      %on applique la suite c(n+1) = c(n) - f(c(n))/f(c(n))
      p0 = p0 - fun(p0)/deriv(p0);
      
      %on met a jour lerreur
      err = [err,abs(p0-trueValue)];
      
      %si on a atteint le 0 on return
      if(abs(fun(p0)) <= tol)
        xFinal = p0;
        return
      endif
      
      %on incremente i
      i=i+1;
    endwhile
    %si on a echoue, on affichera un warning
    fail = 1;
    xFinal = p0;
end
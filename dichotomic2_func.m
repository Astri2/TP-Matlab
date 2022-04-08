function [ xFinal, i, err, errMax, fail ] = dichotomic2_func( a, b, tol, iterMax, trueValue, fun )
    % Fonction de trichotomie qui execute l'algorithme de dichotomie sur
    % l'intervalle [a,b] pour trouver la racine presente dans cet
    % intervalle
    % 
    % * Entree :
    %   -> a - Float - Borne inferieure de l'intervalle
    %   -> b - Float - Borne superieure de l'invervalle
    %   -> tol - Float - critere d'arret
    %   -> iterMax - Int - Maximum d'iterations de notre algorithme
    %   -> trueValue - Float - le zerosro calcule par matlab du polynome
    %   -> fun - handle - le polynome
    %
    % * Sortie :
    %     -> xFinal - Float - L approximation de notre racine
    %     -> i - Int - Nombre d iterations necessaire pour trouver la bonne valeur approchee
    %     -> err - [Float] - Valeur de l erreur entre l element calcule et la veritable valeur
    %     -> errMax - [Float] - Valeur de l erreur maximale possible
    %     -> fail - Boolean - Vrai si la methode a echoue apres iterMax iterations

    fail=0;
    i=1;
    FA=fun(a);
    err = [];
    errMax = [];
    while i <= iterMax
        %on se place a 1/3 et a 2/3 des deux bornes
        c1 = a + (b-a)/3;
        c2 = a + 2*(b-a)/3;
        %et on calcule les images
        FC1 = fun(c1);
        FC2 = fun(c2);
        
        %Si FA et FC1 ne sont pas du meme signe,
        %   on met b a c1
        %sinon si FC1 et FC2 ne sont pas du meme signe,
        %   on met a a c1, FA a FC1 et b a c2
        %sinon on met a a c2 et FA a FC2.
        errMax = [errMax, abs((b-a)/3)];
        if FA*FC1 < 0
            b=c1;
            err = [err,abs(c1-trueValue)];
        elseif FC1*FC2 < 0
            a=c1;
            FA=FC1;
            b=c2;
            err = [err,(abs(c1-trueValue)+abs(c2-trueValue))/2];
        else
            a=c2;
            FA=FC2;
            err = [err,abs(c2-trueValue)];
        end
        
        %si une des image est suffisemment proche de 0, on la retourne 
        if(abs(FC1) <= tol)
          xFinal = c1;
          return
        elseif(abs(FC2) <= tol)
          xFinal = c2;
          return
        endif     
        
        %on incremente i
        i=i+1;
    end
    %apres iterMax iterations, on abandonne la recherche et on affiche un warning
    fail=1;
    xFinal = (c1+c2) / 2;
end


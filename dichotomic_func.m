function [ xFinal, i, err, errMax, fail ] = dichotomic_func( a, b, tol, iterMax, trueValue, fun )
    %Fonction de dichotomie qui execute l'algorithme de dichotomie sur
    %l'intervalle [a,b] pour trouver la racine presente dans cet intervalle
    %
    %
    % * Entree :
    %   -> a - Float - Borne inferieure de l'intervalle
    %   -> b - Float - Borne superieure de l'invervalle
    %   -> tol - Float - critere d'arret
    %   -> iterMax - Int - Maximum d'iterations de notre algorithme
    %   -> trueValue - Float - le zero calcule par matlab du polynome
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
        %on se place au milieu entre nos deux bornes
        c = a + (b-a)/2;
        %et on calcule l'image de ce milieu
        FC=fun(c);
                
        %on calcule l'erreur |cn-c|
        err = [err,abs(c-trueValue)];
        errMax = [errMax,abs((b-a)/2)];
        
        % on sort une fois que l'intervalle est suffisement petit
        if abs(FC) < tol 
           xFinal = c;
           %on calcule la difference entre la vraie valeure et notre valeur
           %trouvee
           return
        end
        
        %si FA et FC sont du meme signe, on met
        %a a c et FA a FC. Sinon on met b a c
        if FA*FC > 0
            a=c;
            FA=FC;
        else
            b=c;
        end
        %on incremente i
        i=i+1;
    end
    %apres iterMax iterations, on abandonne la recherche et on affiche un
    %warning
    fail=1;
    xFinal = c;
end


function [ xFinal, i, err, fail ] = fixedPoint_func( fun, p0, iterMax, tol, trueValue )
    % Fonction d'iteration du point fixe (fixed point iteration)
    % 
    % * Entree :
    %   -> fun - handle - pointeur de fonction a traiter
    %   -> p0 - Float - approximation initiale 
    %   -> tol - Float - critere darret
    %   -> iterMax - Int - Maximum d'iterations de notre algorithme
    %   -> trueValue - Float - veritable valeur de la racine
    %
    % * Sortie :
    %     -> xFinal - Float - L approximation de notre racine
    %     -> i - Int - Nombre d iterations necessaire pour trouver la bonne valeur approchee
    %     -> err - [Float] - Valeur de l erreur entre l element calcule et la veritable valeur
    %     -> fail - Boolean - Vrai si la methode a echoue apres iterMax iterations
    
    fail = 0;
    i=1;
    err=[];
    while(i <= iterMax)
        %on applique la suite c(n+1)= f(c(n))
        old=p0;
        p0=fun(p0);

        %on met a jour l'erreur
        err=[err,abs(p0-trueValue)];
        
        #on regarde si on a converge vers un 0
        if(abs(p0-old) <= tol)
            xFinal=p0;
            return
        end
        
        %on incremente i
        i=i+1;
    end
    %si on a echoue, on affichera un warning
    fail = 1;
    xFinal = p0;
end
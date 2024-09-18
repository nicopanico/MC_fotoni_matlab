function spettro = definisci_spettro_raggiX(kVp)
    % Definisce lo spettro energetico di una sorgente a raggi X con filtro di tungsteno
    % kVp: tensione del tubo a raggi X (in keV)
    
    % Parametri
    E_max = kVp;  % Energia massima del fotone (in keV)
    Z = 74;  % Numero atomico del tungsteno (target del tubo a raggi X)
    K = 1e-4;  % Costante di proporzionalità (approssimata)
    
    % Energia variabile da 1 keV fino a kVp (1000 campioni)
    E = linspace(1, E_max, 1000);  % Vettore delle energie
    
    % Formula di Bremsstrahlung
    N = (K * Z ./ E) .* (E_max - E);  % Spettro non filtrato
    
    % Filtrazione con filtro di tungsteno
    % Coefficiente di attenuazione massico approssimato per il tungsteno (in cm^2/g)
    a = 0.02;  % Fattore empirico di attenuazione (applicabile a bassi kVp)
    b = 2.7;   % Fattore esponenziale per il tungsteno
    
    % Calcolo della filtrazione in funzione dell'energia
    attenuazione_tungsteno = exp(-a * E.^(-b));  % Modello di attenuazione con tungsteno
    spettro = N .* attenuazione_tungsteno;   % Spettro filtrato
    
    % Normalizzazione
    spettro = spettro / max(spettro);
    
    % Visualizzazione facoltativa dello spettro
    figure;
    plot(E, spettro);
    xlabel('Energia (keV)');
    ylabel('Intensità');
    title('Spettro energetico per raggi X diagnostici con filtro di tungsteno');
end

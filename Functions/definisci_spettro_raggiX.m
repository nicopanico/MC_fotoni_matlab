function spettro = definisci_spettro_raggiX(kVp, show)
    % Definisce lo spettro energetico di una sorgente a raggi X con filtro di tungsteno
    % kVp: tensione del tubo a raggi X (in keV)
    % show: per mostrare il grafico dello spettro
    % Parametri
    E_max = kVp;  % Energia massima del fotone (in keV)
    Z = 74;  % Numero atomico del tungsteno (target del tubo a raggi X)
    K = 1e-4;  % Costante di proporzionalità (approssimata)
    
    % Energia variabile da 1 keV fino a kVp (1000 campioni)
    E = linspace(1, E_max, 1000);  % Vettore delle energie
    
    % Formula di Bremsstrahlung (radiazione di frenamento)
    N_brem = (K * Z ./ E) .* (E_max - E);  % Componente continua (Bremsstrahlung)
    
    % Aggiunta dei picchi caratteristici del tungsteno (intorno a 59 e 67 keV)
    picco1 = exp(-((E - 59).^2) / (2 * 2^2));  % Picco a 59 keV (larghezza 2 keV)
    picco2 = exp(-((E - 67).^2) / (2 * 2^2));  % Picco a 67 keV (larghezza 2 keV)
    
    % Combinazione della componente di Bremsstrahlung e dei picchi caratteristici
    intensita = N_brem + 0.1 * (picco1 + picco2);  % Somma ponderata (peso 0.1 per i picchi)
    
    % Filtrazione con filtro di tungsteno
    % Coefficiente di attenuazione massico approssimato per il tungsteno
    a = 0.04;  % Fattore empirico di attenuazione
    b = 2.7;   % Fattore esponenziale per il tungsteno
    
    % Calcolo della filtrazione in funzione dell'energia
    attenuazione_tungsteno = exp(-a * E.^(-b));  % Modello di attenuazione con tungsteno
    intensita = intensita .* attenuazione_tungsteno;   % Spettro filtrato
    
    % Normalizzazione
    intesita = intensita / max(intensita);
    % Crea la struttura per restituire energia e intensità
    spettro.energia = E;
    spettro.intensita = intensita;

    % Controlla valori anomali
    spettro.intensita = fillmissing(spettro.intensita, 'linear');  % Interpola linearmente il NaN
    if show 
        % Visualizzazione facoltativa dello spettro
        figure;
        plot(E, spettro);
        xlabel('Energia (keV)');
        ylabel('Intensità');
        title('Spettro energetico per raggi X diagnostici con picchi caratteristici e filtro di tungsteno');
    end
end


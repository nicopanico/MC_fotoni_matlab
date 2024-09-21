function spettro = definisci_spettro_gamma(MV, show)
    % Definisce lo spettro energetico per una sorgente gamma terapeutica (Linac o TrueBeam)
    % MV: Energia nominale in MV (es. 6 MV, 15 MV)
    % show: True o False per mostrare il grafico
    % Parametri per i due picchi energetici
    picco1_media = MV * 500;  % Primo picco a energia più bassa (circa 500 keV per 1 MV)
    picco2_media = MV * 1000; % Secondo picco a energia più alta (circa 1000 keV per 1 MV)
    
    % Deviazione standard per i picchi
    picco1_sigma = picco1_media * 0.2;  % Larghezza del primo picco (20% della media)
    picco2_sigma = picco2_media * 0.1;  % Larghezza del secondo picco (10% della media)
    
    % Energia variabile da 0 a un massimo di 3 * picco2_media
    E = linspace(0, picco2_media + 3 * picco2_sigma, 1000);  % Vettore delle energie
    
    % Primo picco lognormale (a bassa energia)
    N1 = (1 ./ (E * picco1_sigma * sqrt(2 * pi))) .* exp(- (log(E) - log(picco1_media)).^2 / (2 * picco1_sigma^2));
    
    % Secondo picco lognormale (a alta energia)
    N2 = (1 ./ (E * picco2_sigma * sqrt(2 * pi))) .* exp(- (log(E) - log(picco2_media)).^2 / (2 * picco2_sigma^2));
    
    % Combinazione dei due picchi per ottenere lo spettro finale
    intensita = N1 + N2;
    
    % Normalizzazione
    intensita = intensita / max(intensita);
    % Crea la struttura per restituire energia e intensità
    spettro = struct();  % Inizializzazione della struttura
    spettro.energia = E;
    spettro.intensita = intensita;
    
    % Controlla valori anomali
    spettro.intensita = fillmissing(spettro.intensita, 'linear');  % Interpola linearmente il NaN
    
    % Visualizzazione facoltativa dello spettro
    if show
        figure;
        plot(E, spettro);
        xlabel('Energia (keV)');
        ylabel('Intensità');
        title(['Spettro terapeutico per Linac/TrueBeam a ', num2str(MV), ' MV']);
    end
end

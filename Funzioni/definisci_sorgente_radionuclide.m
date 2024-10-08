function sorgente = definisci_sorgente_radionuclide(tipo_radionuclide, posizione_centro, raggio, num_particelle)
    % Definizione della sorgente radionuclide con distribuzione sferica
    % tipo_radionuclide: Nome del radionuclide (es. 'Iodio-131', 'Lutetium-177')
    % posizione_centro: Centro della sorgente (es. [50, 50, 50] per il centro della griglia)
    % raggio: Raggio della sfera di distribuzione della sorgente
    % num_particelle: Numero di particelle da emettere
    
    switch tipo_radionuclide
        case 'Iodio-131'
            % Energia gamma principale: 364 keV (0.364 MeV) e altri contributi
            energie_gamma = [0.364, 0.637, 0.723];  % In MeV, principali emissioni gamma
            probabilita_gamma = [0.82, 0.07, 0.18];  % Probabilità associate alle emissioni gamma
            
            % Energia beta: distribuita in modo continuo tra 0 e 0.807 MeV
            energia_beta = rand(num_particelle, 1) * 0.807;  % Energia beta in MeV

            % Campionamento delle energie gamma per ciascun fotone
            energia_gamma = randsample(energie_gamma, num_particelle, true, probabilita_gamma);
            
            % Due spettri separati: uno per gli elettroni (beta) e uno per i fotoni (gamma)
            sorgente.spettro_elettroni = energia_beta;
            sorgente.spettro_fotoni = energia_gamma;

        case 'Lutetium-177'
            % Simile all'approccio per l'Iodio-131, ma con le sue energie
            energie_gamma = [0.113, 0.208];  % Emissioni gamma
            probabilita_gamma = [0.11, 0.13];  % Probabilità
            energia_beta = rand(num_particelle, 1) * 0.5;  % Beta continua
            energia_gamma = randsample(energie_gamma, num_particelle, true, probabilita_gamma);
            
            sorgente.spettro_elettroni = energia_beta;
            sorgente.spettro_fotoni = energia_gamma;

        case 'Yttrium-90'
            % Energia beta principale: 2.28 MeV
            energie = [2.28];  % In MeV, emissione beta
            probabilita = [1];  % 100% emissione

        otherwise
            error('Radionuclide non supportato.');
    end
    
    
    % Definizione della posizione della sorgente come sfera di concentrazione
    sorgente.posizione = [];
    for i = 1:num_particelle
        % Genera una posizione casuale all'interno di una sfera con raggio definito
        posizione_relativa = randn(1, 3);  % Posizione casuale in 3D
        posizione_relativa = posizione_relativa / norm(posizione_relativa);  % Normalizzazione del vettore
        distanza = raggio * rand;  % Distanza entro il raggio definito
        posizione_particella = posizione_centro + posizione_relativa * distanza;  % Posizione all'interno della sfera
        sorgente.posizione = [sorgente.posizione; round(posizione_particella)];
    end
    
    % Tipo della sorgente e radionuclide
    sorgente.tipo = tipo_radionuclide;
    sorgente.raggio = raggio;
end

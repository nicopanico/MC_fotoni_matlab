% Ottieni il percorso della cartella principale
mainFolder = pwd;
% Aggiungi tutte le sottocartelle al percorso
addpath(genpath(mainFolder));

%% Definizione dei tipi di radiazione
tipi_radiazione = {'fotone', 'elettrone', 'neutrone'};
% Proprietà dei tipi di radiazione
radiazione(1).nome = 'fotone';
radiazione(1).massa = 0;  % in MeV/c^2
radiazione(1).carica = 0;
radiazione(1).interazioni = {'fotoelettrico', 'compton', 'pair_production'};
 
radiazione(2).nome = 'elettrone';
radiazione(2).massa = 0.511;  % in MeV/c^2
radiazione(2).carica = -1;
radiazione(2).interazioni = {'collisione', 'bremsstrahlung'};

radiazione(3).nome = 'neutrone';
radiazione(3).massa = 939.565;  % in MeV/c^2
radiazione(3).carica = 0;
radiazione(3).interazioni = {'scattering_elastico', 'cattura'};

%% Parametri del volume
grid_size = [100, 100, 100];  % Dimensioni della griglia 3D
dose_grid = zeros(grid_size);  % Griglia 3D per il deposito della dose
voxel_size = 0.1;  % Dimensione del voxel in cm (spessore di ogni cella della griglia)

%% Sorgente ed energia

posizione_centro = round(grid_size / 2);  % Centro della griglia per esempio
raggio_sorgente = 5;  % Raggio della sfera di concentrazione in cm
num_particelle = 10000;  % Numero di particelle da simulare
tipo_radionuclide = 'Iodio-131';  % Radionuclide selezionato

% Definizione della sorgente utilizzando la nuova funzione
sorgente = definisci_sorgente_radionuclide(tipo_radionuclide, posizione_centro, raggio_sorgente, num_particelle);

% Energia iniziale delle particelle (campionata dallo spettro)
energie_iniziali = sorgente.spettro_energetico; 
%% Parametri per diversi materiali (ad esempio: aria, tessuto, osso)
materiali(1).nome = 'aria';
materiali(1).densita = 0.0012;  % g/cm³
materiali(1).energia_legame = 0.000;  % Energia di legame (in MeV)

materiali(2).nome = 'tessuto';
materiali(2).densita = 1.0;  % g/cm³
materiali(2).energia_legame = 0.000532;  % Energia di legame (in MeV)

materiali(3).nome = 'osso';
materiali(3).densita = 1.85;  % g/cm³
materiali(3).energia_legame = 0.00404;  % Energia di legame (in MeV)

% Griglia che definisce il materiale in ogni voxel (esempio semplificato)
material_grid = randi([1,3], grid_size);  % Genera un materiale casuale (1=aria, 2=tessuto, 3=osso)
%% Scarica i dati relativi ai coefficienti di assorbimento

dati = readtable('data_osso.txt');
% Estrai le colonne di energia e coefficienti di attenuazione
energia_tab = dati{:,1};  % Energia in MeV
mu_fotoelettrico_tab = dati{:,2};  % Coefficiente fotoelettrico
mu_compton_tab = dati{:,3};  % Coefficiente Compton
mu_pair_production_tab = dati{:,4};  % Coefficiente di produzione di coppie

%% Simulazione principale
parfor i = 1:num_particelle
    % Energia iniziale
    energia = energie_iniziali(i);
    energia_depositata = 0; %inizializza en_depositata
    
    % Inizializza la particella all'inizio del ciclo
    particella = struct('tipo', 'fotone', 'energia', energie_iniziali(i), 'posizione', sorgente.posizione, 'direzione', [0, 0, 0]);

    % Posizione iniziale (sorgente)
    posizione = sorgente.posizione(i,:);

    % Definisci "particella_secondaria" all'interno del ciclo
    particella_secondaria = struct('tipo', 'elettrone', 'energia', 0, 'posizione', [0, 0, 0], 'direzione', [0, 0, 0]);
    
    % Ogni thread ha la sua griglia locale indipendente
    dose_grid_local = zeros(grid_size);  
    particelle_queue = [];

    % Aggiungi le particelle primarie alla coda

    particella.tipo = 'fotone';
    particella.energia = energia;
    particella.posizione = posizione;
    particella.direzione = randn(1, 3);  % Direzione casuale
    particelle_queue = [particelle_queue; particella];


    % Simulazione interazioni
    while ~isempty(particelle_queue)
        % Estrae la particella dalla coda
        particella = particelle_queue(1);
        particelle_queue(1) = []; % rimuovi la particella dalla queue
        
        % Dati della particella
        energia = particella.energia;
        posizione = particella.posizione;
        direzione = particella.direzione;
        if strcmp(particella.tipo, 'fotone')
            % Simulazione delle interazioni per i fotoni
            while energia > 0
                % Identifica il materiale corrente
                materiale_idx = material_grid(posizione(1), posizione(2), posizione(3));
                materiale = materiali(materiale_idx);
                
                % Calcola i coefficienti di attenuazione per le interazioni
                [mu_fotoelettrico, mu_compton, mu_pair_production] = coefficiente_attenuazione_tab(energia, energia_tab, mu_fotoelettrico_tab, mu_compton_tab, mu_pair_production_tab);
                
                mu_totale = mu_fotoelettrico + mu_compton + mu_pair_production;
                mfp = -log(rand) / mu_totale;  % Calcola il cammino libero medio
                
                nuova_posizione = posizione + mfp * randn(1,3);
                posizione = round(nuova_posizione);
                
                % Controlla se la particella è ancora nel volume
                if particella_fuori_griglia(posizione, grid_size)
                    break;
                end
            
                % Determina l'interazione
                r = rand * mu_totale;
                if r < mu_fotoelettrico
                    % Effetto fotoelettrico
                    energia_legame = materiale.energia_legame;  % Richiama l'energia di legame specifica
                    energia_elettrone = energia - energia_legame;  % Calcola l'energia dell'elettrone emesso

                    % dose_grid(posizione(1), posizione(2), posizione(3)) = ...
                    %     dose_grid(posizione(1), posizione(2), posizione(3)) + energia;
                    % Aggiungi l'elettrone emesso alla queue
                    particella_secondaria.tipo = 'elettrone';
                    particella_secondaria.energia = energia_elettrone;
                    particella_secondaria.posizione = posizione;
                    particella_secondaria.direzione = randn(1, 3);  % Direzione casuale
                    particelle_queue = [particelle_queue; particella_secondaria];
                    energia = 0;  % Energia assorbita completamente
                elseif r < mu_fotoelettrico + mu_compton
                    % Scattering Compton
                    angolo_scat = calcola_angolo_scat(energia);  % Formula di Klein-Nishina 
                    direzione = aggiorna_direzione(direzione, angolo_scat);
                    energia_scat = calcola_energia_scat(energia, angolo_scat);
                    energia_depositata = energia - energia_scat;
                    dose_grid_local(posizione(1), posizione(2), posizione(3)) = dose_grid_local(posizione(1), posizione(2), posizione(3)) + energia_depositata;
                    energia = energia_scat;  % Continua con l'energia rimanente
                else
                    % Produzione di coppie
                    if energia > 1.022
                        % dose_grid_local(posizione(1), posizione(2), posizione(3)) = ...
                        %     dose_grid_local(posizione(1), posizione(2), posizione(3)) + 1.022;  % Deposito energia
                        % Calcola l'energia rimanente
                        energia_rimanente = energia - 1.022;  % Energia rimanente dopo la creazione della coppia

                        % Distribuzione casuale dell'energia rimanente tra i due elettroni
                        energia_elettrone = energia_rimanente * rand();  % Energia casuale per il primo elettrone
                        energia_positrone = energia_rimanente - energia_elettrone;  % Energia rimanente per il secondo elettrone

                        % Generazione dell'elettrone
                        direzione_elettrone = randn(1, 3);  % Direzione casuale per l'elettrone
                        direzione_elettrone = direzione_elettrone / norm(direzione_elettrone);  % Normalizzazione
                        elettrone = struct('tipo', 'elettrone', 'energia', energia_elettrone, 'posizione', posizione, 'direzione', direzione_elettrone);

                        % Generazione del positrone
                        direzione_positrone = -direzione_elettrone;  % Il positrone ha una direzione opposta all'elettrone
                        positrone = struct('tipo', 'positrone', 'energia', energia_positrone, 'posizione', posizione, 'direzione', direzione_positrone);

                        % Aggiunta elettrone e positrone alla queue direttamente
                        particelle_queue = [particelle_queue; elettrone; positrone];
                    else
                        energia = 0; % Il fotone viene assorbito completamente
                    end
                end
            end
        elseif strcmp(particella.tipo, 'elettrone')
            materiale_idx = material_grid(round(posizione(1)), round(posizione(2)), round(posizione(3)));
            materiale = materiali(materiale_idx);
            % Calculate the stochastic range for electron transport
            [distanza_stocastica] = calcola_distanza_stocastica(particella.energia, materiale.nome, true);
            soglia_energia = 0; %Energia sotto la quale l'elettrone viene fermato

            % Initialize electron transport
            energia_residua = particella.energia;
            posizione_elettrone = particella.posizione;
            direzione_elettrone = particella.direzione;
            % Continue transport until energy is below a threshold or stochastic range is traveled
            while energia_residua > soglia_energia && distanza_stocastica > 0
                % Calculate stopping power at current energy and material
                stopping_power = ottieni_stopping_power(energia_residua, materiale.nome);
                [~,mean_free_path, scattering_angle_std] = calcola_distanza_stocastica(energia_residua, materiale.nome, false);
                passo = 0.1 * mean_free_path;  % Step size as a fraction of the mean free path

                % Stepwise transport for electron
                [nuova_posizione, nuova_direzione, energia_residua] = trasporto_elettrone_stepwise(...
                    posizione_elettrone, direzione_elettrone, energia_residua, passo, stopping_power, scattering_angle_std);

                % Update stochastic range (reduce the remaining distance)
                distanza_stocastica = distanza_stocastica - norm(nuova_posizione - posizione_elettrone);

                % Aggiorna l'energia della particella
                particella.energia = energia_residua;

                % Update the particle's position and direction
                particella.posizione = nuova_posizione;
                particella.direzione = nuova_direzione;

                % Check if particle is outside the grid
                if particella_fuori_griglia(nuova_posizione, grid_size)
                    break;
                end

                % Calculate the energy deposited during this step using the stopping power
                energia_depositata = stopping_power * norm(nuova_posizione - posizione_elettrone);

                % Update the dose grid with deposited energy
                nuova_posizione = round(nuova_posizione);
                dose_grid_local(nuova_posizione(1), nuova_posizione(2), nuova_posizione(3)) = ...
                    dose_grid_local(nuova_posizione(1), nuova_posizione(2), nuova_posizione(3)) + energia_depositata;

                % Requeue the electron if it still has energy
                if energia_residua > soglia_energia
                    particelle_queue = [particelle_queue; particella];
                end
            end     
        elseif strcmp(particella.tipo, 'positrone')
            materiale_idx = material_grid(round(posizione(1)), round(posizione(2)), round(posizione(3)));
            materiale = materiali(materiale_idx);
            soglia_annichilazione = 0.511;
            % Inizializza energia residua e distanza stocastica
            energia_residua = particella.energia;
            posizione_positrone = particella.posizione;
            direzione_positrone = particella.direzione;

            % Calcolo del range stocastico prima del ciclo while, come per l'elettrone
            distanza_stocastica = calcola_distanza_stocastica(energia_residua, materiale.nome, true);

            % Inizia il trasporto del positrone passo dopo passo come elettrone
            while energia_residua > soglia_annichilazione && distanza_stocastica > 0
                % Calcola il potere frenante alla corrente energia
                stopping_power = ottieni_stopping_power(energia_residua, materiale.nome);
                
                % Ricalcola il cammino libero medio e lo scattering alla corrente energia
                [~, mean_free_path, scattering_angle_std] = calcola_distanza_stocastica(energia_residua, materiale.nome, false);
                passo = 0.1 * mean_free_path;  % Dimensione del passo come frazione del cammino libero medio
                
                % Esegui il trasporto del positrone passo dopo passo
                [nuova_posizione, nuova_direzione, energia_residua] = trasporto_elettrone_stepwise(...
                    posizione_positrone, direzione_positrone, energia_residua, materiale, passo, stopping_power, scattering_angle_std);
        
                % Aggiorna la distanza stocastica (riduci la distanza rimanente)
                distanza_stocastica = distanza_stocastica - norm(nuova_posizione - posizione_positrone);
        
                % Aggiorna la posizione e la direzione della particella
                particella.posizione = nuova_posizione;
                particella.direzione = nuova_direzione;
        
                % Verifica se la particella è fuori dalla griglia
                if particella_fuori_griglia(nuova_posizione, grid_size)
                    break;
                end
        
                % Calcola l'energia depositata durante questo passo
                energia_depositata = stopping_power * norm(nuova_posizione - posizione_positrone);
                nuova_posizione = round(nuova_posizione);
                dose_grid_local(nuova_posizione(1), nuova_posizione(2), nuova_posizione(3)) = ...
                    dose_grid_local(nuova_posizione(1), nuova_posizione(2), nuova_posizione(3)) + energia_depositata;
                
                % Aggiorna l'energia residua
                energia_residua = energia_residua - energia_depositata;
            end
            % Controlla se il positrone deve annichilarsi
            if particella.energia < soglia_annichilazione
                % Simula l'annichilazione del positrone
                fotone1 = struct('tipo', 'fotone', 'energia', 0.511, 'posizione', particella.posizione, 'direzione', randn(1, 3));
                fotone2 = struct('tipo', 'fotone', 'energia', 0.511, 'posizione', particella.posizione, 'direzione', -fotone1.direzione);
                particelle_queue = [particelle_queue; fotone1; fotone2];
            else
                % Continua a simulare il positrone
                particella.energia = particella.energia - energia_depositata;
                if particella.energia > 0
                    particelle_queue = [particelle_queue; particella];
                end
            end
        end
    end
    % Dopo ogni iterazione, somma la griglia locale a quella principale
    dose_grid = dose_grid + dose_grid_local;
end

%% Conversione della dose da MeV/cm³ a Gray (Gy)

% Parametri della densità per i diversi materiali (in kg/m³)
densita_materiale = [1.2, 1000, 1850];  % Aria, acqua/tessuto, osso (approssimati)

% Costante di conversione MeV -> J
MeV_to_J = 1.60218e-13;

% Conversione della dose da MeV/cm³ a Gy
dose_in_Gy_grid = zeros(grid_size);  % Griglia per la dose in unità di Gray

% Itera attraverso la griglia e converte la dose accumulata in Gy
for x = 1:grid_size(1)
    for y = 1:grid_size(2)
        for z = 1:grid_size(3)
            materiale = material_grid(x, y, z);  % Ottiene il materiale per il voxel attuale
            densita = densita_materiale(materiale);  % Densità del materiale
            % Conversione della dose da MeV/cm³ a Gy
            dose_in_Gy_grid(x, y, z) = dose_grid(x, y, z) * MeV_to_J / (densita * 1e6);  % 1e6 per cm³ -> m³
        end
    end
end

%% Visualizzazione 3D di voxel con dose non nulla in Gray e scala di colori

visualizza_dose(dose_in_Gy_grid, 0, false);  % 'dose_grid' è la griglia 3D della dose, e 0.1 è la soglia di dose
visualizza_dose_TPS(dose_in_Gy_grid, 0, 'Gy');
visualizza_dose_interattiva(dose_in_Gy_grid, 'Gy');
% figure;
% [x, y, z] = ind2sub(size(dose_in_Gy_grid), find(dose_in_Gy_grid > 0));  % Trova i voxel con dose non nulla
% dose_values_Gy = dose_in_Gy_grid(dose_in_Gy_grid > 0);  % Dose corrispondente in Gy
% 
% % Crea la scatter plot 3D con una scala di colori per la dose in Gy
% scatter3(x, y, z, 36, dose_values_Gy, 'filled');
% colorbar;  % Aggiungi la barra dei colori per indicare la dose in Gy
% colormap jet;  % Mappa di colori (puoi provare anche "hot" o "parula")
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% title('Distribuzione della Dose nei Voxel con Dose Non Nulla (in Gy)');
% axis equal;  % Mantiene la proporzione degli assi

%% Calcolo della dose totale e della dose media
dose_totale = sum(dose_grid(:));  % Dose totale in MeV
volume_totale = prod(grid_size) * voxel_size^3;  % Volume totale in cm^3
dose_media_MeV_cm3 = dose_totale / volume_totale;  % Dose media in MeV/cm^3

% Calcolo della densità media del volume
densita_totale = 0;
for x = 1:grid_size(1)
    for y = 1:grid_size(2)
        for z = 1:grid_size(3)
            materiale = material_grid(x, y, z);  % Ottiene il materiale del voxel
            densita_totale = densita_totale + densita_materiale(materiale);  % Somma le densità
        end
    end
end
densita_media = densita_totale / numel(dose_grid);  % Densità media del volume (kg/m³)

% Conversione della dose media da MeV/cm³ a Gray (Gy)
dose_media_Gy = dose_media_MeV_cm3 * MeV_to_J / (densita_media * 1e6);  % Conversione a Gy

% Mostra il risultato in MeV/cm³ e in Gray
fprintf('La dose stimata è: %.3f MeV/cm^3\n', dose_media_MeV_cm3);
fprintf('La dose stimata è: %.3f Gy\n', dose_media_Gy);

%% Funzioni


% Funzione per calcolare l'angolo di scattering secondo Klein-Nishina
function angolo_scat = calcola_angolo_scat(energia)
    % Costanti
    m_e = 0.511;  % Massa a riposo dell'elettrone in MeV/c^2
    
    % Formula Klein-Nishina (approssimata)
    r = rand;  % Numero casuale per determinare l'angolo
    cos_theta = 1 - (1 + (energia/m_e) * (1 - r)) / (1 + energia/m_e);  % Coseno dell'angolo di scattering
    angolo_scat = acos(cos_theta);  % Angolo di scattering in radianti
end

% Funzione per aggiornare la direzione in base all'angolo di scattering
function nuova_direzione = aggiorna_direzione(direzione, angolo_scat)
    % Genera angolo casuale per il piano perpendicolare
    phi = 2 * pi * rand;  % Angolo casuale tra 0 e 2*pi
    % Calcola i nuovi componenti della direzione
    nuova_direzione(1) = sin(angolo_scat) * cos(phi);
    nuova_direzione(2) = sin(angolo_scat) * sin(phi);
    nuova_direzione(3) = cos(angolo_scat);
    % Ruota la direzione originale con la nuova
    nuova_direzione = nuova_direzione + direzione;
    nuova_direzione = nuova_direzione / norm(nuova_direzione);  % Normalizza il vettore
end

% Funzione per calcolare l'energia residua dopo lo scattering
function energia_scat = calcola_energia_scat(energia_iniziale, angolo_scat)
    m_e = 0.511;  % Massa a riposo dell'elettrone in MeV/c^2
    energia_scat = energia_iniziale / (1 + (energia_iniziale/m_e) * (1 - cos(angolo_scat)));
end


%% NOTE CODICE

% -Integrare il modello elettronico al meglio nel codice, testando che
% funzioni 
% -Cercare di definire bene come inserire gli input geometrici nel codice
% (strutture)
% -Calcolare numero fotoni dalle fluenze per avere il giusto rescaling
% della dose in fase di simulazione e calcolo
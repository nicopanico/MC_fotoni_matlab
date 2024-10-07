% Durante il trasporto di un elettrone
elseif strcmp(particella.tipo, 'elettrone')
    % Esegui il trasporto passo-passo dell'elettrone
    while energia_residua > soglia_energia && distanza_stocastica > 0
        % Calcola il potere frenante alla corrente energia
        stopping_power = ottieni_stopping_power(energia_residua, materiale);
        
        % Calcolo probabilità di emissione Bremsstrahlung
        probabilita_bremsstrahlung = calcola_probabilita_bremsstrahlung(energia_residua, materiale);
        
        % Se Bremsstrahlung avviene
        if rand() < probabilita_bremsstrahlung
            % Energia del fotone emesso per Bremsstrahlung (stocastico)
            energia_fotone_brems = energia_residua * rand();
            
            % Direzione del fotone emesso
            direzione_fotone_brems = randn(1, 3);  % Direzione casuale
            direzione_fotone_brems = direzione_fotone_brems / norm(direzione_fotone_brems);  % Normalizza
            
            % Genera il fotone di Bremsstrahlung e aggiungilo alla queue
            fotone_bremsstrahlung = struct('tipo', 'fotone', 'energia', energia_fotone_brems, 'posizione', particella.posizione, 'direzione', direzione_fotone_brems);
            particelle_queue = [particelle_queue; fotone_bremsstrahlung];
            
            % Riduci l'energia dell'elettrone per tener conto dell'emissione Bremsstrahlung
            energia_residua = energia_residua - energia_fotone_brems;
        end
        
        % Prosegui con il normale trasporto dell'elettrone
        % Aggiorna la posizione, energia, ecc...
        % ...
    end
end

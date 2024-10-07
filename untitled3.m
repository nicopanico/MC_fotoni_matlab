% Calcola la proiezione della particella nella griglia
if strcmp(particella.tipo, 'fotone')
    % Direzione della particella
    direzione = particella.direzione;  % [dx, dy, dz]
    
    % Solo se la particella è inizialmente fuori dalla griglia
    if posizione(3) < 1
        % Calcola il tempo t quando la particella raggiunge z = 1
        t = (1 - posizione(3)) / direzione(3);  % z = 1 è il piano della griglia
        
        % Calcola le nuove coordinate x, y, z della particella a z = 1
        nuova_posizione(1) = posizione(1) + t * direzione(1);  % x = x_0 + t * dx
        nuova_posizione(2) = posizione(2) + t * direzione(2);  % y = y_0 + t * dy
        nuova_posizione(3) = 1;  % La particella entra nella griglia a z = 1

        % Verifica se la particella entra nella griglia (x e y devono essere validi)
        if nuova_posizione(1) < 1 || nuova_posizione(1) > grid_size(1) || ...
           nuova_posizione(2) < 1 || nuova_posizione(2) > grid_size(2)
            % La particella non entrerà mai nella griglia
            continue;  % Passa alla prossima particella nella coda
        end

        % Aggiorna la posizione della particella alla nuova posizione
        particella.posizione = round(nuova_posizione);
    end
    
    % Ora che la particella è nella griglia, procedi con la simulazione
    % Simulazione delle interazioni per i fotoni
    while energia > 0
        % Identifica il materiale corrente
        materiale_idx = material_grid(posizione(1), posizione(2), posizione(3));
        materiale = materiali(materiale_idx);

        % Interazioni...
    end
end
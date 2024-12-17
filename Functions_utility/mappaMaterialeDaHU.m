
function material_id = mappaMaterialeDaHU(HU_value, materiali, materiali_map)
    candidates = [];
    for i = 1:size(materiali_map, 1)
        HU_min = materiali_map{i, 1};
        HU_max = materiali_map{i, 2};
        if HU_value >= HU_min && HU_value < HU_max
            candidates(end+1) = i; %#ok<AGROW>
        end
    end

    % Se nessun candidato
    if isempty(candidates)
        idx = find(strcmp({materiali.Nome}, 'tessuto_molle'));
        material_id = idx;
        return;
    end

    % Se un solo candidato
    if length(candidates) == 1
        mat_name = materiali_map{candidates(1), 3};
        idx = find(strcmp({materiali.Nome}, mat_name));
        material_id = idx;
        return;
    end

    % Più candidati: scegli in base alla priorità del materiale
    bestPriority = -Inf;
    samePriorityIndices = [];

    for c = candidates
        mat_name = materiali_map{c, 3};
        idx = find(strcmp({materiali.Nome}, mat_name));
        mat_priority = materiali(idx).Priority;
        if mat_priority > bestPriority
            bestPriority = mat_priority;
            samePriorityIndices = idx; 
        elseif mat_priority == bestPriority
            samePriorityIndices(end+1) = idx; %#ok<AGROW>
        end
    end

    % Se un solo candidato con priorità max
    if length(samePriorityIndices) == 1
        material_id = samePriorityIndices(1);
        return;
    end

    % Ancora più candidati con la stessa priorità: usa la densità
    rho_pred = 1 + (HU_value / 1000);
    bestDiff = Inf;
    bestFinal = samePriorityIndices(1);

    for id_m = samePriorityIndices
        diff = abs(materiali(id_m).Densita - rho_pred);
        if diff < bestDiff
            bestDiff = diff;
            bestFinal = id_m;
        end
    end

    material_id = bestFinal;
end

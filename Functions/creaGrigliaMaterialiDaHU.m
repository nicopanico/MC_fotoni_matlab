function material_grid = creaGrigliaMaterialiDaHU(voxelGridHU, materiali, materiali_map)
    dim = size(voxelGridHU);
    material_grid = zeros(dim, 'uint8'); % Preallocazione della griglia

    % Barra di avanzamento
    h = waitbar(0, 'Creazione della griglia materiali...');
    total_voxels = dim(1);
    q = parallel.pool.DataQueue;

    % Listener per aggiornare la barra di avanzamento
    progress = 0;
    afterEach(q, @(~) updateProgress());

    % Funzione locale per aggiornare la barra
    function updateProgress()
        progress = progress + 1;
        waitbar(progress / total_voxels, h);
    end

    % Uso di parfor per elaborare ogni fetta lungo l'asse X
    parfor x = 1:dim(1)
        slice_materials = zeros(dim(2), dim(3), 'uint8'); % Griglia locale per la fetta
        for y = 1:dim(2)
            for z = 1:dim(3)
                HU_value = voxelGridHU(x, y, z);
                mat_id = mappaMaterialeDaHU(HU_value, materiali, materiali_map);
                slice_materials(y, z) = uint8(mat_id);
            end
        end
        material_grid(x, :, :) = slice_materials; % Copia la fetta nella griglia principale

        % Notifica il completamento di una fetta
        send(q, x);
    end

    close(h);
end


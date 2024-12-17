function visualizzaCT(voxelGridHU)
    % Funzione per visualizzare la CT slice per slice con uno slider
    % INPUT: voxelGridHU - griglia 3D dei valori HU

    % Dimensioni della CT
    dim = size(voxelGridHU);
    nz = dim(3);

    % Creazione della figura
    hFig = figure('Name', 'Visualizzazione CT', 'NumberTitle', 'off', ...
        'Position', [100, 100, 800, 600]);
    hAx = axes('Parent', hFig, 'Position', [0.1, 0.2, 0.7, 0.7]);

    % Slider per la navigazione
    hSlider = uicontrol('Parent', hFig, 'Style', 'slider', ...
        'Min', 1, 'Max', nz, 'Value', round(nz/2), ...
        'Units', 'normalized', 'Position', [0.1, 0.05, 0.7, 0.05], ...
        'SliderStep', [1/(nz-1), 1/(nz-1)]);

    % Aggiungi callback per aggiornare la visualizzazione
    addlistener(hSlider, 'ContinuousValueChange', @(src, evt) aggiornaSlice());

    % Visualizza la slice iniziale
    aggiornaSlice();

    % Funzione interna per aggiornare la slice
    function aggiornaSlice()
        slice_idx = round(get(hSlider, 'Value'));
        slice_data = voxelGridHU(:, :, slice_idx);

        % Visualizza la slice con una scala di valori HU
        imagesc(hAx, slice_data, [-1000, 2000]); % Scala HU tipica
        colormap(hAx, 'gray'); % Scala di grigi
        cb = colorbar('Peer', hAx);
        cb.Label.String = 'Valori HU';
        axis(hAx, 'equal', 'tight');
        title(hAx, sprintf('CT - Slice %d', slice_idx));
        xlabel(hAx, 'X');
        ylabel(hAx, 'Y');
    end
end

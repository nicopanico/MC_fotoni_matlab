function visualizzaMaterialGridDinamica(material_grid, materiali)
    % Visualizzazione migliorata della Material Grid con colori predefiniti.

    % Dimensioni della griglia e numero di slice
    dim = size(material_grid);
    nz = dim(3);

    % Creazione della figura
    hFig = figure('Name', 'Material Grid Viewer', 'NumberTitle', 'off', ...
        'Position', [100, 100, 1000, 700]);
    hAx = axes('Parent', hFig, 'Position', [0.1, 0.2, 0.7, 0.7]);

    % Slider per navigare tra le slice
    hSlider = uicontrol('Parent', hFig, 'Style', 'slider', ...
        'Min', 1, 'Max', nz, 'Value', round(nz/2), ...
        'Units', 'normalized', 'Position', [0.1, 0.05, 0.7, 0.05], ...
        'SliderStep', [1/(nz-1), 1/(nz-1)]);

    % Colori predefiniti per ogni materiale
    num_mat = numel(materiali);
    custom_cmap = [
        0.9, 0.9, 0.9;   % Grigio chiaro per materiale assente (0)
        0, 0.6, 1;       % Aria - Azzurro
        1, 0.6, 0.6;     % Tessuto molle - Rosa
        1, 1, 0;         % Osso corticale - Giallo
        0.5, 0.2, 0.1;   % Fegato - Marrone scuro
        0, 0.8, 0.2;     % Polmoni - Verde
        1, 0.8, 0.6;     % Grasso - Beige
        0.6, 0.2, 0.8;   % Muscolo scheletrico - Viola
        0.8, 0.5, 0;     % Osso spongioso - Arancione
        0.2, 0.6, 0.3;   % Rene - Verde scuro
        0.4, 0.4, 1;     % Liquido cerebrospinale - Blu chiaro
        0.8, 0, 0;       % Sangue coagulato - Rosso scuro
        0, 0.5, 1;       % Acqua - Blu
    ];

    % Assicurati che la colormap abbia dimensione corretta
    num_colors = size(custom_cmap, 1);
    if num_colors < num_mat + 1
        warning('Numero di colori insufficienti per i materiali.');
        custom_cmap = [custom_cmap; rand(num_mat + 1 - num_colors, 3)];
    end

    % Aggiungi callback per lo slider
    addlistener(hSlider, 'ContinuousValueChange', @(src, evt) aggiornaSlice());

    % Mostra la slice iniziale
    aggiornaSlice();

    % Funzione di callback
    function aggiornaSlice()
        slice_idx = round(get(hSlider, 'Value'));
        slice_data = material_grid(:, :, slice_idx);

        % Visualizza la slice con colormap personalizzata
        imagesc(hAx, slice_data);
        axis(hAx, 'equal', 'tight');
        colormap(hAx, custom_cmap);
        caxis([0, num_mat + 1]);
        title(hAx, sprintf('Material Grid - Slice %d', slice_idx));
        xlabel(hAx, 'X');
        ylabel(hAx, 'Y');

        % Aggiorna la legenda
        hl = findobj(hFig, 'Type', 'Legend');
        if ~isempty(hl), delete(hl); end

        % Trova i materiali presenti nella slice
        mat_present = unique(slice_data(:));
        mat_present(mat_present == 0) = []; % Escludi materiale 0 (vuoto)

        % Crea legenda
        hold(hAx, 'on');
        h_patch = [];
        legend_strings = {};
        for mm = mat_present'
            hp = plot(hAx, NaN, NaN, 's', 'MarkerSize', 10, ...
                'MarkerFaceColor', custom_cmap(mm+1, :), ...
                'MarkerEdgeColor', custom_cmap(mm+1, :));
            h_patch(end+1) = hp; %#ok<AGROW>
            legend_strings{end+1} = sprintf('ID %d: %s', mm, materiali(mm).Nome); %#ok<AGROW>
        end
        legend(hAx, h_patch, legend_strings, 'Location', 'eastoutside');
        hold(hAx, 'off');
    end
end


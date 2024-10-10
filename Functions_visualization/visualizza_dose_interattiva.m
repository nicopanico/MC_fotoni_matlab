function visualizza_dose_interattiva(dose_grid, dose_unit)
    % Function to visualize the dose grid interactively with a slider along Z-axis
    % Input:
    %   dose_grid: 3D grid of the accumulated dose
    %   dose_unit: unit of dose (e.g., 'Gy')

    % Imposta la finestra di visualizzazione
    figure;
    
    % Ottieni le dimensioni della griglia di dose
    [Nx, Ny, Nz] = size(dose_grid);

    % Imposta il primo piano XY da visualizzare (fetta iniziale)
    slice_idx = round(Nz / 2);  % Inizia dal piano centrale
    h_image = imagesc(squeeze(dose_grid(:, :, slice_idx)));  % Visualizza la fetta XY
    colormap jet;
    colorbar;
    title(['Dose Slice Z = ', num2str(slice_idx), ' (', dose_unit, ')']);
    xlabel('X');
    ylabel('Y');
    
    % Crea uno slider per spostarsi lungo l'asse Z
    h_slider = uicontrol('Style', 'slider', 'Min', 1, 'Max', Nz, 'Value', slice_idx, ...
                         'Units', 'normalized', 'Position', [0.2 0.02 0.6 0.04], ...
                         'SliderStep', [1/(Nz-1) , 10/(Nz-1)]);
    addlistener(h_slider, 'Value', 'PostSet', @(src, event) update_slice(h_image, dose_grid, round(get(h_slider, 'Value')), dose_unit));
end

function update_slice(h_image, dose_grid, slice_idx, dose_unit)
    % Funzione per aggiornare la visualizzazione della fetta quando si sposta lo slider
    % Input:
    %   h_image: handle dell'immagine visualizzata
    %   dose_grid: griglia 3D della dose
    %   slice_idx: indice della fetta da visualizzare
    %   dose_unit: unità di misura della dose (ad es., 'Gy')

    % Aggiorna i dati visualizzati con la nuova fetta XY corrispondente
    set(h_image, 'CData', squeeze(dose_grid(:, :, slice_idx)));
    title(['Dose Slice Z = ', num2str(slice_idx), ' (', dose_unit, ')']);
end

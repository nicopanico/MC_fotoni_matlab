function visualizza_dose(dose_grid, dose_threshold, show_slices)
    % Function to visualize the accumulated dose in 3D and optionally in 2D slices
    % Input:
    %   dose_grid: 3D grid of the accumulated dose
    %   dose_threshold: dose threshold for isosurface visualization
    %   show_slices: boolean value (true/false) to show or hide 2D slices

    % ---------------------------
    % 3D Heatmap of the Dose Accumulation
    % ---------------------------
    % Trova i voxel con dose non nulla
    [x, y, z] = ind2sub(size(dose_grid), find(dose_grid > dose_threshold));
    dose_values = dose_grid(dose_grid > dose_threshold);

    % Visualizzazione Heatmap 3D
    figure;
    scatter3(x, y, z, 36, dose_values, 'filled');  % Scatter plot 3D con colori per la dose
    colorbar;  % Aggiunge una barra dei colori per rappresentare i livelli di dose
    colormap jet;  % Usa 'jet' per blu -> rosso (blu bassa dose, rosso alta dose)
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('3D Heatmap della Dose Accumulata');
    axis equal;  % Mantiene proporzioni uguali sugli assi

    % ---------------------------
    % Optional 2D Slices
    % ---------------------------
    if show_slices
        figure;
        subplot(1,3,1);
        slice(dose_grid, size(dose_grid,1)/2, [], []);  % Slice lungo X
        shading interp;
        colormap jet;  % Usa 'jet' anche per le sezioni 2D
        colorbar;
        title('Sezione 2D lungo Asse X');
        xlabel('X');
        ylabel('Y');
        zlabel('Z');

        subplot(1,3,2);
        slice(dose_grid, [], size(dose_grid,2)/2, []);  % Slice lungo Y
        shading interp;
        colormap jet;  % Usa 'jet' anche per le sezioni 2D
        colorbar;
        title('Sezione 2D lungo Asse Y');
        xlabel('X');
        ylabel('Y');
        zlabel('Z');

        subplot(1,3,3);
        slice(dose_grid, [], [], size(dose_grid,3)/2);  % Slice lungo Z
        shading interp;
        colormap jet;  % Usa 'jet' anche per le sezioni 2D
        colorbar;
        title('Sezione 2D lungo Asse Z');
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
    end
end


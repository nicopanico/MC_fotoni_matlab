function visualizza_dose_TPS(dose_grid, dose_threshold, dose_unit)
    % Function to visualize the accumulated dose similar to TPS clinical systems
    % Input:
    %   dose_grid: 3D grid of the accumulated dose
    %   dose_threshold: dose threshold for the minimum visualized dose
    %   dose_unit: unit of dose (e.g., 'Gy')

    % ---------------------------
    % 2D Slice Visualization with Isodose Curves (TPS style)
    % ---------------------------
    figure;
    
    % Definisci i livelli di isodose (es. dal 10% fino al 100% della dose massima)
    max_dose = max(dose_grid(:));
    isodose_levels = max_dose * (0.1:0.1:1);  % Livelli dal 10% al 100%

    % Slice lungo gli assi X, Y, Z con curve isodose
    subplot(1,3,1);
    slice_Z = squeeze(dose_grid(:, :, round(size(dose_grid, 3) / 2)));  % Sezione Z
    imagesc(log10(slice_Z + eps));  % Visualizza in scala logaritmica
    colormap jet;
    colorbar;
    hold on;
    % Aggiungi le curve di isodosi solo se la dose non è costante
    if range(slice_Z(:)) > 0
        contour(log10(slice_Z + eps), isodose_levels, 'LineColor', 'k');  % Visualizza le curve isodosi in scala logaritmica
    end
    hold off;
    title(['Slice Z - Log10 Dose in ', dose_unit]);
    xlabel('X');
    ylabel('Y');
    
    subplot(1,3,2);
    slice_Y = squeeze(dose_grid(:, round(size(dose_grid, 2) / 2), :));  % Sezione Y
    imagesc(log10(slice_Y + eps));  % Scala logaritmica
    colormap jet;
    colorbar;
    hold on;
    if range(slice_Y(:)) > 0
        contour(log10(slice_Y + eps), isodose_levels, 'LineColor', 'k');  % Visualizza le curve isodosi in scala logaritmica
    end
    hold off;
    title(['Slice Y - Log10 Dose in ', dose_unit]);
    xlabel('X');
    ylabel('Z');
    
    subplot(1,3,3);
    slice_X = squeeze(dose_grid(round(size(dose_grid, 1) / 2), :, :));  % Sezione X
    imagesc(log10(slice_X + eps));  % Scala logaritmica
    colormap jet;
    colorbar;
    hold on;
    if range(slice_X(:)) > 0
        contour(log10(slice_X + eps), isodose_levels, 'LineColor', 'k');  % Visualizza le curve isodosi in scala logaritmica
    end
    hold off;
    title(['Slice X - Log10 Dose in ', dose_unit]);
    xlabel('Y');
    ylabel('Z');
    
    % ---------------------------
    % 3D Isosurface Visualization with Heatmap Coloring
    % ---------------------------
    figure;
    
    % Genera l'isosuperficie
    [faces, verts] = isosurface(dose_grid, dose_threshold);
    
    % Interpolazione della dose sui vertici
    vert_dose_values = interp3(dose_grid, verts(:,1), verts(:,2), verts(:,3), 'linear');
    
    % Usa scala logaritmica per la dose sui vertici
    vert_dose_values_log = log10(vert_dose_values + eps);
    
    % Crea il patch dell'isosuperficie
    p = patch('Faces', faces, 'Vertices', verts, 'FaceVertexCData', vert_dose_values_log, 'FaceColor', 'interp', 'EdgeColor', 'none');
    
    % Applica la colormap 'jet' per blu -> rosso
    colormap jet;
    
    % Imposta i limiti della colorbar per la scala logaritmica
    caxis([min(vert_dose_values_log), max(vert_dose_values_log)]);
    
    colorbar;
    daspect([1 1 1]);
    view(3);
    camlight;
    lighting gouraud;
    title(['3D Isosurface Log10 Dose in ', dose_unit]);
end



function visualizza_dose_TPS(dose_grid, dose_threshold, dose_unit)
    % Function to visualize the accumulated dose similar to TPS clinical systems
    % Input:
    %   dose_grid: 3D grid of the accumulated dose
    %   dose_threshold: dose threshold for the minimum visualized dose
    %   dose_unit: unit of dose (e.g., 'Gy')

    % ---------------------------
    % 2D Slice Visualization (Similar to TPS)
    % ---------------------------
    figure;
    
    % Definisci i livelli di isodose (per esempio, 10% fino a 100% della dose massima)
    max_dose = max(dose_grid(:));
    isodose_levels = max_dose * (0.1:0.1:1);  % Livelli dal 10% al 100%

    % Slice lungo gli assi X, Y, Z con isodose
    subplot(1,3,1);
    imagesc(squeeze(dose_grid(:, :, round(size(dose_grid, 3) / 2))));  % Sezione trasversale Z
    colormap jet;
    colorbar;
    hold on;
    contour(squeeze(dose_grid(:, :, round(size(dose_grid, 3) / 2))), isodose_levels, 'LineColor', 'k');
    hold off;
    title(['Slice lungo Z - Dose in ', dose_unit]);
    xlabel('X');
    ylabel('Y');
    
    subplot(1,3,2);
    imagesc(squeeze(dose_grid(:, round(size(dose_grid, 2) / 2), :)));  % Sezione trasversale Y
    colormap jet;
    colorbar;
    hold on;
    contour(squeeze(dose_grid(:, round(size(dose_grid, 2) / 2), :)), isodose_levels, 'LineColor', 'k');
    hold off;
    title(['Slice lungo Y - Dose in ', dose_unit]);
    xlabel('X');
    ylabel('Z');
    
    subplot(1,3,3);
    imagesc(squeeze(dose_grid(round(size(dose_grid, 1) / 2), :, :)));  % Sezione trasversale X
    colormap jet;
    colorbar;
    hold on;
    contour(squeeze(dose_grid(round(size(dose_grid, 1) / 2), :, :)), isodose_levels, 'LineColor', 'k');
    hold off;
    title(['Slice lungo X - Dose in ', dose_unit]);
    xlabel('Y');
    ylabel('Z');
    
    % ---------------------------
    % 3D Volume Rendering of the Dose (optional)
    % ---------------------------
    figure;
    p = patch(isosurface(dose_grid, dose_threshold));
    isonormals(dose_grid, p);
    p.FaceColor = 'red';
    p.EdgeColor = 'none';
    daspect([1 1 1]);
    view(3);
    camlight;
    lighting gouraud;
    colorbar;
    title(['Isosuperficie della Dose in ', dose_unit]);
end

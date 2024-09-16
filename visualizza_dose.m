function visualizza_dose(dose_grid, dose_threshold)
    % Function to visualize the accumulated dose in 3D and 2D sections
    % Input:
    %   dose_grid: 3D grid of the accumulated dose
    %   dose_threshold: dose threshold for isosurface visualization

    % ---------------------------
    % 3D Isosurface Visualization
    % ---------------------------
    figure;
    p = patch(isosurface(dose_grid, dose_threshold));  % Generate the isosurface
    isonormals(dose_grid, p);  % Add normals for better rendering
    p.FaceColor = 'red';  % Color of the surface
    p.EdgeColor = 'none';  % Remove the edges
    daspect([1 1 1]);  % Keep axis proportions
    view(3);  % Set the view to 3D
    axis tight;  % Tighten the axis
    camlight;  % Add light for better visualization
    lighting gouraud;  % Set lighting style
    title('Accumulated Dose Isosurface');
    colorbar;  % Add a colorbar to represent dose values

    % ---------------------------
    % 2D Slice Visualization along X, Y, Z axes
    % ---------------------------
    figure;
    subplot(1,3,1);
    slice(dose_grid, size(dose_grid,1)/2, [], []);  % Slice along X axis
    shading interp;
    colormap jet;
    colorbar;
    title('2D Slice along X axis');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');

    subplot(1,3,2);
    slice(dose_grid, [], size(dose_grid,2)/2, []);  % Slice along Y axis
    shading interp;
    colormap jet;
    colorbar;
    title('2D Slice along Y axis');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');

    subplot(1,3,3);
    slice(dose_grid, [], [], size(dose_grid,3)/2);  % Slice along Z axis
    shading interp;
    colormap jet;
    colorbar;
    title('2D Slice along Z axis');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
end


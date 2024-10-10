function distribuisci_energia_voxel(grid, posizione, energia, kernel)
    % Funzione che distribuisce l'energia depositata tra più voxel usando un kernel di diffusione
    % Input:
    %   grid: griglia tridimensionale di voxel
    %   posizione: posizione del voxel centrale
    %   energia: energia depositata
    %   kernel: kernel di diffusione (matrice 3D)
    
    [dx, dy, dz] = size(kernel);  % Dimensioni del kernel
    
    % Calcola la distribuzione dell'energia nei voxel circostanti
    for i = 1:dx
        for j = 1:dy
            for k = 1:dz
                % Applica il kernel moltiplicando l'energia
                grid(posizione(1)+i, posizione(2)+j, posizione(3)+k) = grid(posizione(1)+i, posizione(2)+j, posizione(3)+k) + energia * kernel(i,j,k);
            end
        end
    end
end
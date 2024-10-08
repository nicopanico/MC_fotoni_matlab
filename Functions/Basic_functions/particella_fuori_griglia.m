function fuori = particella_fuori_griglia(posizione, grid_size)
    fuori = (posizione(1) < 1 || posizione(1) > grid_size(1)) || ...
            (posizione(2) < 1 || posizione(2) > grid_size(2)) || ...
            (posizione(3) < 1 || posizione(3) > grid_size(3));
end
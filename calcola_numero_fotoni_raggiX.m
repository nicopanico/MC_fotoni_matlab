function N_fotoni = calcola_numero_fotoni_raggiX(kVp, mAs, distanza)
    % Calcola il numero totale di fotoni per raggi X diagnostici
    N_fotoni_base = kVp^2 * mAs;  % Numero di fotoni approssimato
    N_fotoni = N_fotoni_base / (distanza^2);  % Fluence considerando la distanza
end
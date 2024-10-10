function N_fotoni = calcola_numero_fotoni_gamma(MV, distanza)
    % Calcola il numero totale di fotoni per sorgenti gamma terapeutiche
    N_fotoni_base = MV^2 * 1e8;  % Numero di fotoni approssimato per gamma (stimato)
    N_fotoni = N_fotoni_base / (distanza^2);  % Fluence considerando la distanza
end
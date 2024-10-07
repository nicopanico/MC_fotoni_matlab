% Funzione per interpolare i coefficienti dai dati tabulati (aggiornata)
function [mu_fotoelettrico, mu_compton, mu_pair_production] = coefficiente_attenuazione_tab(energia, energia_tab, mu_fotoelettrico_tab, mu_compton_tab, mu_pair_production_tab)
     % Rimuovi eventuali duplicati dalle energie e dai coefficienti associati
    [energia_unica, idx] = unique(energia_tab, 'stable');  % Rimuovi energie duplicate, mantieni l'ordine originale
    
    % Applica la stessa selezione agli altri coefficienti in base all'indice unico
    mu_fotoelettrico_unico = mu_fotoelettrico_tab(idx);
    mu_compton_unico = mu_compton_tab(idx);
    mu_pair_production_unico = mu_pair_production_tab(idx);

    % Interpolazione lineare per trovare i coefficienti a un'energia specifica
    mu_fotoelettrico = interp1(energia_unica, mu_fotoelettrico_unico, energia, 'linear', 'extrap');
    mu_compton = interp1(energia_unica, mu_compton_unico, energia, 'linear', 'extrap');
    mu_pair_production = interp1(energia_unica, mu_pair_production_unico, energia, 'linear', 'extrap');

end
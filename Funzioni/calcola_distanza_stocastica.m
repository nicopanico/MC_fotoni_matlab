function [varargout] = calcola_distanza_stocastica(energia, materiale)
    % Simula la distanza percorsa da un elettrone con un metodo stocastico e variazione del potere frenante
    % Input:
    %   energia: energia residua dell'elettrone (MeV)
    %   materiale: tipo di materiale (aria, tessuto, osso)
    %
    % Output:
    %   distanza_percorsa: distanza percorsa dall'elettrone
    %   mean_free_path: cammino libero medio (in cm)
    %   scattering_factor: fattore di correzione per il multiple scattering

    % Ottieni il potere frenante (stopping power) in funzione dell'energia e del materiale
    stopping_power = ottieni_stopping_power(energia, materiale);

    % Calcola il cammino libero medio in funzione del potere frenante
    mean_free_path = 1 / stopping_power;  % Mean free path in cm
    varargout{2} = mean_free_path;  % Assign the mean free path as the second output

    % Applica un fattore di correzione per il multiple scattering (Molière theory)
    % Questo fattore aumenta la distanza percorsa considerando la diffusione angolare
    scattering_factor = normrnd(1, 0.2);  % Gaussian variation (mean 1, std. dev 0.2)
    varargout{3} = scattering_factor;  % Assign scattering factor as the third output

    % Calcola la distanza stocastica solo se richiesto
    if calcola_distanza
       % Simula la distanza percorsa usando una distribuzione esponenziale stocastica
       % per il cammino libero medio
        distanza_percorsa = -mean_free_path * log(rand());

        % Applica il fattore di correzione per multiple scattering
        distanza_percorsa = distanza_percorsa * scattering_factor;

        % Assicura che la distanza non sia negativa
        varargout{1} = max(0, distanza_percorsa);  % First output is stochastic distance
    else
        varargout{1} = [];  % Nessuna distanza stocastica se non richiesta
    end
end

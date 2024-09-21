function distanza_percorsa = calcola_distanza_stocastica(energia, materiale)
    % Simula la distanza percorsa da un elettrone con un metodo stocastico e variazione del potere frenante
    % Input:
    %   energia: energia residua dell'elettrone (MeV)
    %   materiale: tipo di materiale (aria, tessuto, osso)
    %
    % Output:
    %   distanza_percorsa: distanza percorsa dall'elettrone

    % Ottieni il potere frenante (stopping power) in funzione dell'energia e del materiale
    stopping_power = ottieni_stopping_power(energia, materiale);

    % Calcola il cammino libero medio in funzione del potere frenante e dell'energia
    mean_free_path = 1 / stopping_power;  % Cammino libero medio
    
    % Simula la distanza percorsa usando una distribuzione esponenziale stocastica
    % per il cammino libero medio e includi variazione casuale
    distanza_percorsa = -mean_free_path * log(rand());

    % Applica un fattore di correzione per il multiple scattering (Molière theory)
    % Questo fattore aumenta la distanza percorsa considerando la diffusione angolare
    scattering_factor = normrnd(1, 0.2);  % Variazione gaussiana (valore medio 1, dev. standard 0.2)
    distanza_percorsa = distanza_percorsa * scattering_factor;

    % Assicura che la distanza non sia negativa
    distanza_percorsa = max(0, distanza_percorsa);
end
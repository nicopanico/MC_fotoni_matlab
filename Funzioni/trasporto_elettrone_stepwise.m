function [nuova_posizione, nuova_direzione, energia_residua] = trasporto_elettrone_stepwise(posizione_iniziale, direzione_iniziale, energia_iniziale, materiale, passo, stopping_power, scattering_angle_std)
    % Funzione per simulare il trasporto di un elettrone in maniera step-wise
    % Input:
    %   posizione_iniziale: [x, y, z] posizione iniziale dell'elettrone
    %   direzione_iniziale: [dx, dy, dz] vettore unitario della direzione dell'elettrone
    %   energia_iniziale: energia iniziale dell'elettrone (in MeV)
    %   materiale: tipo di materiale (aria, tessuto, osso)
    %   passo: lunghezza del singolo step (in cm)
    %   stopping_power: potere frenante del materiale per quell'energia
    %   scattering_angle_std: deviazione standard dell'angolo di scattering (in radianti)
    %
    % Output:
    %   nuova_posizione: posizione aggiornata dopo lo step
    %   nuova_direzione: direzione aggiornata dopo lo scattering
    %   energia_residua: energia rimanente dopo aver percorso lo step
    
    % Calcolo della nuova posizione
    nuova_posizione = posizione_iniziale + direzione_iniziale * passo;

    % Simula lo scattering angolare
    theta = normrnd(0, scattering_angle_std); % Scattering in direzione casuale
    phi = 2 * pi * rand();  % Angolo casuale nel piano orizzontale

    % Aggiorna la direzione in base agli angoli di scattering
    nuova_direzione = [sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta)];

    % Calcola l'energia residua riducendola in base al potere frenante e alla distanza percorsa
    energia_depositata = min(energia_iniziale, stopping_power * passo);
    energia_residua = energia_iniziale - energia_depositata;
    
    if energia_residua < 0
        energia_residua = 0;  % L'elettrone è assorbito
    end
end
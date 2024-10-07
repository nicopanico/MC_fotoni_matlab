function probabilita_bremsstrahlung = calcola_probabilita_bremsstrahlung(energia, materiale)
    % Probabilità stocastica di emissione Bremsstrahlung, dipende dall'energia e dal materiale
    % Questi parametri sono semplificati e possono essere migliorati in base ai dati fisici del materiale
    if energia > 1  % Maggiore probabilità per energie elevate
        probabilita_bremsstrahlung = 0.1;  % 10% di probabilità
    else
        probabilita_bremsstrahlung = 0.01;  % 1% di probabilità
    end
end
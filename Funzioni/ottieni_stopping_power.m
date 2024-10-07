function stopping_power = ottieni_stopping_power(energia, materiale)
    % Restituisce il potere frenante in MeV/cm in base al materiale e all'energia
    switch materiale
        case 'aria'
            if energia < 0.5
                stopping_power = 2.02;  % Potere frenante per aria a 0.1 MeV
            elseif energia < 5
                stopping_power = 1.82;  % Potere frenante per aria a 1 MeV
            else
                stopping_power = 1.73;  % Potere frenante per aria a 10 MeV
            end
        case 'tessuto'
            if energia < 0.5
                stopping_power = 2.00;  % Potere frenante per tessuto a 0.1 MeV
            elseif energia < 5
                stopping_power = 1.55;  % Potere frenante per tessuto a 1 MeV
            else
                stopping_power = 1.35;  % Potere frenante per tessuto a 10 MeV
            end
        case 'osso'
            if energia < 0.5
                stopping_power = 2.90;  % Potere frenante per osso a 0.1 MeV
            elseif energia < 5
                stopping_power = 2.40;  % Potere frenante per osso a 1 MeV
            else
                stopping_power = 1.95;  % Potere frenante per osso a 10 MeV
            end
        otherwise
            error('Materiale non riconosciuto.');
    end
end

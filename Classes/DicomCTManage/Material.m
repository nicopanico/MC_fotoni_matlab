classdef Material
    properties
        Nome           % Nome del materiale
        Densita        % Densità in g/cm³
        EnergiaLegame  % Energia di legame in MeV
        Priority       % Priorità del tessuto
    end
    
    methods
        function obj = Material(nome, densita, energia_legame, priority)
            % Costruttore della classe Material
            obj.Nome = nome;
            obj.Densita = densita;
            obj.EnergiaLegame = energia_legame;
            obj.Priority = priority;
        end
        
        function stopping_power = getStoppingPower(obj, energia)
            % Restituisce il potere frenante in MeV/cm in base al materiale e all'energia
            switch obj.Nome
                case 'aria'
                    if energia < 0.5
                        stopping_power = 2.02;
                    elseif energia < 5
                        stopping_power = 1.82;
                    else
                        stopping_power = 1.73;
                    end
                case 'tessuto_molle'
                    if energia < 0.5
                        stopping_power = 2.00;
                    elseif energia < 5
                        stopping_power = 1.55;
                    else
                        stopping_power = 1.35;
                    end
                case 'osso_corticale'
                    if energia < 0.5
                        stopping_power = 2.90;
                    elseif energia < 5
                        stopping_power = 2.40;
                    else
                        stopping_power = 1.95;
                    end
                otherwise
                    error('Materiale non riconosciuto.');
            end
        end
    end
    
    methods (Static)
        function materiali = definisciTuttiMateriali()
            % Definiamo le priorità in base alla rilevanza:
            % Esempio: aria e osso corticale con priorità più alta,
            % tessuti intermedi con priorità media, ecc.
            materiali = [
                Material('aria', 0.0012, 0.000, 10),
                Material('tessuto_molle', 1.002, 0.0000753, 5),
                Material('osso_corticale', 1.85, 0.0001064, 10),
                Material('fegato', 1.06, 0.0000753, 7),
                Material('polmoni', 0.26, 0.0000752, 9),
                Material('grasso', 0.92, 0.0000632, 8),
                Material('cervello', 1.04, 0.0000753, 6),   % Approssima sost. grigia/bianca
                Material('muscolo_scheletrico', 1.052, 0.0000746, 6),
                Material('midollo_osseo', 1.03, 0.0000753, 6),
                Material('pelle', 1.1, 0.0000753, 6),
                Material('osso_spongioso', 1.10, 0.0000900, 9),
                Material('rene', 1.05, 0.0000732, 7),
                Material('milza', 1.05, 0.0000732, 6),
                Material('cuore', 1.051, 0.0000732, 6),
                Material('midollo_spinale', 1.031, 0.0000753, 6),
                Material('liquido_cerebrospinale', 1.001, 0.0000753, 5),
                Material('sangue_coagulato', 1.06, 0.0000753, 5),
                Material('sangue_non_coagulato', 1.05, 0.0000753, 5),
                Material('sostanza_bianca', 1.03, 0.0000753, 6),
                Material('sostanza_grigia', 1.04, 0.0000753, 6),
                Material('acqua', 1.00, 0.0000753, 5)
            ];
        end
    end
end

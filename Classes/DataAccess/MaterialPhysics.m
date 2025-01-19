classdef MaterialPhysics
    properties
        NomeMateriale           % Nome del materiale
        Densita                % Densità (g/cm³)
        CoefficientiAttenuazione % Struttura: energie, mu_rho (fotoelettrico, compton, coppie)
        StoppingPower          % Struttura: energie, stopping power
    end

    methods
        function obj = MaterialPhysics(nome, densita, coeff)
            % Costruttore della classe
            obj.NomeMateriale = nome;
            obj.Densita = densita;
            obj.CoefficientiAttenuazione = coeff;
        end
        
        function mu = getAttenuationCoefficients(obj, energia)
            % Restituisce \mu (coefficiente di attenuazione lineare) per un'energia specifica
            energieTab = obj.CoefficientiAttenuazione.energie;
            mu_rho = obj.CoefficientiAttenuazione.mu_rho;
            mu_rho_interpolati = structfun(@(v) interp1(energieTab, v, energia, 'linear', 'extrap'), ...
                mu_rho, 'UniformOutput', false);
            mu = structfun(@(v) v * obj.Densita, mu_rho_interpolati, 'UniformOutput', false); % Da mu/rho a mu
        end
        
        function sp = getStoppingPower(obj, energia)
            % Restituisce la stopping power per un'energia specifica
            if isempty(obj.StoppingPower)
                error('Stopping power non definita per questo materiale.');
            end
            energieTab = obj.StoppingPower.energie;
            spTab = obj.StoppingPower.values;
            sp = interp1(energieTab, spTab, energia, 'linear', 'extrap');
        end
    end

     methods (Static)
         function materialiPhysics = caricaMaterialiDaFile(filepath, materiali_base)
             % Caricamento dei coefficienti di attenuazione da file Excel
             disp('Caricamento delle cross sections...');
             sheetNames = sheetnames(filepath);  % Legge i nomi dei fogli

             % Inizializza l'array come vuoto del tipo MaterialPhysics
             materialiPhysics = MaterialPhysics.empty;

             for i = 1:numel(sheetNames)
                 nome = sheetNames{i};
                 % Cerca il materiale nella lista di base
                 idx = find(strcmp({materiali_base.Nome}, nome), 1);
                 if isempty(idx)
                     fprintf('Materiale "%s" non trovato, ignorato.\n', nome);
                     continue;
                 end

                 % Legge i dati dal foglio Excel
                 opts = detectImportOptions(filepath, 'Sheet', nome);
                 opts.DataRange = '4:1000'; % Salta le righe vuote e legge i dati
                 data = readtable(filepath, opts);

                 if all(ismember({'Energy', 'Compton', 'Photoel', 'Pair'}, data.Properties.VariableNames))
                     energie = data.Energy;
                     mu_rho = struct('fotoelettrico', data.Photoel, ...
                         'compton', data.Compton, ...
                         'coppie', data.Pair);
                 else
                     error('Colonne mancanti nel foglio "%s".', nome);
                 end

                 % Crea l'oggetto MaterialPhysics e aggiungilo all'array
                 materialiPhysics(end+1) = MaterialPhysics(materiali_base(idx).Nome, ...
                     materiali_base(idx).Densita, ...
                     struct('energie', energie, 'mu_rho', mu_rho)); %#ok<AGROW>

                 fprintf('Cross sections per "%s" caricate.\n', nome);
             end
         end
     end
end



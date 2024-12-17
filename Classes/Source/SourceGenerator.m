classdef SourceGenerator
    properties
        tipo_radionuclide
        num_particelle
        volume
        material_grid
        materiali
        geometry_type
        geometry_params
        attivita_iniziale % Attività iniziale della sorgente (in Bq)
    end

    methods
        function obj = SourceGenerator(tipo_radionuclide, num_particelle, volume, material_grid, materiali, geometry_type, geometry_params, attivita_iniziale)
            % Costruttore
            obj.tipo_radionuclide = tipo_radionuclide;
            obj.num_particelle = num_particelle;
            obj.volume = volume;
            obj.material_grid = material_grid;
            obj.materiali = materiali;
            obj.geometry_type = geometry_type;
            obj.geometry_params = geometry_params;
            obj.attivita_iniziale = attivita_iniziale;
        end

        function sorgente = defineSource(obj)
            % Metodo principale per definire la sorgente
            data = obj.RadionuclideData(obj.tipo_radionuclide);

            % Generazione degli spettri
            spettro_elettroni = obj.sampleBetaSpectrum(data.Emax_beta, obj.num_particelle);
            spettro_fotoni = obj.sampleGammaLines(data.gamma_energies, data.gamma_prob, obj.num_particelle);
            spettro_alfa = obj.sampleAlphaSpectrum(data.alpha_energies, obj.num_particelle);

            % Posizioni e direzioni
            posizioni = obj.generateSourcePositions(obj.num_particelle, obj.volume, obj.material_grid, obj.materiali, obj.geometry_type, obj.geometry_params);
            direzioni = obj.generateIsotropicDirections(obj.num_particelle);

            % Salva nella sorgente
            sorgente.tipo = obj.tipo_radionuclide;
            sorgente.spettro_elettroni = spettro_elettroni;
            sorgente.spettro_fotoni = spettro_fotoni;
            sorgente.spettro_alfa = spettro_alfa;
            sorgente.posizione = posizioni;
            sorgente.direzione = direzioni;
            sorgente.attivita = obj.attivita_iniziale;
        end

        function visualizzaSpettroCompleto(obj, sorgente)
            % Visualizza lo spettro completo Beta + Gamma usando la struttura sorgente

            % Estrai lo spettro beta e gamma dalla sorgente
            spettro_elettroni = sorgente.spettro_elettroni;
            spettro_fotoni = sorgente.spettro_fotoni;

            figure;
            % Calcola l'intensità normalizzata del beta (spettro continuo)
            edges = linspace(0, max(spettro_elettroni), 50); % 50 bin per lo spettro beta
            counts_beta = histcounts(spettro_elettroni, edges, 'Normalization', 'pdf');
            centers = (edges(1:end-1) + edges(2:end)) / 2; % Centri dei bin

            % Plot dell'istogramma Beta (intensità normalizzata)
            bar(centers, counts_beta, 'FaceAlpha', 0.6, 'EdgeColor', 'none', 'DisplayName', 'Spettro Beta (intensità)');
            hold on;

            % Curva smussata del beta (facoltativa per chiarezza)
            smoothed_beta = smooth(centers, counts_beta, 0.1, 'loess');
            plot(centers, smoothed_beta, 'b', 'LineWidth', 2, 'DisplayName', 'Smussatura Beta');

            % Calcolo e normalizzazione intensità delle linee Gamma
            gamma_energies = unique(spettro_fotoni);
            gamma_counts = histc(spettro_fotoni, gamma_energies);
            gamma_counts = gamma_counts / sum(gamma_counts) * max(counts_beta); % Normalizzato rispetto al beta

            % Plot delle linee Gamma
            offset_y = 0.1 * max(counts_beta); % Offset per evitare sovrapposizioni
            for i = 1:length(gamma_energies)
                energy = gamma_energies(i);
                intensity = gamma_counts(i);

                % Linea verticale per ogni picco gamma
                line([energy energy], [0 intensity], 'Color', 'r', 'LineWidth', 2, 'DisplayName', 'Picchi Gamma');

                % Posizionamento dell'etichetta con offset progressivo
                text(energy, intensity + offset_y * mod(i, 2), ...
                    sprintf('%.3f MeV', energy), ...
                    'Color', 'r', 'FontSize', 10, 'FontWeight', 'bold', ...
                    'HorizontalAlignment', 'center');
            end

            % Miglioramenti al grafico
            title(sprintf('Spettro Completo per %s', obj.tipo_radionuclide));
            xlabel('Energia (MeV)');
            ylabel('Intensità normalizzata (1/MeV)');
            legend({'Spettro Beta (intensità)', 'Smussatura Beta', 'Picchi Gamma'});
            grid on;
            hold off;
        end
    end

    methods (Access = private)
        function data = RadionuclideData(~, tipo_radionuclide)
            switch tipo_radionuclide
                case 'Fluoro-18'
                    data.Emax_beta = 0.633;
                    data.gamma_energies = [0.511];
                    data.gamma_prob = [1.93]; % Due fotoni per evento
                    data.alpha_energies = []; % Nessuna emissione alfa

                case 'Gallio-68'
                    data.Emax_beta = 1.899;
                    data.gamma_energies = [0.511, 1.077];
                    data.gamma_prob = [1.91, 0.0322];
                    data.alpha_energies = [];

                case 'Iodio-131'
                    data.Emax_beta = 0.606;
                    data.gamma_energies = [0.080, 0.284, 0.364, 0.503, 0.637, 0.723, 0.806, 0.884, 1.021];
                    data.gamma_prob = [0.026, 0.061, 0.817, 0.0036, 0.072, 0.018, 0.0048, 0.021, 0.0017];
                    data.alpha_energies = [];

                case 'Tecnezio-99m'
                    data.Emax_beta = [];
                    data.gamma_energies = [0.140];
                    data.gamma_prob = [0.89];
                    data.alpha_energies = [];

                case 'Lutetio-177'
                    data.Emax_beta = 0.498;
                    data.gamma_energies = [0.113, 0.208];
                    data.gamma_prob = [0.066, 0.11];
                    data.alpha_energies = [];

                case 'Iodio-123'
                    data.Emax_beta = [];
                    data.gamma_energies = [0.159];
                    data.gamma_prob = [0.83];
                    data.alpha_energies = [];

                case 'Radio-223'
                    data.Emax_beta = []; % Emettitore alfa
                    data.gamma_energies = [0.144, 0.154, 0.269];
                    data.gamma_prob = [0.043, 0.03, 0.14];
                    data.alpha_energies = [5.78, 5.84]; % Energie alfa in MeV per Ra-223

                otherwise
                    error('Radionuclide non supportato.');
            end
        end

        function E_beta = sampleBetaSpectrum(~, Emax, N)
            % Distribuzione di Fermi: P(E) ~ E^2 * (Emax - E)^2
            num_points = 2000;
            E = linspace(0, Emax, num_points);
            p = (E.^2 .* (Emax - E).^2);
            p = p / trapz(E, p);
            cdf = cumtrapz(E, p);
            r = rand(N, 1);
            E_beta = interp1(cdf, E, r, 'linear');
        end

        function E_gamma = sampleGammaLines(~, gamma_energies, gamma_prob, N)
            if isempty(gamma_energies)
                E_gamma = zeros(N, 1);
                return;
            end
            cdf = cumsum(gamma_prob);
            r = rand(N, 1);
            E_gamma = zeros(N, 1);
            for i = 1:N
                idx = find(cdf >= r(i), 1);
                E_gamma(i) = gamma_energies(idx);
            end
        end

        function E_alpha = sampleAlphaSpectrum(~, alpha_energies, N)
            % Metodo per generare energia alfa: distribuzione quasi fissa
            if isempty(alpha_energies)
                E_alpha = zeros(N, 1);
            else
                % Se più energie, seleziona una in modo casuale
                E_alpha = randsample(alpha_energies, N, true);
            end
        end

        function positions = generateSourcePositions(obj, N, volume, material_grid, materiali, geometry_type, geometry_params)
            dim = volume.Dimension;
            id_aria = find(strcmp({materiali.Nome}, 'aria'), 1);

            switch geometry_type
                case 'sfera'
                    pos_centro = geometry_params.posizione_centro;
                    raggio = geometry_params.raggio;
                    positions = zeros(N, 3);
                    for i = 1:N
                        dir = randn(1, 3);
                        dir = dir / norm(dir);
                        dist = raggio * (rand^(1/3));
                        pos = pos_centro + dist * dir;
                        positions(i, :) = round(pos);
                    end

                case 'in_paziente'
                    if isfield(geometry_params, 'materiali_target') && ~isempty(geometry_params.materiali_target)
                        target_names = geometry_params.materiali_target;
                        target_ids = [];
                        for tn = target_names
                            idx = find(strcmp({materiali.Nome}, tn{1}));
                            if ~isempty(idx)
                                target_ids(end+1) = idx; %#ok<AGROW>
                            end
                        end
                        if isempty(target_ids)
                            target_ids = 1:numel(materiali);
                            target_ids(target_ids == id_aria) = [];
                        end
                    else
                        target_ids = 1:numel(materiali);
                        target_ids(target_ids == id_aria) = [];
                    end

                    positions = zeros(N, 3);
                    found = 0;
                    while found < N
                        x = randi(dim(1));
                        y = randi(dim(2));
                        z = randi(dim(3));
                        mat_id = material_grid(x, y, z);
                        if any(mat_id == target_ids)
                            found = found + 1;
                            positions(found, :) = [x, y, z];
                        end
                    end
                otherwise
                    error('Geometria non supportata.');
            end
        end

        function directions = generateIsotropicDirections(~, N)
            theta = acos(1 - 2 * rand(N, 1));
            phi = 2 * pi * rand(N, 1);
            directions = zeros(N, 3);
            directions(:, 1) = sin(theta) .* cos(phi);
            directions(:, 2) = sin(theta) .* sin(phi);
            directions(:, 3) = cos(theta);
        end
    end
end


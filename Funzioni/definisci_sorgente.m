function sorgente = definisci_sorgente(tipo_radiazione, tipo_sorgente, kVp_o_MV, mAs, distanza)
    % Definisce i parametri della sorgente basata su input clinici
    % Input:
    %   tipo_sorgente: 'puntiforme', 'lineare'
    %   tipo_radiazione: 'raggiX' per diagnostica, 'gamma' per terapeutica
    %   kVp_o_MV: energia della sorgente (kVp per diagnostica, MV per terapeutica)
    %   mAs: milliampere-secondi per raggi X
    %   distanza: distanza dalla sorgente in cm
    % Output:
    %   sorgente: struttura con i parametri della sorgente
    sorgente.tipo_radiazione = tipo_radiazione;
    sorgente.tipo_sorgente = tipo_sorgente;
    sorgente.energia = kVp_o_MV;  % kVp per diagnostica, MV per gamma terapeutica
    sorgente.mAs = mAs;           % Applicabile solo a sorgenti a raggi X
    sorgente.distanza = distanza; % Distanza sorgente-target

    % Posizionamento della sorgente in base alla distanza e al tipo di sorgente
    if strcmp(sorgente.tipo_sorgente, 'puntiforme')
        sorgente.posizione = [50, 50, -distanza];  % Posiziona la sorgente a "distanza" cm lungo l'asse Z
    elseif strcmp(sorgente.tipo_sorgente, 'superficiale')
        sorgente.posizione = [1:100, 50, -distanza];  % Superficie estesa a "distanza" cm lungo Z
    elseif strcmp(sorgente.tipo_sorgente, 'lineare')
        sorgente.posizione = [50, 1:100, -distanza];  % Sorgente lineare lungo l'asse Y
    else
        error('Tipo di sorgente non supportato');
    end

    if strcmp(tipo_radiazione, 'raggiX')
        % Applica modello spettro energetico per raggi X
        spettro = definisci_spettro_raggiX(kVp_o_MV, false);  % false per non mostrare il grafico
        sorgente.spettro = spettro;
        sorgente.spettro_energetico = @(N) datasample(spettro.energia, N, 'Weights', spettro.intensita);
    elseif strcmp(tipo_radiazione, 'gamma')
        % Modello per raggi gamma terapeutici
        spettro = definisci_spettro_gamma(kVp_o_MV, false);
        sorgente.spettro = spettro;
        sorgente.spettro_energetico = @(N) datasample(spettro.energia, N, 'Weights', spettro.intensita);
    else
        error('Tipo di sorgente non supportato');
    end
end

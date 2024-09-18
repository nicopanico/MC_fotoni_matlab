function sorgente = definisci_sorgente(tipo_sorgente, kVp_o_MV, mAs, distanza)
    % Definisce i parametri della sorgente basata su input clinici
    % Input:
    %   tipo_sorgente: 'raggiX' per diagnostica, 'gamma' per terapeutica
    %   kVp_o_MV: energia della sorgente (kVp per diagnostica, MV per terapeutica)
    %   mAs: milliampere-secondi per raggi X
    %   distanza: distanza dalla sorgente in cm
    % Output:
    %   sorgente: struttura con i parametri della sorgente

    sorgente.tipo = tipo_sorgente;
    sorgente.energia = kVp_o_MV;  % kVp per diagnostica, MV per gamma terapeutica
    sorgente.mAs = mAs;           % Applicabile solo a sorgenti a raggi X
    sorgente.distanza = distanza; % Distanza sorgente-target

    if strcmp(tipo_sorgente, 'raggiX')
        % Applica modello spettro energetico per raggi X
        sorgente.spettro = definisci_spettro_raggiX(kVp_o_MV);
    elseif strcmp(tipo_sorgente, 'gamma')
        % Modello per raggi gamma terapeutici
        sorgente.spettro = definisci_spettro_gamma(kVp_o_MV);
    else
        error('Tipo di sorgente non supportato');
    end
end

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
        spettro = definisci_spettro_raggiX(kVp_o_MV, false);  % false per non mostrare il grafico
        sorgente.spettro_energetico = @(N) datasample(spettro.energia, N, 'Weights', spettro.intensita);
    elseif strcmp(tipo_sorgente, 'gamma')
        % Modello per raggi gamma terapeutici
        spettro = definisci_spettro_gamma(kVp_o_MV, false);
        sorgente.spettro_energetico = @(N) datasample(spettro.energia, N, 'Weights', spettro.intensita);
    else
        error('Tipo di sorgente non supportato');
    end
end

function spettro = definisci_spettro_raggiX(kVp)
    % Definisce lo spettro energetico per una sorgente a raggi X diagnostica
    energia_spettro = linspace(0, kVp, 100);  % Energia fotoni da 0 a kVp
    intensita_spettro = exp(-energia_spettro / (kVp / 3));  % Approssimazione spettro per raggi X
    spettro.energia = energia_spettro;
    spettro.intensita = intensita_spettro / sum(intensita_spettro);  % Normalizzazione
end
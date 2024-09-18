function spettro = definisci_spettro_gamma(MV)
    % Definisce lo spettro energetico per una sorgente gamma terapeutica
    energia_spettro = linspace(0, MV, 100);  % Energia fotoni da 0 a MV
    intensita_spettro = exp(-energia_spettro / 2);  % Approssimazione per TrueBeam a 6 MV
    spettro.energia = energia_spettro;
    spettro.intensita = intensita_spettro / sum(intensita_spettro);  % Normalizzazione
end
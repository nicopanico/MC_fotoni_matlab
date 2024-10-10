function escluso = escludi_voxel_aria(HU_value, materiale_nome)
    % Funzione che restituisce true se il voxel deve essere escluso (aria non polmone)
    % HU_value: il valore HU del voxel
    % materiale_nome: il nome del materiale associato al voxel

    % Soglia HU per considerare un voxel come aria
    HU_soglia_aria = -950;

    % Verifica se il voxel è aria (HU < -950) e non è un polmone
    if HU_value < HU_soglia_aria && ~strcmp(materiale_nome, 'Polmone')
        escluso = true;  % Escludi il voxel
    else
        escluso = false;  % Mantieni il voxel
    end
end

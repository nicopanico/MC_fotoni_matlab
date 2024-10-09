function [griglia_voxel, info_dicom] = leggi_dicom_cartella(cartella_dicom)
    % Funzione per leggere una serie di immagini DICOM da una cartella e costruire una griglia voxel 3D
    % Input:
    %   cartella_dicom: percorso della cartella che contiene i file DICOM
    % Output:
    %   griglia_voxel: griglia voxel 3D delle immagini DICOM
    %   info_dicom: metadati del file DICOM
    
    % Elenco dei file nella cartella DICOM
    files_dicom = dir(fullfile(cartella_dicom, '*.dcm'));
    
    % Inizializza la griglia voxel
    info_dicom = dicominfo(fullfile(cartella_dicom, files_dicom(1).name));
    dimensioni_voxel = [info_dicom.Rows, info_dicom.Columns, numel(files_dicom)];
    griglia_voxel = zeros(dimensioni_voxel);
    
    % Leggi ciascun file DICOM e costruisci la griglia voxel
    for i = 1:numel(files_dicom)
        nome_file = fullfile(cartella_dicom, files_dicom(i).name);
        griglia_voxel(:,:,i) = dicomread(nome_file);
    end
    
    % Converti l'intensità del voxel in valori fisici (se necessario)
    if isfield(info_dicom, 'RescaleSlope') && isfield(info_dicom, 'RescaleIntercept')
        griglia_voxel = info_dicom.RescaleSlope * griglia_voxel + info_dicom.RescaleIntercept;
    end
end

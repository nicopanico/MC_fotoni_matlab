function ROI_struct = leggi_rtstruct()
    % Funzione per leggere un file RT-struct DICOM e ottenere le strutture anatomiche
    % Input:
    %   file_rtstruct: percorso del file DICOM RT-struct
    % Output:
    %   ROI_struct: struttura contenente le informazioni sulle regioni di interesse (ROI)
    
     % Utilizza un'interfaccia grafica per selezionare il file RT-struct
    [filename, pathname] = uigetfile('*.dcm', 'Seleziona il file RT-struct');
    
    % Verifica se l'utente ha annullato la selezione
    if isequal(filename, 0)
        error('Nessun file RT-struct selezionato.');
    else
        % Costruisce il percorso completo del file
        file_rtstruct = fullfile(pathname, filename);
        fprintf('Hai selezionato il file: %s\n', file_rtstruct);
    end

    try
        % Leggi i dati RT-struct
        info_rtstruct = dicominfo(file_rtstruct);
    catch
        error('Impossibile leggere il file RT-struct: %s', file_rtstruct);
    end

    % Inizializza una struttura per contenere le ROI
    ROI_struct = struct;
    
     % Ottieni i nomi dei campi nella sequenza StructureSetROISequence
    roi_fields = fieldnames(info_rtstruct.StructureSetROISequence);
    
    % Ottieni tutte le ROI dal file RT-struct
    for i = 1:length(roi_fields)
        roi_data = info_rtstruct.StructureSetROISequence.(roi_fields{i});
        ROI_struct(i).Nome = roi_data.ROIName;
        ROI_struct(i).Numero = roi_data.ROINumber;
        ROI_struct(i).Contorni = estrai_contorni_ROI(info_rtstruct, roi_data.ROINumber);
    end
end



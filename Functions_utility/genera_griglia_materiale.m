function [material_grid, griglia_voxel, info_dicom, materiale_mappa, materiali] = genera_griglia_materiale(cartella_dicom, materiali)
    % Funzione per leggere le immagini DICOM e le strutture RT-struct e generare una griglia di materiali
    % Restituisce anche una mappa degli ID materiali con i rispettivi nomi e la struttura aggiornata dei materiali
    % Input:
    %   cartella_dicom: percorso della cartella che contiene i file DICOM
    %   materiali: struttura predefinita dei materiali (con densità e altre proprietà)
    % Output:
    %   material_grid: griglia con l'assegnazione dei materiali basata sulle ROI e HU
    %   griglia_voxel: griglia voxel delle immagini DICOM
    %   info_dicom: metadati DICOM della prima immagine
    %   materiale_mappa: tabella che associa gli ID materiali ai nomi delle ROI
    %   materiali: struttura aggiornata dei materiali con nuove aggiunte, se necessario

    % Leggi le immagini DICOM da una cartella
    [griglia_voxel, info_dicom] = leggi_dicom_cartella(cartella_dicom);
    
    % Leggi le strutture RT-struct (utilizzando un'interfaccia grafica per selezionare il file)
    ROI_struct = leggi_rtstruct();  % Usa uigetfile all'interno della funzione
    
    % Inizializza una griglia materiale con lo stesso formato della griglia voxel
    material_grid = zeros(size(griglia_voxel));
    
    % Inizializza una cella per tracciare la mappa dei materiali
    materiale_mappa = cell(length(ROI_struct), 2);
    
    % Contatore per aggiungere nuovi materiali
    next_material_id = length(materiali) + 1;
    
    % Assegna un ID materiale univoco per ciascuna ROI basata sull'indice della ROI
    for i = 1:length(ROI_struct)
        % Nome della ROI attuale
        nome_ROI = ROI_struct(i).Nome;
        
        % Cerca se il nome della ROI corrisponde a un materiale predefinito
        material_id = find(strcmp({materiali.nome}, nome_ROI), 1);
        
        if isempty(material_id)
            % Se il materiale non esiste nella struttura, aggiungine uno nuovo
            materiali(next_material_id).nome = nome_ROI;
            materiali(next_material_id).densita = 1.0;  % Densità predefinita, può essere modificata
            materiali(next_material_id).energia_legame = 0.000;  % Energia di legame (può essere ignorata)
            material_id = next_material_id;  % Usa il nuovo ID
            next_material_id = next_material_id + 1;  % Aggiorna il contatore dei materiali
        end
        
        % Registra il nome della ROI associato a questo materiale
        materiale_mappa{i, 1} = material_id;
        materiale_mappa{i, 2} = nome_ROI;
        
        % Ottieni i contorni della ROI e aggiorna la griglia dei materiali
        contorni = ROI_struct(i).Contorni;
        for j = 1:length(contorni)
            % Converti le coordinate in voxel in base alla risoluzione DICOM
            coord = round(contorni{j} ./ [info_dicom.PixelSpacing; info_dicom.SliceThickness]);
            % Assegna il material_id alla griglia dei materiali
            material_grid(sub2ind(size(material_grid), coord(:,1), coord(:,2), coord(:,3))) = material_id;
        end
    end
    
    % Converti la mappa dei materiali in una tabella per una migliore leggibilità
    materiale_mappa = cell2table(materiale_mappa, 'VariableNames', {'Material_ID', 'ROI_Name'});
end

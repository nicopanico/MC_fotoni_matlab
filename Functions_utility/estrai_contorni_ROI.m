function contorni = estrai_contorni_ROI(info_rtstruct, numero_ROI)
    % Funzione per estrarre i contorni di una specifica ROI
    % Input:
    %   info_rtstruct - struttura con le informazioni RT-struct
    %   numero_ROI - numero della ROI da estrarre
    % Output:
    %   contorni - cell array, ciascuna cella contiene un contorno come matrice Nx3
    
    % Inizializza contorni come un cell array vuoto
    contorni = {};  

    % Cerca la ROI specifica nei dati RT-struct
    roi_fields = fieldnames(info_rtstruct.ROIContourSequence);
    for i = 1:length(roi_fields)
        contour_data = info_rtstruct.ROIContourSequence.(roi_fields{i});
        
        if contour_data.ReferencedROINumber == numero_ROI
            % Se la ROI corrisponde, estrai la sequenza dei contorni
            contorno_sequence = contour_data.ContourSequence;
            contorno_items = fieldnames(contorno_sequence);  % Campi della sequenza dei contorni
            
            % Estrai i dati di ciascun contorno
            for j = 1:length(contorno_items)
                % Ottieni i dati del contorno per ciascun elemento della sequenza
                contourData = contorno_sequence.(contorno_items{j}).ContourData;
                
                % Verifica se contourData è una cell array e rimuovi eventuali celle annidate
                if iscell(contourData)
                    contourData = cell2mat(contourData);  % Converti in matrice
                end
                
                % Controllo e completamento per contorni incompleti
                num_elements = numel(contourData);
                if mod(num_elements, 3) ~= 0
                    % Calcola quanti elementi mancano per completare un multiplo di 3
                    missing_elements = 3 - mod(num_elements, 3);
                    % Aggiungi la penultima coordinata per completare
                    contourData = [contourData; repmat(contourData(end-1), missing_elements, 1)];
                end
                
                % Reshape dei dati del contorno in una matrice Nx3
                contorni{end+1} = reshape(contourData, 3, [])';  % Aggiungi il contorno come matrice Nx3
            end
            break;  % Interrompi il ciclo una volta trovata la ROI corretta
        end
    end
end

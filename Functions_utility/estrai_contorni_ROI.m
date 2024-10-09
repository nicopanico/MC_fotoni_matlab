function contorni = estrai_contorni_ROI(info_rtstruct, numero_ROI)
    % Funzione ausiliaria per estrarre i contorni di una specifica ROI
    contorni = [];  % Inizializza i contorni
    
    % Cerca la ROI specifica nei dati RT-struct
    roi_fields = fieldnames(info_rtstruct.ROIContourSequence);
    for i = 1:length(roi_fields)
        contour_data = info_rtstruct.ROIContourSequence.(roi_fields{i});
        if contour_data.ReferencedROINumber == numero_ROI
            contorno_sequence = contour_data.ContourSequence;
            contorni = cell(length(contorno_sequence), 1);
            for j = 1:length(contorno_sequence)
                contorni{j} = contorno_sequence.(['Item_', num2str(j)]).ContourData;
            end
            break;
        end
    end
end
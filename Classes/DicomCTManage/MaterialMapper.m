classdef MaterialMapper
    properties
        DicomFolder        % Percorso alla cartella DICOM
        Volume             % Oggetto DicomVolume
        Materiali          % Array di oggetti Material
        MaterialiMap       % Tabella HU->Materiale (cell array)
        MaterialGrid       % Griglia dei materiali (uint8)
    end
    
    methods
        function obj = MaterialMapper(dicomFolder)
            % Costruttore: salva il percorso e carica il volume DICOM
            obj.DicomFolder = dicomFolder;
            obj.Volume = DicomVolume(dicomFolder);
        end
        
        function obj = caricaMateriali(obj)
            % Carica i materiali di default
            obj.Materiali = Material.definisciTuttiMateriali();
        end
        
        function obj = caricaMappatura(obj)
            % Carica la tabella di mapping HU->Materiale con priorità e densità
            obj.MaterialiMap = material_hu_map();
        end
        
        function obj = creaGrigliaMateriali(obj)
            % Crea la griglia dei materiali a partire dalla griglia HU del volume
            obj.MaterialGrid = creaGrigliaMaterialiDaHU(obj.Volume.VoxelGridHU, obj.Materiali, obj.MaterialiMap);
        end
        
        function visualizza(obj)
            % Visualizza la griglia materiali in modo interattivo
            if isempty(obj.MaterialGrid)
                error('La MaterialGrid non è stata ancora creata. Chiamare obj.creaGrigliaMateriali() prima di visualizzare.');
            end
            visualizzaMaterialGridDinamica(obj.MaterialGrid, obj.Materiali);
        end

        function visualizzaCT(obj)
            % Metodo per visualizzare la CT originale
            fprintf('Visualizzazione della CT in corso...\n');
            visualizzaCT(obj.Volume.VoxelGridHU);
        end

        function obj = caricaMaterialPhysics(obj, filepath)
            fprintf('[%s] Caricamento delle cross sections da Excel...\n', datestr(now, 'HH:MM:SS'));

            % Ottieni i materiali di base
            materiali_base = Material.definisciTuttiMateriali();

            % Carica le cross sections
            obj.Materiali = MaterialPhysics.caricaMaterialiDaFile(filepath, materiali_base);

            fprintf('[%s] Cross sections caricate con successo.\n', datestr(now, 'HH:MM:SS'));
        end
    end
end





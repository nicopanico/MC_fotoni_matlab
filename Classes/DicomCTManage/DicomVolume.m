classdef DicomVolume
    properties
        FolderPath   % Percorso dei file DICOM
        VoxelGridHU  % Griglia 3D valori HU
        InfoDICOM    % Metadati DICOM del primo file
        OriginPhys   % Origine fisica del primo voxel
        Spacing      % [dx, dy, dz] dimensione voxel in cm
        Dimension    % Dimensioni [nx, ny, nz]
    end
    
    methods
        function obj = DicomVolume(folderPath)
            if nargin > 0
                obj.FolderPath = folderPath;
                [obj.VoxelGridHU, obj.InfoDICOM] = obj.readDicomFolder();
                obj.OriginPhys = obj.InfoDICOM.ImagePositionPatient;
                dx = obj.InfoDICOM.PixelSpacing(1);
                dy = obj.InfoDICOM.PixelSpacing(2);
                dz = obj.InfoDICOM.SliceThickness;
                obj.Spacing = [dx, dy, dz]; 
                obj.Dimension = size(obj.VoxelGridHU);
            end
        end
    end
    
    methods (Access = private)
        function [griglia_voxel, info_dicom] = readDicomFolder(obj)
            files = dir(fullfile(obj.FolderPath, '*.dcm'));
            if isempty(files)
                error('Nessun file DICOM trovato nella cartella specificata.');
            end
            info_dicom = dicominfo(fullfile(obj.FolderPath, files(1).name));
            nx = info_dicom.Rows;
            ny = info_dicom.Columns;
            nz = numel(files);
            griglia_voxel = zeros(nx, ny, nz, 'double');

            % Leggi tutti gli slice
            for i = 1:nz
                nome_file = fullfile(obj.FolderPath, files(i).name);
                slice_data = dicomread(nome_file);
                griglia_voxel(:,:,i) = double(slice_data);
            end

            % Applica rescale slope e intercept per convertire in HU
            if isfield(info_dicom, 'RescaleSlope') && isfield(info_dicom, 'RescaleIntercept')
                griglia_voxel = info_dicom.RescaleSlope * griglia_voxel + info_dicom.RescaleIntercept;
            end
        end
    end
end

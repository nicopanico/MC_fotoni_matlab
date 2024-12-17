
function materiali_map = material_hu_map()
    % material_hu_map restituisce la tabella di mappatura HU->Materiale con priorità.
    % Formato: [HU_min, HU_max, nome_materiale, priority]
    %
    % Note:
    % - Alcuni range HU si sovrappongono. 
    % - In caso di multipli match, si utilizza la massima priorità.
    % - In caso di pari priorità, si usa la densità più vicina.
    %
    % L’associazione “nome_materiale” → un oggetto Material corrispondente deve già
    % esistere nella lista dei materiali definiti in Material.definisciTuttiMateriali().
    % Se non hai materiali precisi per “sostanza_bianca” o “sostanza_grigia”, 
    % puoi crearli o approssimarli come “cervello” o “tessuto_molle”.
    %
    % Assicurati di avere materiali con questi nomi, altrimenti modifica i nomi
    % per corrispondere ai materiali esistenti.

   
    materiali_map = {
        -1000, -950, 'aria'
        -700,  -600, 'polmoni'
        -120,   -90, 'grasso'
        -5,       5, 'acqua'
        10,     20, 'liquido_cerebrospinale'
        13,     50, 'sangue_non_coagulato'
        20,     30, 'sostanza_bianca'
        37,     45, 'sostanza_grigia'
        35,     55, 'muscolo_scheletrico'
        50,     75, 'sangue_coagulato'
        54,     66, 'fegato'
        20,     45, 'rene'
        300,    400, 'osso_spongioso'
        500,   1900, 'osso_corticale'
        };
end



function materiali = definisci_materiali()
    % Funzione per definire i materiali con densità e energia di legame precise

    materiali(1).nome = 'aria';
    materiali(1).densita = 0.0012;  % g/cm³
    materiali(1).energia_legame = 0.000;  % Energia di legame (in MeV)

    materiali(2).nome = 'tessuto_molle';  % Soft tissue
    materiali(2).densita = 1.00;  % g/cm³
    materiali(2).energia_legame = 0.0000753;  % Energia di legame (in MeV, 75.3 eV)

    materiali(3).nome = 'osso_corticale';  % Cortical bone
    materiali(3).densita = 1.85;  % g/cm³
    materiali(3).energia_legame = 0.0001064;  % Energia di legame (in MeV, 106.4 eV)

    materiali(4).nome = 'fegato';  % Liver (assuming soft tissue properties)
    materiali(4).densita = 1.06;  % g/cm³
    materiali(4).energia_legame = 0.0000753;  % Energia di legame (in MeV, same as soft tissue)

    materiali(5).nome = 'polmoni';  % Lung tissue
    materiali(5).densita = 0.26;  % g/cm³
    materiali(5).energia_legame = 0.0000752;  % Energia di legame (in MeV, 75.2 eV)

    materiali(6).nome = 'grasso';  % Adipose tissue
    materiali(6).densita = 0.92;  % g/cm³
    materiali(6).energia_legame = 0.0000632;  % Energia di legame (in MeV, 63.2 eV)

    materiali(7).nome = 'cervello';  % Brain tissue (assuming soft tissue properties)
    materiali(7).densita = 1.04;  % g/cm³
    materiali(7).energia_legame = 0.0000753;  % Energia di legame (in MeV, same as soft tissue)

    materiali(8).nome = 'muscolo_scheletrico';  % Skeletal muscle
    materiali(8).densita = 1.05;  % g/cm³
    materiali(8).energia_legame = 0.0000746;  % Energia di legame (in MeV, 74.6 eV)

    materiali(9).nome = 'midollo_osseo';  % Bone marrow (assuming soft tissue properties)
    materiali(9).densita = 1.03;  % g/cm³
    materiali(9).energia_legame = 0.0000753;  % Energia di legame (in MeV, same as soft tissue)

    materiali(10).nome = 'pelle';  % Skin (assuming soft tissue properties)
    materiali(10).densita = 1.1;  % g/cm³
    materiali(10).energia_legame = 0.0000753;  % Energia di legame (in MeV, same as soft tissue)

    materiali(11).nome = 'osso_spongioso';  % Spongy bone
    materiali(11).densita = 1.10;  % g/cm³
    materiali(11).energia_legame = 0.0000900;  % Energia di legame stimata (in MeV)

    % Aggiunti nuovi organi:
    materiali(12).nome = 'rene';
    materiali(12).densita = 1.05;  % g/cm³
    materiali(12).energia_legame = 0.0000732;  % Energia di legame (in MeV)

    materiali(13).nome = 'milza';
    materiali(13).densita = 1.05;  % g/cm³
    materiali(13).energia_legame = 0.0000732;  % Energia di legame (in MeV)

    materiali(14).nome = 'cuore';
    materiali(14).densita = 1.05;  % g/cm³
    materiali(14).energia_legame = 0.0000732;  % Energia di legame (in MeV)

    materiali(15).nome = 'midollo_spinale';
    materiali(15).densita = 1.03;  % g/cm³
    materiali(15).energia_legame = 0.0000753;  % Energia di legame (in MeV)


end

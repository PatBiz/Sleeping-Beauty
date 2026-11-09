/*
| Capteur            | Contrainte opérationnelle                                                                                                             | Descriptif des données                                                                                                          | Plage de validité                                                                    | Précision                                                                                                    | Cadence & Latence                                                                                                                              | Portée           | Autonomie                                                            |
|:-------------------|:--------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------|:-----------------|:---------------------------------------------------------------------|
| Thermomètre        | Fixé au mur et discret. Doit résister à l'encrassement (poussière, fumée) sans entretien et capter les variations en climat doux.     | En degrés Celsius (°C), encodé en float 32, avec timestamp à la minute.                                                         | -10 à 60°C, pour couvrir les pièces mal isolées, ouvertes l'hiver ou sous les toits. | ±0.3°C, avec une dérive <= 0.5°C après 100 jours.                                                            | Envoi à chaque variation >= 0.2°C. Délai minimal de 1 minute entre deux messages pour éviter de saturer le Broker.                             | 15-20m (Zigbee). | 18 mois sur piles classiques.                                        |
| Capteur d’humidité | Fixé au mur et discret. Doit résister à l'encrassement (poussière, fumée) sans entretien.                                             | En pourcentage d'humidité relative (% HR), encodé en int 32, avec timestamp à la minute.                                        | 0 à 100 % HR pour un suivi complet (zone optimale de 20 à 80 % HR en chambre saine). | <= 2% HR.                                                                                                    | Envoi à chaque variation >= 2% HR. Délai minimal de 5 minutes pour épargner le Broker, l'humidité variant lentement.                           | 15-20m (Zigbee). | 18 mois sur piles classiques.                                        |
| Capteur de CO2     | Fixé au mur et discret. Doit résister à l'encrassement (poussière, fumée) sans entretien.                                             | En parties par million (ppm), encodé en float 32, avec timestamp à la minute.                                                   | 400 à 5000 ppm.                                                                      | Standard NDIR (suivi de seuil d'alerte pour éviter les céphalées).                                           | Envoi à chaque variation >= 5%. Délai minimal de 2 minutes pour épargner le Broker (hausse lente, mais suivi nécessaire contre les céphalées). | 15-20m (Zigbee). | 18 mois sur piles classiques.                                        |
| Montre connectée   | Confortable et dotée des capteurs de suivi du sommeil. Doit permettre d'héberger une application calculant le cycle entre t0 et t+60. | Phase de sommeil (éveil, léger, profond, REM) en JSON, SpO2 (%) et fréquence cardiaque (bpm) en int 32. Timestamp à la seconde. | Phases : 4 états. Bpm : plage physiologique. SpO2 : 0 à 100%.                        | Concordance clinique des phases de 70-80%, détection des cycles >= 90%, rythme cardiaque ±3 bpm, SpO2 <= 1%. | Envoi par batch toutes les 10 minutes la nuit. Envoi toutes les 2 minutes durant la fenêtre de réveil.                                         | ~10m (BLE).      | 3 jours par charge, pour pallier les oublis sans bloquer le système. |
 */

#box[
    #set text(size: 9pt)

    #pad(x: -2.5cm, table(
        columns: (1fr, 2fr, 2fr, 1.5fr, 2fr, 2.5fr, 1fr, 1.5fr),
        align: left,
        stroke: 0.5pt + luma(150),
        table.header(
            [*Capteur*],
            [*Contrainte opérationnelle*],
            [*Descriptif des données*],
            [*Plage de validité*],
            [*Précision*],
            [*Cadence & Latence*],
            [*Portée*],
            [*Autonomie*],
        ),

        [Thermomètre],
        [Fixé au mur et discret. Doit résister à l'encrassement (poussière, fumée) sans entretien et capter les variations en climat doux.],
        [En degrés Celsius (°C), encodé en float 32, avec timestamp à la minute.],
        [-10 à 60°C, pour couvrir les pièces mal isolées, ouvertes l'hiver ou sous les toits.],
        [±0.3°C, avec une dérive <= 0.5°C après 100 jours.],
        [Envoi à chaque variation >= 0.2°C. Délai minimal de 1 minute entre deux messages pour éviter de saturer le Broker.],
        [15-20m (Zigbee).],
        [18 mois sur piles classiques.],

        [Capteur#linebreak()d'humidité],
        [Fixé au mur et discret. Doit résister à l'encrassement (poussière, fumée) sans entretien.],
        [En pourcentage d'humidité relative (% HR), encodé en int 32, avec timestamp à la minute.],
        [0 à 100 % HR pour un suivi complet (zone optimale de 20 à 80 % HR en chambre saine).],
        [<= 2% HR.],
        [Envoi à chaque variation >= 2% HR. Délai minimal de 5 minutes pour épargner le Broker, l'humidité variant lentement.],
        [15-20m (Zigbee).],
        [18 mois sur piles classiques.],

        [Capteur de CO2],
        [Fixé au mur et discret. Doit résister à l'encrassement (poussière, fumée) sans entretien.],
        [En parties par million (ppm), encodé en float 32, avec timestamp à la minute.],
        [400 à 5000 ppm.],
        [Standard NDIR (suivi de seuil d'alerte pour éviter les céphalées).],
        [Envoi à chaque variation >= 5%. Délai minimal de 2 minutes pour épargner le Broker (hausse lente, mais suivi nécessaire contre les céphalées).],
        [15-20m (Zigbee).],
        [18 mois sur piles classiques.],

        [Montre connectée],
        [Confortable et dotée des capteurs de suivi du sommeil. Doit permettre d'héberger une application calculant le cycle entre t0 et t+60.],
        [Phase de sommeil (éveil, léger, profond, REM) en JSON, SpO2 (%) et fréquence cardiaque (bpm) en int 32. Timestamp à la seconde.],
        [Phases : 4 états. Bpm : plage physiologique. SpO2 : 0 à 100%.],
        [Concordance clinique des phases de 70-80%, détection des cycles >= 90%, rythme cardiaque ±3 bpm, SpO2 <= 1%.],
        [Envoi par batch toutes les 10 minutes la nuit. Envoi toutes les 2 minutes durant la fenêtre de réveil.],
        [~10m (BLE).],
        [3 jours par charge, pour pallier les oublis sans bloquer le système.],
    ))
]

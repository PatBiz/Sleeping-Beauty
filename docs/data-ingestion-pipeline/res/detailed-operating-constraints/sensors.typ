/*
| Capteur                 | Plage de mesure                                                                | Précision                                                                                                                          | Cadence et latence                                                  | Portée   | Autonomie            |
|:------------------------|:-------------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------|:---------|----------------------|
| **Température chambre** | −10 à 50°C                                                                     | ±0,3°C avec une dérive ≤ 0,5°C après 100 jours                                                                                     | Rapport sur variation ≥ 0,2°C avec une latence < 1s                 | 15 à 20m | ≥ 18 mois (pile)     |
| **Température lit**     | 0 à 50°C                                                                       | ±0,2°C avec une dérive ≤ 0,5°C après 100 jours                                                                                     | Rapport sur variation ≥ 0,1°C avec une latence < 1s                 | 15 à 20m | ≥ 18 mois (pile)     |
| **CO2 et humidité**     | CO2: 400 à 5000 ppm<br> Humidité: 0 à 100%                                     | CO2 ±(50 ppm + 5%)<br> Humidité ±2%                                                                                                | 1 mesure/min avec une latence < 2s                                  | 15 à 20m | ≥ 18 mois (pile)     |
| **Luminosité**          | 0,01 à 10 000 lux                                                              | ±15%                                                                                                                               | 1 mesure/min avec une latence < 2s                                  | 15 à 20m | ≥ 18 mois (pile)     |
| **Montre connectée**    | Phase de sommeil (éveil, léger, profond, REM)<br> Fréquence cardiaque (en bpm) | Concordance des phases avec la référence clinique d'environ 70 à 80%.<br> Fréquence cardiaque ±3 bpm.<br> Cycles de sommeil ≥ 90%. | Envoi toutes les 10 min la nuit, ≤ 2 min dans la fenêtre de réveil. | ≥ 10m    | ≥ 3 jours (batterie) |
 */

#box[
    #set text(size: 9pt)

    #pad(x: -1.5cm, table(
        columns: (auto, 1fr, 1fr, 1fr, auto, auto),
        align: (left, left, left, left, left, left),
        stroke: 0.5pt,
        inset: 6pt,

        table.header(
            [*Capteur*],
            [*Plage de mesure*],
            [*Précision*],
            [*Cadence et latence*],
            [*Portée*],
            [*Autonomie*],
        ),

        [*Température chambre*],
        [-10 à 50°C],
        [±0,3°C avec une dérive ≤ 0,5°C après 100 jours],
        [Rapport sur variation ≥ 0,2°C avec une latence < 1s],
        [15 à 20m],
        [≥ 18 mois (pile)],

        [*Température lit*],
        [0 à 50°C],
        [±0,2°C avec une dérive ≤ 0,5°C après 100 jours],
        [Rapport sur variation ≥ 0,1°C avec une latence < 1s],
        [15 à 20m],
        [≥ 18 mois (pile)],

        [*CO2 et humidité*],
        [CO2: 400 à 5000 ppm \
        Humidité: 0 à 100%],
        [CO2 ±(50 ppm + 5%) \
        Humidité ±2%],
        [1 mesure/min avec une latence < 2s],
        [15 à 20m],
        [≥ 18 mois (pile)],

        [*Luminosité*],
        [0,01 à 10 000 lux],
        [±15%],
        [1 mesure/min avec une latence < 2s],
        [15 à 20m],
        [≥ 18 mois (pile)],

        [*Montre connectée*],
        [Phase de sommeil (éveil, léger, profond, REM) \
        Fréquence cardiaque (en bpm)],
        [Concordance des phases avec la référence clinique d'environ 70 à 80%. \
        Fréquence cardiaque ±3 bpm. \
        Cycles de sommeil ≥ 90%.],
        [Envoi toutes les 10 min la nuit, ≤ 2 min dans la fenêtre de réveil.],
        [≥ 10m],
        [≥ 3 jours (batterie)],
    ))
]

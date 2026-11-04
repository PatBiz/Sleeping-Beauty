/*
| Actionneur            | Plage de réglage | Pas de réglage | Comportement                                                                                                                                                                                     | Contrainte de sécurité                                                                                                                                                          |
|:----------------------|:-----------------|:---------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Surmatelas**        | 16 à 24°C        | 0,5°C          | Chauffe: +0,4°C/min.<br> Refroidissement: −0,3 °C/min.<br> Latence de commande: < 2s.                                                                                                            | Très Basse Tension (12V ou 24V).<br> **Keep-alive** toutes les 10s. Arrêt si perte de signal > 60s.<br> **Coupure d'urgence indépendante du système intelligent quand ≥ 40°C.** |
| **Climatisation**     | 16 à 24°C        | 0,5°C          | Chauffe & Refroidissement: 1°C en 10min (pièce de 12 à 15m²).<br> Latence de commande: < 5s.                                                                                                     | Bornes 16 à 24°C appliquées côté edge et côté équipement.<br> Bruit ≤ 25 dBA en mode nuit.<br> Vitesse d'air au lit < 0,2 m/s.                                                  |
| **Lampes**            | 0 à 100%         | 1%             | Transitions de 20 min (pour simuler l'aube).<br> Latence de commande: < 0,5s.                                                                                                                    | Éteintes à la remise sous tension.<br> Activation décalée par rapport aux autres actionneurs de réveil.                                                                         |
| **Émetteurs de sons** | 20 à 70 dBA      | 1 dB           | Montée et descente progressives de 1 à 30 min.<br> Sons apaisants / Bruits blancs ≤ 40 dBA.<br> Réveil doux 30 à 55 dBA en 10 min.<br> Réveil impératif ≤ 70 dBA.<br> Latence de commande: < 1s. | Volume plafonné à 75 dBA à 1m.                                                                                                                                                  |
| **Volets**            |                  |                | Course complète 15 à 40s.<br> Latence < 1s.                                                                                                                                                      | Bruit ≤ 45 dBA à 1m.<br> Objectif < 1 lux dans la chambre à la fermeture.                                                                                                       |
 */

#box[
    #set text(size: 9pt)

    #pad(x: -1.5cm, table(
        columns: (auto, auto, auto, 1fr, 1fr),
        align: (left, left, left, left, left),
        stroke: 0.5pt,
        inset: 6pt,

        table.header(
            [*Actionneur*],
            [*Plage de réglage*],
            [*Pas de réglage*],
            [*Comportement*],
            [*Autre contraintes*],
        ),

        [*Surmatelas*],
        [16 à 24°C],
        [0,5°C],
        [Chauffe: +0,4°C/min. \
        Refroidissement: −0,3 °C/min. \
        Latence de commande: < 2s.],
        [Très Basse Tension (12V ou 24V). \
        *Keep-alive* toutes les 10s. Arrêt si perte de signal > 60s. \
        *Coupure d'urgence indépendante du système intelligent quand ≥ 40°C.*],

        [*Climatisation*],
        [16 à 24°C],
        [0,5°C],
        [Chauffe & Refroidissement: 1°C en 10min (pièce de 12 à 15m²). \
        Latence de commande: < 5s.],
        [Bornes 16 à 24°C appliquées côté edge et côté équipement. \
        Bruit ≤ 25 dBA en mode nuit. \
        Vitesse d'air au lit < 0,2 m/s.],

        [*Lampes*],
        [0 à 100%],
        [1%],
        [Transitions de 20 min (pour simuler l'aube). \
        Latence de commande: < 0,5s.],
        [Éteintes à la remise sous tension. \
        Activation décalée par rapport aux autres actionneurs de réveil.],

        [*Émetteurs de sons*],
        [20 à 70 dBA],
        [1 dB],
        [Montée et descente progressives de 1 à 30 min. \
        Sons apaisants / Bruits blancs ≤ 40 dBA. \
        Réveil doux 30 à 55 dBA en 10 min. \
        Réveil impératif ≤ 70 dBA. \
        Latence de commande: < 1s.],
        [Volume plafonné à 75 dBA à 1m.],

        [*Volets*],
        [],
        [],
        [Course complète 15 à 40s. \
        Latence < 1s.],
        [Bruit ≤ 45 dBA à 1m. \
        Objectif < 1 lux dans la chambre à la fermeture.],
    ))
]

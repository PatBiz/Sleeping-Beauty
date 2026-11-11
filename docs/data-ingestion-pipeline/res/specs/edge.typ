/*
|||
|:-------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------|
| **Rôle**                 | Exécution locale du modèle de décision, du jumeau numérique et du traitement des capteurs.                                                     |
| **Capacité de calcul**   | ≥ 4 cœurs, 8 Go de mémoire, 128 Go de stockage.                                                                                                |
| **Données persistantes** | Configuration des équipements.<br/> Dernière version du modèle de décision ainsi que la précédente (pour un rollback sans connexion internet). |
| **Réseau**               | Taux de livraison des messages: ≥ 98%<br/> Accusé de réception sous 3s (3 tentatives max)                                                      |
| **Sécurité**             | Échanges chiffrés et appairage authentifié.                                                                                                    |
 */

#box[
    #set text(size: 9pt)

    #pad(x: -1.5cm, table(
        columns: (auto, 1fr),
        align: (left, left),
        stroke: 0.5pt,
        inset: 8pt,

        [*Rôle*],
        [Exécution locale du modèle de décision, du jumeau numérique et du traitement des capteurs.],

        [*Capacité de calcul*],
        [≥ 4 cœurs, 8 Go de mémoire, 128 Go de stockage. ≤ 15 W],

        [*Données persistantes*],
        [Configuration des équipements. \
        Dernière version du modèle de décision ainsi que la précédente (pour un rollback sans connexion internet).],

        [*Réseau*],
        [Taux de livraison des messages: ≥ 98% \
        Accusé de réception sous 3s (3 tentatives max)],

        [*Sécurité et temps*],
        [Échanges chiffrés et appairage authentifié],
    ))
]

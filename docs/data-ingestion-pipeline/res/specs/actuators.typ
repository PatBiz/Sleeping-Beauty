/*
| Actionneur            | Contrainte opérationnelle                                                                           | Type d'action / Consigne                                                      | Plage de consigne          | Sécurité                                                                                                  | Cadence & Déclenchement                                                                       | Portée                          | Alimentation                              |
|:----------------------|:----------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------------|:---------------------------|:----------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------|:--------------------------------|:------------------------------------------|
| Sur-matelas chauffant | Au contact de l'utilisateur : exige une sécurité maximale et le confort d'un sur-matelas classique. | Consigne de température et arrêt d'urgence.                                   | 16 à 24°C en usage normal. | Killswitch matériel coupant les résistances dès 40°C contre les brûlures.                                 | Envoi sur changement de consigne ou alerte. Keep-alive régulier pour vérifier la liaison.     | 15-20m (Zigbee).                | Secteur 230V avec sécurité basse tension. |
| Climatiseur           | Doit chauffer, refroidir uniformément et déshumidifier la pièce.                                    | Choix du mode (chaud, froid, déshumidification, veille) et température cible. | 16 à 26°C.                 | Temporisation anti-cycle court intégrée pour protéger le compresseur.                                     | Envoi aux transitions (coucher, réveil) ou sur dérive thermique, espacé de plusieurs minutes. | 15-20m (Zigbee).                | Secteur 230V permanent.                   |
| Lampes                | Gradation précise et rendu lumineux identique pour une même commande, peu importe le modèle.        | Allumage, extinction et variation d'intensité.                                | 0 à 100%.                  | Progressivité constante pour ne pas éblouir l'utilisateur.                                                | Action ponctuelle au coucher, puis hausse par paliers réguliers lors du réveil progressif.    | 15-20m (maillage Zigbee).       | Secteur 230V standard.                    |
| Enceintes             | Stockage local requis pour héberger les musiques et sons d'ambiance.                                | Lecture de piste audio (bruits blancs, réveil), réglage du volume et arrêt.   | 0 à 100% du volume.        | Plafonné à 45 dB la nuit pour protéger le sommeil (hausse autorisée uniquement pour le réveil impératif). | Ponctuel à l'endormissement, puis montée progressive du volume au réveil.                     | 15-20m (Zigbee / réseau local). | Secteur 230V ou batterie de secours.      |
| Volets                | Moteur silencieux pour ne pas réveiller l'utilisateur lors des mouvements.                          | Ouverture, fermeture ou positionnement intermédiaire.                         | 0 à 100% d'ouverture.      | Butées physiques de fin de course.                                                                        | Fermeture le soir, puis ouverture par paliers lors du réveil doux.                            | 15-20m (Zigbee).                | Secteur 230V.                             |
 */

#box[
    #set text(size: 9pt)

    #pad(x: -1.5cm, table(
        columns: (1.5fr, 2.5fr, 2.5fr, 1.5fr, 2.5fr, 2.5fr, 1.5fr, 2fr),
        align: left,
        table.header(
            [*Actionneur*],
            [*Contrainte opérationnelle*],
            [*Type d'action / Consigne*],
            [*Plage de consigne*],
            [*Sécurité*],
            [*Cadence & Déclenchement*],
            [*Portée*],
            [*Alimentation*],
        ),

        [Sur-matelas chauffant],
        [Au contact de l'utilisateur : exige une sécurité maximale et le confort d'un sur-matelas classique.],
        [Consigne de température et arrêt d'urgence.],
        [16 à 24°C en usage normal.],
        [Killswitch matériel coupant les résistances dès 40°C contre les brûlures.],
        [Envoi sur changement de consigne ou alerte. Keep-alive régulier pour vérifier la liaison.],
        [15-20m (Zigbee).],
        [Secteur 230V avec sécurité basse tension.],

        [Climatiseur],
        [Doit chauffer, refroidir uniformément et déshumidifier la pièce.],
        [Choix du mode (chaud, froid, déshumidification, veille) et température cible.],
        [16 à 26°C.],
        [Temporisation anti-cycle court intégrée pour protéger le compresseur.],
        [Envoi aux transitions (coucher, réveil) ou sur dérive thermique, espacé de plusieurs minutes.],
        [15-20m (Zigbee).],
        [Secteur 230V permanent.],

        [Lampes],
        [Gradation précise et rendu lumineux identique pour une même commande, peu importe le modèle.],
        [Allumage, extinction et variation d'intensité.],
        [0 à 100%.],
        [Progressivité constante pour ne pas éblouir l'utilisateur.],
        [Action ponctuelle au coucher, puis hausse par paliers réguliers lors du réveil progressif.],
        [15-20m (maillage Zigbee).],
        [Secteur 230V standard.],

        [Enceintes],
        [Stockage local requis pour héberger les musiques et sons d'ambiance.],
        [Lecture de piste audio (bruits blancs, réveil), réglage du volume et arrêt.],
        [0 à 100% du volume.],
        [Plafonné à 45 dB la nuit pour protéger le sommeil (hausse autorisée uniquement pour le réveil impératif).],
        [Ponctuel à l'endormissement, puis montée progressive du volume au réveil.],
        [15-20m (Zigbee / réseau local).],
        [Secteur 230V ou batterie de secours.],

        [Volets],
        [Moteur silencieux pour ne pas réveiller l'utilisateur lors des mouvements.],
        [Ouverture, fermeture ou positionnement intermédiaire.],
        [0 à 100% d'ouverture.],
        [Butées physiques de fin de course.],
        [Fermeture le soir, puis ouverture par paliers lors du réveil doux.],
        [15-20m (Zigbee).],
        [Secteur 230V.],
    ))
]

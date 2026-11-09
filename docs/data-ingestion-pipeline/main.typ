/*
CONSIGNE:

Rapport de l'architecture de votre Data Ingestion Pipeline (15 pages max). Celui-ci doit comporter:
- Un descriptif des données capteurs et de leur plage de validité et de leur volumétrie,
- Un descriptif des algorithmes de pré-traitement de ces données,
- Un descriptif de l'architecture du Data Ingestion Pipeline,
- Un descriptif des couches technologiques mises en œuvre et le rationnel de ces choix.
*/


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


#set page(
    paper: "a4",
    margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 3cm),
)
#set text(size: 12pt, lang: "fr")
#set par(justify: true)
#set quote(block: true)

#let blockquote(body) = block(
    width: 100%,
    stroke: (left: 2pt + red, rest: none),
    outset: (left: 1em),
    inset: (left: 1em, rest: 0.65em),
    body,
)

#let sbtable(..args) = [
    #set text(size: 10pt)
    #set par(justify: false)
    #table(stroke: 0.5pt + luma(150), inset: 5pt, align: left, ..args)
]

#show list: set block(spacing: 0.65em)
#show enum: set block(spacing: 0.65em)
#show raw: it => {
    if it.block {
        // If it's a multi-line code block, return it without the box styling
        it
    } else {
        // If it's inline code, apply the custom box layout
        box(
            fill: rgb("f4f4f4"),
            inset: (x: 4pt, y: 0pt),
            outset: (y: 3pt),
            radius: 3pt,
            baseline: 10%,
            text(fill: rgb("b83f45"), font: "Liberation Mono", it.text)
        )
    }
}


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


// Page de couverture

#align(horizon + center)[
    #set text(size: 28pt, lang: "fr")

    = Pipeline d'Ingestion de Données
    #linebreak()

    == Sleeping Beauty
    #linebreak()

    Co-écrit par :
    #linebreak()
    *Bizot Patrick* & *Hellal Mathias*
]


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= Table des matières

// NOTE: La table des matières peut changer
// TODO: Réorganiser la table des matières

1. #link(<toc-1>)[*Introduction*]
    - Contexte d'utilisation
    - Pipeline d'ingestion de données
    - Exigences de la pipeline

2. #link(<toc-2>)[*Données capteurs*]
    - Nos données
    - Nos capteurs
    - Plages de validité
    - Volumétrie

3. #link(<toc-3>)[*Pré-traitement*]
    - Filtrage
    - Agrégation
    - Fusion
    - Enrichissement sémantique

4. #link(<toc-4>)[*Architecture de la pipeline*]
    - Vue d'ensemble
    - Ingestion et horodatage
    - Voie nominale et voie de sûreté
    - Supervision des équipements
    - Format des messages
    - Fiabilité et mode dégradé
    - Stockage et exploitation

5. #link(<toc-5>)[*Choix technologiques*]
    - Protocoles de communication
    - Passerelles et bus de messages
    - Traitement
    - Stockage
    - Déploiement
    - Synthèse


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


#set page(
    header: [#align(center)[_Architecture - Sleeping Beauty_]],
    numbering: "1",
)
#counter(page).update(1)


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


= 1. Introduction <toc-1>

== 1.1 Contexte d'utilisation

Sleeping Beauty s'adresse principalement aux adultes sans troubles graves du sommeil.
Elle n'est pas destinée aux personnes présentant un manque d'autonomie, notamment les enfants en bas-âge et les personnes en situation de handicap mental ou moteur majeur.
La fonctionnalité de réveil progressif proposée par notre solution ne peut être déployé sur une chambre de plusieurs personnes ayant des rythmes de vie différents (couchers et réveils différents), la solution étant pensée pour créer un environnement de réveil impactant toute la chambre.

Son fonctionnement nécessite une chambre équipée d'un système domotique compatible (chauffage, climatisation, volets, éclairage, etc.).
Lors de l'installation, les équipements manquants sont ajoutés et les équipements incompatibles sont remplacés afin d'assurer le bon fonctionnement de la solution.

L'emplacement des capteurs est une composante majeure dans le bon fonctionnement de notre application.
C'est pourquoi, avant l'installation de notre solution, nous calculons leur emplacement idéal selon la géométrie de la chambre, ses sources et puits de chaleur, et son isolation.

#figure(
    image("./res/sensors-placing.png", width: 60%),
    caption: "Exemple d'emplacement des capteurs",
)

L'utilisateur bénéficie d'une application permettant le contrôle et paramétrage des différentes parties de la solution (Préparation au sommeil, régulation de l'environnement durant le sommeil, et réveil).
Il doit porter une montre connectée durant tout son temps passé dans le lit. Son bpm, SpO2, phase de sommeil seront mesurés par ce dispositif afin de pouvoir adapter au mieux la régulation des composantes de la chambre par notre solution.


== 1.2 Pipeline d'ingestion de données

#figure(
    image("./res/dip.png", width: 135%),
    caption: "Pipeline d'Ingestion de Données",
) <fig-dip>

La @fig-dip décrit le cheminement des données, des capteurs jusqu'à leur exploitation. Elle se lit de gauche à droite en sept étapes :

+ *Capteurs* : les capteurs d'environnement (réseau Zigbee), la montre connectée (réseau BLE) et l'état des équipements.
+ *Ingestion* : réception des messages et horodatage.
+ *Filtrage* : rejet des valeurs aberrantes puis lissage du bruit.
+ *Agrégation* : une seule valeur représentative par grandeur lorsque plusieurs capteurs sont présents.
+ *Fusion* : calcul d'indicateurs qui croisent plusieurs grandeurs (confort thermique, qualité de l'air, santé).
+ *Enrichissement sémantique* : ajout d'annotation contextuelle
+ *Stockage et exploitation* : diffusion au contrôleur intelligent, au watchdog, à InfluxDB et au service d'évaluation.

Deux flux sortent du chemin principal : la température du lit brute rejoint directement le watchdog, et l'état des équipements passe par une supervision dédiée.
Par souci de lisibilité, le schéma ne représente pas tous les flux ; le détail est donné en section 4.


== 1.3 Exigences de la pipeline

Les exigences suivantes sont issues du rapport d'architecture et guident les choix décrits dans ce rapport :

- *Fonctionnement local* : toute la boucle capteurs, décision, commande s'exécute sur l'edge, sans dépendre de la connexion internet.
- *Fiabilité* : taux de livraison des messages ≥ 98 % et moins de 5 % de données perdues ou faussées.
- *Précision dans le temps* : 95 % de la précision des capteurs maintenue après 100 jours de fonctionnement continu.
- *Sûreté* : le chemin de sûreté reste indépendant du pilotage intelligent.
- *Sécurité* : échanges chiffrés (TLS) et appairage authentifié des équipements.
- *Déploiement* : installation rapide, gestion de plusieurs chambres par un non-expert.
- *Évolutivité* : un seul modèle de montre est pris en charge dans le cadre du POC, mais l'ajout d'un autre modèle ne doit pas impacter le reste de la pipeline.



////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 2. Données capteurs <toc-2>

== 2.1 Nos Données

La solution manipule trois familles de données : les mesures de l'environnement de la chambre, les mesures physiologiques de l'utilisateur et l'état des équipements.
Le @tab-data les résume.

#figure(
    sbtable(
        columns: (1.5fr, 1.5fr, 0.8fr, 0.8fr, 2.2fr),
        table.header([*Donnée*]    , [*Source*]               , [*Unité*], [*Type*]  , [*Usage principal*]),
        [Température de la chambre], [2 thermomètres (Zigbee)], [°C]     , [float 32], [Régulation thermique de la pièce (climatiseur), fusion thermique],
        [Température du lit]       , [2 thermomètres (Zigbee)], [°C]     , [float 32], [Régulation du sur-matelas, fusion thermique, sûreté]             ,
        [Humidité relative]        , [2 capteurs (Zigbee)]    , [% HR]   , [int 8]   , [Qualité de l'air, déshumidification]                             ,
        [Taux de CO2]              , [1 capteur (Zigbee)]     , [ppm]    , [float 32], [Alertes de qualité de l'air]                                     ,
        [Fréquence cardiaque]      , [Montre connectée (BLE)] , [bpm]    , [int 32]  , [Fusion de santé, évaluation de la nuit]                          ,
        [SpO2]                     , [Montre connectée (BLE)] , [%]      , [int 8]   , [Fusion de santé, évaluation de la nuit]                          ,
        [Phase de sommeil]         , [Montre connectée (BLE)] , [JSON]   , [string]  , [Régulation pendant le sommeil, réveil, évaluation]               ,
        [Niveau de batterie]       , [Équipements]            , [%]      , [int 8]   , [Supervision des équipements]                                     ,
    ),
    caption: [Données manipulées par la pipeline],
    kind: table,
) <tab-data>

// TODO: Préciser quels équipements remontent leur niveau de batterie et à quelle cadence

Les mesures de température, d'humidité et de CO2 décrivent l'environnement et alimentent la régulation de la chambre.
Les mesures de la montre décrivent l'état de l'utilisateur.
La phase de sommeil pilote la régulation et le réveil, tandis que la fréquence cardiaque et la SpO2 servent à estimer la fiabilité de la nuit pour l'apprentissage.
Le niveau de batterie permet de détecter à l'avance les équipements qui risquent de tomber en panne.


== 2.2 Nos Capteurs

#figure(
    box[#include "res/specs/sensors.typ"],
    caption: [Spécifications des capteurs],
    kind: table,
)


== 2.3 Plages de validité

Chaque capteur possède une plage de validité (voir tableau ci-dessus) qui sert de première barrière contre les données fausses :

- Une valeur hors plage (par exemple une température de 85 °C ou un taux d'humidité négatif) est considérée comme invalide. Elle est rejetée dès l'ingestion, n'entre pas dans les filtres et est comptabilisée dans un indicateur de qualité par capteur.
- Une valeur dans la plage mais inhabituelle (par exemple un taux de CO2 supérieur à 1000 ppm, ou une humidité hors de la zone 20 à 80 % HR) reste valide. Elle est transmise normalement et peut déclencher une alerte de qualité de l'air.
- Pour la montre, la validation reste légère car les données sont déjà traitées par celle-ci. Elle vérifie que la phase de sommeil appartient bien aux 4 états attendus, que la SpO2 est comprise entre 0 et 100 %, que la fréquence cardiaque est dans une plage physiologique et que l'horodatage est cohérent.

// TODO: Fixer la plage physiologique de la fréquence cardiaque (ex. 30 à 220 bpm ?)

Cette comptabilité des valeurs rejetées permet de suivre l'objectif de moins de 5 % de données perdues ou faussées.


== 2.4 Volumétrie

Le volume de données est faible. Le @tab-vol donne un majorant par chambre, calculé avec les cadences maximales des capteurs (délai minimal entre deux messages) et en supposant que chaque message dépasse le seuil de variation. Dans la réalité, l'envoi sur variation produit nettement moins de messages.

#figure(
    sbtable(
        columns: (2fr, 0.9fr, 1.8fr, 1.3fr, 1.3fr),
        table.header([*Source*], [*Nombre*], [*Cadence maximale*], [*Messages par jour*], [*Volume par jour*]),
        [Thermomètres], [4], [1 message par minute], [5 760], [0,86 Mo],
        [Capteurs d'humidité], [2], [1 message toutes les 5 min], [576], [0,09 Mo],
        [Capteur de CO2], [1], [1 message toutes les 2 min], [720], [0,11 Mo],
        [Montre (nuit de 8 h)], [1], [1 mesure par type toutes les 30 s (hypothèse)], [2 880 valeurs], [0,43 Mo],
        [*Total*], [], [], [*9 936*], [*≈ 1,5 Mo*],
    ),
    caption: [Volumétrie maximale par chambre et par jour],
    kind: table,
) <tab-vol>

Les calculs reposent sur les hypothèses suivantes :

- Un message pèse environ 150 octets (valeur, unités, identifiants et horodatages au format JSON), hors en-têtes MQTT et TLS.
- La montre produit une mesure de fréquence cardiaque, de SpO2 et de phase de sommeil par période de 30 s (durée usuelle d'une époque de sommeil). Elles sont envoyées par lots de 10 minutes, soit 48 lots par nuit, puis par lots de 2 minutes pendant la fenêtre de réveil.

// TODO: Confirmer la cadence réelle de mesure de la montre une fois le modèle retenu

Le débit moyen des capteurs Zigbee est d'environ 0,08 message par seconde, et le volume annuel brut reste de l'ordre de 0,5 Go par chambre. Ces ordres de grandeur sont très inférieurs à ce que supporte un équipement edge standard, et justifient le choix de technologies légères (voir la section 5). Les données produites par le pré-traitement sont du même ordre de grandeur que les données brutes.


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 3. Pré-traitement <toc-3>

Le pré-traitement transforme les mesures brutes en grandeurs exploitables par le contrôleur intelligent, le watchdog et le service d'évaluation. Il suit l'ordre suivant : validation (voir la section 2.3), filtrage, agrégation, fusion, puis enrichissement sémantique.

Les mesures de la montre ne passent ni par le filtrage ni par l'agrégation : elles sont déjà traitées par la montre connectée et ne subissent qu'une validation légère à l'ingestion, puis la fusion de santé.

== 3.1 Filtrage

Capteurs concernés: Thermomètre (chambre), Thermomètre (lit), Capteur d'humidité, Capteur de CO2

Tous nos capteurs passeront dans un filtrage en deux temps.
Dans un premier temps, un filtre médian non linéaire sur une fenêtre de 3-4 échantillons sera appliqué. Cela permettra de rejeter les valeurs aberrantes causées par un problème externe qui fausseraient tout le fonctionnement du système.
Ensuite, un filtre passe bas viendra s'assurer que le bruit des capteurs n'est pas pris en compte. Cela permettra notamment de garder une courbe de progression des valeurs du capteur dans le temps, s'assurant donc d'une évolution facile à interpreter par notre application.

=== Filtre médian

Pour chaque capteur, le filtre médian remplace chaque nouvelle valeur par la médiane des 3 à 4 dernières valeurs reçues. Une valeur isolée très éloignée des autres (rebond du signal, interférence) est ainsi éliminée sans déformer les variations réelles. Le filtre médian passe en premier pour qu'un pic ne soit pas étalé par le filtre passe-bas.

Les capteurs envoyant au plus un message par minute (température), 5 minutes (humidité) ou 2 minutes (CO2), la fenêtre couvre environ 3 à 4 minutes pour la température, 15 à 20 minutes pour l'humidité et 6 à 8 minutes pour le CO2. Ces retards sont acceptables car ces grandeurs évoluent lentement dans une chambre.

=== Filtre passe-bas

Les capteurs envoient leurs valeurs à chaque variation significative, donc à intervalles irréguliers. Le filtre passe-bas est un filtre exponentiel dont le coefficient dépend du temps écoulé entre deux mesures :

$ y_k = y_(k-1) + alpha_k (x_k - y_(k-1)), quad alpha_k = 1 - e^(-Delta t_k / tau) $

où $x_k$ est la valeur issue du filtre médian, $y_k$ la valeur lissée, $Delta t_k$ l'intervalle de temps depuis la mesure précédente et $tau$ la constante de temps du filtre. Plus $tau$ est grande, plus le lissage est fort, mais plus la réponse est lente.

// TODO: Définir la constante de temps tau de chaque capteur grâce aux nuits simulées de la chambre


== 3.2 Agrégation

Capteurs concernés: Thermomètre (chambre), Thermomètre (lit), Capteur d'humidité

Nos capteurs de température, et nos capteurs d'humidités sont présent en plusieurs exemplaires pour s'assurer d'une donnée propre, et représentative de la pièce suivie. Nous devons donc les agréger afin d'en ressortir une seule donnée qui représentera la valeur globale de la pièce. Pour se faire, nous utiliserons un modèle DAI-DAO via un algorithme de moyenne pondérée spatiale. Nous définirons au moment de l'installation quels capteurs auront les poids les plus importants dans cette agrégation en fonction de sa promiscuité avec des éléments potentiellement perturbateurs de sa mesure.

Le modèle DAI-DAO (_Data In - Data Out_) signifie que les entrées et la sortie sont de même nature : plusieurs températures donnent une température. Pour une grandeur mesurée par $n$ capteurs de valeurs filtrées $x_i$ et de poids $w_i$, la valeur agrégée est :

$ x = (sum_(i=1)^n w_i x_i) / (sum_(i=1)^n w_i) $

Les poids sont fixés à l'installation. Si un capteur ne répond plus ou envoie une valeur invalide, son poids est mis à zéro et les poids des capteurs restants sont renormalisés, ce qui permet de continuer à fonctionner avec un seul capteur par grandeur. Le capteur de CO2 étant unique, il n'est pas agrégé.

// TODO: Définir la fenêtre temporelle d'alignement des capteurs (par exemple une minute) et le critère pour considérer un capteur comme silencieux
// TODO: Vérifier si un contrôle de cohérence entre capteurs jumeaux (détection de dérive) est ajouté avant l'agrégation


== 3.3 Fusion

Capteurs concernés: Thermomètre (chambre), Thermomètre (lit), Capteur d'humidité, Capteur de CO2, Capteur de SpO2, Capteur de fréquence cardiaque

=== Fusion thermique (Température Chambre et Température Lit)

L'objectif de cette fusion est la combinsaison de la températures de la chambre et du lit pour  récupérer l'indice de confort thermique et le delta thermique entre le microclimat proche de l'utilisateur (lit) et la chambre. Cela permet ensuite au contrôleur intelligent d'équilibrer les consignes entre le sur-matelas chauffant et le climatiseur sans créer de conflit énergétique entre les deux actionneurs.

Le delta thermique est la différence entre la température du lit et celle de la chambre. Les valeurs absolues des deux températures restent transmises au contrôleur en plus de ces indicateurs, car la régulation en a besoin. Cette fusion produit des indicateurs à partir de grandeurs de même niveau (modèle FEI-FEO de Dasarathy).

// TODO: Définir l'indice de confort thermique (par exemple l'écart à la température cible de l'utilisateur)

=== Fusion qualité de l'air (Humidité et CO2)

Cette fusion a pour but de récupérer l'indice de confinement de la chambre. L'algorithme évalue en même temps le pourcentage d'humidité de la chambre et sa teneur en CO2. Une hausse simultanée de ces deux métriques alertera le système d'un renouvellement d'air insuffisant et ajustera la pondération du risque de céphalées matinales, permettant au contrôleur d'adapter la déshumidification du climatiseur ou de prévenir l'utilisateur d'ouvrir la fenêtre avant le coucher.

L'indice de confinement est calculé à partir de seuils indicatifs (par exemple 1000 ppm de CO2 pour un air peu renouvelé et 80 % HR pour une humidité élevée). Lorsque l'indice dépasse un seuil d'alerte, l'information est envoyée sur le stream critique vers le watchdog, afin d'alerter l'utilisateur en temps réel.

// TODO: Fixer les seuils de l'indice de confinement et la durée de dépassement avant alerte

=== Fusion de santé (SpO2 et Fréquence cardiaque)

Les données physiologiques issues de la montre feront l'objet d'une fusion décisionnelle FEI-DEO reposant sur les fonctions Dempster-Shafer. Nous permettant de modéliser explicitement l'incertitude liée aux capteurs grand public (concordance clinique des phases de 70 à 80 %). Cela nous permettra de récupérer en sortie un score de qualité de la nuit, et donc à quel point nous devrions en prendre compte pour l'entraînement de l'IA.

La théorie de Dempster-Shafer répartit une masse de croyance $m$ sur des sous-ensembles d'un ensemble d'hypothèses $Theta$ (par exemple « nuit fiable » et « nuit douteuse »), la masse placée sur $Theta$ lui-même représentant l'ignorance. Chaque source (SpO2, fréquence cardiaque) fournit sa propre fonction de masse, et les deux sont combinées par la règle de Dempster :

$ m(A) = (sum_(B inter C = A) m_1(B) m_2(C)) / (1 - K), quad K = sum_(B inter C = emptyset) m_1(B) m_2(C) $

où $K$ mesure le conflit entre les deux sources. À partir de la masse obtenue, on calcule la croyance et la plausibilité de l'hypothèse « nuit fiable », dont on déduit le score de qualité de la nuit. Le modèle FEI-DEO (_Feature In - Decision Out_) signifie que l'on part d'indicateurs et que l'on produit une décision.

La phase de sommeil n'est pas fusionnée : elle est transmise directement à l'étape d'enrichissement, car elle pilote la régulation et le réveil en temps réel.

// TODO: Définir comment les fonctions de masse sont construites à partir des mesures (seuils, concordance avec la phase de sommeil)


== 3.4 Enrichissement sémantique

Cette dernière étape rend chaque donnée directement exploitable par les consommateurs, sans qu'ils aient à connaître sa provenance. Elle ajoute :

- le contexte : identifiant de la chambre, zone (chambre ou lit), identifiant de la nuit ;
- la nature de la donnée : type de grandeur, unité, source (capteur, agrégat, indicateur de fusion) ;
- la qualité : indicateur de confiance, issu de la validation et du nombre de capteurs ayant participé à la mesure ;
- les deux horodatages `ts_event` et `ts_ingest` (voir la section 4.2).

Les données enrichies sont ensuite diffusées sur deux voies : un *stream temps réel* vers le contrôleur intelligent et un *stockage* dans InfluxDB.



////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 4. Architecture de la pipeline <toc-4>

== 4.1 Vue d'ensemble

La pipeline s'exécute entièrement sur l'edge, dans la chambre. Chaque étape de la @fig-dip est un service indépendant qui s'abonne à un sujet du bus MQTT, traite les messages reçus puis publie son résultat sur un autre sujet. Ce découpage présente trois avantages :

- une étape peut être modifiée, testée ou redémarrée sans toucher aux autres ;
- les voies critiques peuvent être séparées de la voie nominale ;
- chaque étape peut être surveillée individuellement (nombre de messages traités, valeurs rejetées).

Du point de vue de la pipeline, toutes les données sont traitées en flux (_stream_), y compris les lots de la montre qui arrivent par rafales de 10 minutes. Le traitement par lots (_batch_) ne concerne que l'apprentissage « entre les nuits » : le service d'évaluation relit l'historique de la nuit dans InfluxDB, comme décrit dans le rapport d'architecture.


== 4.2 Ingestion et horodatage

L'étape d'ingestion est le point d'entrée unique des données. Elle est assurée par deux passerelles, l'une pour le réseau Zigbee et l'autre pour le réseau BLE de la montre. Elle réalise quatre opérations :

+ *Normalisation* : tous les messages sont convertis dans une enveloppe commune (voir la section 4.5), quelle que soit leur origine.
+ *Validation* : rejet des valeurs hors plage ou mal formées (voir la section 2.3).
+ *Horodatage* : chaque message reçoit deux dates. `ts_event` est la date de la mesure, fournie par le capteur (à la minute pour les capteurs Zigbee, à la seconde pour la montre). `ts_ingest` est la date de réception par la passerelle.
+ *Publication* sur le bus de messages.

L'horodatage est posé à l'entrée de la pipeline, et non à la fin, pour deux raisons. D'abord, les filtres et les agrégations ont besoin de la date réelle des mesures : les capteurs envoient à intervalles irréguliers et les sources n'ont pas les mêmes cadences. Ensuite, la date de fin de traitement ne reflète pas la date de la mesure, puisque chaque étape ajoute un retard variable. L'écart entre `ts_event` et `ts_ingest` permet aussi de détecter les retards de transmission.

// TODO: Définir la synchronisation d'horloge entre la montre et l'edge (décalage estimé à la connexion ?)


== 4.3 Voie nominale et voie de sûreté

La pipeline comporte deux voies qui ne dépendent pas l'une de l'autre.

=== Voie nominale

Les mesures traversent le filtrage, l'agrégation, la fusion et l'enrichissement. Le résultat alimente le contrôleur intelligent, qui régule la chambre, et InfluxDB, qui sert à l'évaluation et à l'apprentissage. Cette voie est optimisée pour la qualité des données, au prix d'un léger retard dû aux filtres.

=== Voie de sûreté

Le rapport d'architecture impose que la sûreté soit indépendante de la régulation, afin de couper le chauffage même si celle-ci est défaillante. La pipeline respecte ce principe de deux façons :

- la *température du lit brute* (après ingestion et validation, mais avant tout filtre) est envoyée directement au watchdog. Un vrai pic de surchauffe pourrait être pris pour une valeur aberrante par le filtre médian, et le passe-bas retarderait sa détection. Le watchdog compare cette valeur à des seuils simples (coupure à 40 °C, plage 16 à 24 °C) ;
- le *stream critique* issu de la fusion de qualité de l'air alerte le watchdog d'un air insuffisamment renouvelé.

Le watchdog reçoit au plus une mesure de température du lit par minute (cadence maximale des thermomètres). Cette limite est compensée par les protections matérielles du sur-matelas (coupure à 40 °C côté équipement).

// TODO: Valider qu'une détection de surchauffe avec jusqu'à une minute de délai est acceptable pour la sûreté, ou augmenter la cadence d'envoi des thermomètres du lit


== 4.4 Supervision des équipements

Les équipements remontent leur niveau de batterie, qui est traité par une chaîne séparée de la voie nominale : la *supervision des équipements*. Elle compare chaque niveau à un seuil d'alerte et détecte l'absence de nouvelles d'un équipement, ce qui permet de prévenir l'utilisateur avant une panne. Son résultat (état des équipements) est transmis à l'enrichissement sémantique, puis stocké dans InfluxDB et utilisé par le système de détection des défaillances décrit dans le rapport d'architecture.

// TODO: Définir les seuils d'alerte de batterie et le délai à partir duquel un équipement est considéré comme injoignable


== 4.5 Format des messages

Les messages utilisent une enveloppe commune en JSON, ce qui rend les étapes interchangeables :

```json
{
  "ts_event": "2026-11-09T02:14:00Z",
  "ts_ingest": "2026-11-09T02:14:01Z",
  "room": "chambre-1",
  "sensor_id": "temp-lit-1",
  "value": 21.4,
  "unit": "degC",
  "quality": "ok"
}
```

Les sujets MQTT sont organisés selon l'étape de traitement, de façon à pouvoir abonner chaque service au bon niveau :

#figure(
    sbtable(
        columns: (2.4fr, 3fr),
        table.header([*Sujet*], [*Contenu*]),
        [`sb/{chambre}/raw/{capteur}`], [Mesures brutes horodatées et validées],
        [`sb/{chambre}/filtered/{grandeur}`], [Mesures filtrées],
        [`sb/{chambre}/aggregated/{grandeur}`], [Valeurs agrégées],
        [`sb/{chambre}/features/{indicateur}`], [Indicateurs issus de la fusion],
        [`sb/{chambre}/critical/{type}`], [Alertes à destination du watchdog],
        [`sb/{chambre}/equipment/{equipement}`], [État des équipements],
    ),
    caption: [Organisation des sujets MQTT],
    kind: table,
)

Le préfixe par chambre permet de gérer plusieurs chambres sur la même infrastructure.


== 4.6 Fiabilité et mode dégradé

Pour atteindre l'objectif de 98 % de messages livrés, la pipeline s'appuie sur les mécanismes suivants :

- *Qualité de service MQTT adaptée à la criticité* : QoS 0 pour les mesures des capteurs de la chambre, QoS 1 pour les données de la montre, QoS 2 pour les commandes. Les mesures de température sont émises régulièrement et la perte d'un message est corrigée par le suivant, alors que les commandes ne doivent être ni perdues ni dupliquées.
- *Accusés de réception* : un message important est réémis au bout de 3 secondes sans accusé, avec 3 tentatives au maximum, et un tampon local conserve les messages en cas de coupure.
- *Sécurité* : chiffrement TLS et appairage authentifié des équipements.
- *Fonctionnement sans internet* : aucune étape ne dépend d'un service distant. Seules la synchronisation avec le portail utilisateur et la récupération de la météo nécessitent une connexion.
- *Isolation des pannes* : le watchdog reçoit les mesures brutes en parallèle de la chaîne de pré-traitement. Si une étape tombe en panne, il continue de surveiller la sécurité, et un redémarrage automatique des services est configuré.

// TODO: Vérifier la cohérence du QoS 0 pour les capteurs avec la cible de 98 % de livraison


== 4.7 Stockage et exploitation

Les données sont stockées dans InfluxDB sur l'edge. Deux espaces sont distingués :

- *raw* : données brutes horodatées, conservées sur une courte durée (quelques jours). Elles permettent de retraiter l'historique si un filtre est modifié ;
- *processed* : données filtrées, agrégées, indicateurs de fusion, états des équipements et commandes envoyées aux actionneurs, conservées plus longtemps pour l'évaluation du sommeil et l'entraînement.

Les commandes sont conservées avec les mesures car l'apprentissage par renforcement a besoin de l'état de la chambre, de l'action envoyée et du score obtenu.

Les consommateurs de la pipeline sont :

- le *watchdog* (voie de sûreté) ;
- le *contrôleur intelligent* (stream temps réel) ;
- le *service d'évaluation et d'entraînement de l'IA* (lecture de l'historique en fin de nuit).

// TODO: Fixer les durées de rétention (par exemple 7 jours pour raw)


= 5. Choix technologiques <toc-5>

// TODO: ...

Les choix technologiques découlent des contraintes du projet : un équipement edge domestique, un faible volume de données (environ 1,5 Mo par jour et par chambre), un fonctionnement sans internet, une installation simple et une grande fiabilité. Nous privilégions donc des technologies légères, ouvertes et largement répandues.

== 5.1 Protocoles de communication

#figure(
    sbtable(
        columns: (1.4fr, 2fr, 2fr, 2fr),
        table.header([*Critère*], [*Zigbee*], [*BLE*], [*Wi-Fi*]),
        [Consommation], [Très faible, piles de plusieurs mois], [Très faible], [Élevée, peu adaptée aux capteurs sur piles],
        [Portée], [15 à 20 m, étendue par le maillage], [Environ 10 m], [Bonne],
        [Topologie], [Maillage], [Point à point], [Étoile],
        [Offre de capteurs], [Très large (température, humidité, CO2)], [Montres, bracelets], [Large mais gourmande en énergie],
        [Usage retenu], [Capteurs de la chambre], [Montre connectée], [Non retenu],
    ),
    caption: [Comparaison des protocoles sans fil],
    kind: table,
)

*Zigbee pour les capteurs de la chambre.* Ces capteurs envoient de petits messages peu fréquents et doivent tenir 18 mois sur piles, ce qui correspond au profil de Zigbee. Le maillage permet d'étendre la portée en ajoutant des relais. La large offre de capteurs du commerce facilite l'installation et le remplacement. Le Wi-Fi consomme trop pour ce type de capteur et chargerait le réseau domestique. Zigbee partageant la bande de 2,4 GHz avec le Wi-Fi, le canal Zigbee sera choisi à l'installation pour limiter les interférences.

*BLE pour la montre.* Les montres et bracelets connectés utilisent nativement le BLE, qui consomme peu et permet les 3 jours d'autonomie demandés. La portée d'environ 10 m convient puisque la montre reste dans le lit.

// TODO: Confirmer le choix de Zigbee face à Thread/Matter et Z-Wave (offre de capteurs, maturité)


== 5.2 Passerelles et bus de messages

*Passerelles.* Pour le réseau Zigbee, nous utilisons Zigbee2MQTT avec une clé USB : il publie directement les mesures sur MQTT et fonctionne avec un grand nombre de capteurs. Pour la montre, un pont BLE vers MQTT est nécessaire (programme Python utilisant la bibliothèque `bleak`, ou application embarquée dans la montre), son choix dépendant du modèle retenu pour le POC.

*Bus de messages.* Nous utilisons un broker MQTT (Mosquitto) avec chiffrement TLS (MQTTS). MQTT est un protocole de publication-abonnement léger, qui offre trois niveaux de qualité de service, des messages conservés (_retained_) et un message de dernière volonté (_last will_) utile pour détecter qu'un équipement a disparu. Des solutions comme Kafka ou RabbitMQ seraient surdimensionnées pour une dizaine de capteurs et un équipement edge domestique, et demanderaient plus de ressources et d'administration.


== 5.3 Traitement

Les étapes de pré-traitement sont des services écrits en Python : bibliothèque `aiomqtt` (ou `paho-mqtt`) pour les messages, `numpy` et `scipy` pour les filtres, `pandas` pour les fenêtres temporelles. Python offre les bibliothèques de traitement du signal nécessaires, le code est facile à tester unitairement et chaque étape est déployée dans son propre conteneur. Les moteurs de traitement de flux distribués (Flink, Spark Streaming, Kafka Streams) ne sont pas retenus : ils sont conçus pour des volumes bien supérieurs et leur empreinte mémoire est trop importante pour l'edge.

Pour valider rapidement la logique de la pipeline, un prototype peut être réalisé avec Node-RED, dont les nœuds correspondent aux étapes de la @fig-dip.

// TODO: Décider si le prototype Node-RED est conservé ou si l'on passe directement à Python


== 5.4 Stockage

Nous utilisons InfluxDB (version 2, OSS), une base de données dédiée aux séries temporelles. Elle gère nativement l'horodatage, les durées de rétention et la réduction de résolution des anciennes données, ce qui correspond aux deux espaces *raw* et *processed*. L'archivage des données brutes est réalisé par Telegraf, qui lit le bus MQTT et écrit dans InfluxDB sans code supplémentaire. Les étiquettes (_tags_) sont limitées à la chambre, la zone et le type de capteur, afin de garder un nombre de séries faible. Une base relationnelle serait moins adaptée aux requêtes par fenêtres de temps, et une simple base de fichiers n'offrirait pas la gestion de la rétention.

// TODO: Confirmer la version d'InfluxDB retenue


== 5.5 Déploiement

L'ensemble des services est déployé avec Docker Compose sur l'edge (mini-PC ou ordinateur monocarte). Cette approche permet une installation reproductible et rapide, répondant à l'exigence d'installation rapide par un non-expert, et facilite le déploiement de plusieurs chambres. Le watchdog tourne dans un conteneur séparé, voire sur un matériel différent, pour rester indépendant du reste de la pipeline. L'horloge de l'edge est synchronisée par NTP, car la qualité de l'horodatage en dépend.

// TODO: Dimensionner le matériel edge (CPU, mémoire, stockage)


== 5.6 Synthèse

#figure(
    sbtable(
        columns: (1.4fr, 1.8fr, 3fr),
        table.header([*Couche*], [*Technologie*], [*Rationnel*]),
        [Capteurs d'environnement], [Zigbee], [Faible consommation, autonomie de 18 mois, maillage, large offre de capteurs],
        [Montre connectée], [BLE], [Protocole natif des montres, faible consommation],
        [Passerelles], [Zigbee2MQTT, pont BLE en Python], [Publication directe sur MQTT],
        [Bus de messages], [Mosquitto (MQTT/MQTTS)], [Léger, QoS différenciés, chiffrement],
        [Traitement], [Services Python], [Bibliothèques de traitement du signal, testable, un conteneur par étape],
        [Stockage], [InfluxDB 2 et Telegraf], [Base de séries temporelles, rétention, archivage sans code],
        [Déploiement], [Docker Compose sur edge], [Installation reproductible, services isolés],
    ),
    caption: [Synthèse des choix technologiques],
    kind: table,
)

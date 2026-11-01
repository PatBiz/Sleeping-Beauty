/*
CONSIGNE:

Rapport explicatif de votre architecture (15 pages max). Il doit comporter:
- Le descriptif de l'architecture et le problème qu'elle résout (core domain),
- L'expression des besoins,
- L'analyse des risques,
- Les contraintes opérationnelles,
- Un descriptif des choix technologiques et leur justification.
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

    = Architecture
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


#set page(
    header: [#align(center)[_Architecture - Sleeping Beauty_]],
    numbering: "1",
)
#counter(page).update(1)


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


= Table des matières

// NOTE: La table des matières peut changer

1. #link(<toc-1>)[*Business*]
    - ...

2. #link(<toc-2>)[*Description de l'architecture*]
    - ...

3. #link(<toc-3>)[*Analyse des risques*]
    - ...

4. #link(<toc-4>)[*Contraintes opérationnelles*]
    - ...

5. #link(<toc-5>)[*Choix technologiques*]
    - ...


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 1. Business <toc-1>

*Sleeping Beauty* est une *solution installable* dans une maison, un appartement ou un complexe d'appartement.
Elle a pour objectif d'*améliorer les conditions de sommeil* en agissant sur l'*environnement de l'utilisateur*.
Elle propose *un suivi* et des *solutions personnalisés*, basées sur le comportement de l'utilisateur avant, pendant, et après sa nuit.

*Avant le coucher*, le système analyse le comportement de l'utilisateur pour *adapter automatiquement son environnement* en baissant la *température*, en atténuant la *luminosité* et en diffusant des *sons apaisants* afin de préparer un endormissement optimal.

*Pendant la nuit*, l'installation régule en continu ces paramètres environnementaux pour maintenir des *conditions stables* et préserver la *qualité du repos*.

*Au réveil*, la solution synchronise la sortie du lit avec les *cycles de sommeil léger* tout en *simulant la lumière du jour* et en *jouant des sons progressifs* pour faciliter le réveil.


== 1.1 Contexte d'utilisation

Notre solution s'adresse à un public relativement large. Toutefois, afin d'en garantir l'efficacité optimale, nous considérons que l'utilisateur est un adulte ne présentant pas de troubles particuliers du sommeil, et disposant d'un rythme circadien classique, c'est-à-dire une personne qui dort la nuit et travaille le jour.

En revanche, Sleeping Beauty n'est pas destinée aux personnes présentant un handicap moteur ou un manque d'autonomie, comme les nourrissons ou les personnes en situation de handicap mental.

Le fonctionnement de Sleeping Beauty nécessite également une chambre équipée d'un système domotique comprenant au minimum les équipements compatibles nécessaires (chauffage, climatisation, volets, éclairage, etc.). Lors de l'installation, les équipements non compatibles sont remplacés et les équipements manquants sont ajoutés afin de garantir le bon fonctionnement de la solution.


== 1.2 Nos KPIs

#include "res/kpis.typ"


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 2. Description de l'architecture <toc-2>

== 2.1 Nos domaines

=== 2.1.1 Core Domains

==== Préparation de l'environnement avant le sommeil

Ce domaine définit les stratégies permettant de préparer l'environnement de sommeil afin de favoriser l'endormissement de l'utilisateur.
Il détermine les conditions environnementales à atteindre avant le début de la phase de sommeil, notamment en matière de température et de luminosité.
L'objectif est de rendre l'environnement favorable à l'endormissement au moment où l'utilisateur souhaite se coucher.

==== Régulation de l'environnement pendant le sommeil

Ce domaine définit les stratégies de régulation de l'environnement pendant la phase de sommeil afin d'en améliorer la qualité.
Il s'appuie sur les mesures de l'environnement et sur l'état de sommeil estimé de l'utilisateur pour adapter les conditions de la chambre et du lit.
L'objectif est de maintenir un environnement favorable au sommeil tout au long de la nuit.

==== Gestion du réveil

Ce domaine définit les stratégies permettant d'adapter l'environnement afin de favoriser un réveil naturel, tout en garantissant que l'utilisateur ne se réveille pas au-delà de l'heure souhaitée.
Il distingue deux mécanismes complémentaires : le réveil doux, qui cherche à favoriser un réveil progressif et agréable, et le réveil impératif, qui garantit le respect de l'heure limite définie par l'utilisateur.

- *Gestion du réveil doux*

    Ce sous-domaine vise à favoriser un réveil naturel et progressif en exploitant les phases de sommeil estimées de l'utilisateur.
    Il adapte progressivement l'environnement, notamment par la lumière, les émissions sonores ou la température, afin de faciliter le réveil au cours d'une fenêtre temporelle prédéfinie.

- *Gestion du réveil impératif*

    Ce sous-domaine garantit que l'utilisateur ne dépasse pas l'heure de réveil qu'il a définie.
    Lorsque le réveil doux n'a pas permis de réveiller l'utilisateur dans la fenêtre prévue, il déclenche les actions nécessaires pour provoquer son réveil à l'heure limite.

==== Prise de décision intelligente

Ce domaine détermine les actions à appliquer sur l'environnement de sommeil afin d'atteindre les objectifs définis par les stratégies de contrôle.
Il s'appuie sur les mesures de l'environnement, l'état estimé de l'utilisateur, les règles de décision et les paramètres de contrôle disponibles.
Il exploite également le jumeau numérique pour simuler les conséquences possibles des actions envisagées sur l'environnement physique.

- *Prise de décision selon les règles définies*

    Ce mécanisme sélectionne les actions à effectuer en fonction de l'état courant de l'environnement, des objectifs de contrôle et des règles métier définies.
    Il applique les paramètres de contrôle disponibles tout en respectant les préférences et les contraintes imposées au système.

- *Exploitation du jumeau numérique*

    Ce mécanisme exploite une représentation numérique de l'environnement physique afin d'estimer les conséquences possibles des actions envisagées.
    Il permet notamment de simuler l'évolution des conditions environnementales à la suite d'une action, afin d'éclairer la prise de décision.

=== 2.1.2 Supporting Domains

==== Adaptation du système de décision (par renforcement)

Ce domaine vise à améliorer progressivement les stratégies de contrôle en adaptant les paramètres utilisés par le système de décision. Il exploite les résultats des nuits précédentes, notamment les scores de qualité du sommeil, afin d'identifier les ajustements susceptibles d'améliorer les performances du système. Dans le cadre du POC, l'apprentissage par renforcement est réalisé entre les nuits, les règles de décision restant fixes.

#blockquote()[
    *Note :*
    Une adaptation continue pendant la nuit pourrait être envisagée ultérieurement.
    Toutefois, l'apprentissage est actuellement prévu pour s'effectuer entre les nuits.
]

==== Évaluation de la qualité du sommeil et de son amélioration

Ce domaine évalue la qualité du sommeil de l'utilisateur à partir des phases et des cycles de sommeil mesurés.
Il calcule un score permettant de caractériser la qualité d'une nuit et de comparer les résultats obtenus avec ceux des nuits précédentes.
Les résultats de cette évaluation sont également exploités par le système d'apprentissage afin d'adapter progressivement les paramètres de contrôle.

#blockquote()[
    *Note :*
    Ce domaine pourrait également être classé comme Core si la qualité de l'évaluation et son utilisation dans la boucle d'adaptation constituent des éléments essentiels à la différenciation de la solution.
    À l'inverse, il peut être considéré comme Supporting si son fonctionnement repose principalement sur des méthodes standardisées.
]

==== Mesure de l'environnement de sommeil

Ce domaine assure l'acquisition des mesures de l'environnement physique de la chambre et du lit, notamment la température, l'humidité et la concentration en CO2.
Il synchronise ces mesures avec le jumeau numérique afin que celui-ci représente au mieux l'état courant de l'environnement physique.
Les informations ainsi collectées sont exploitées par le système de décision pour adapter le pilotage de l'environnement.

#blockquote()[
    *Note :*
    La mesure du CO2 et de l'humidité n'alimente que la génération d'alertes.
    Un système d'aération, ou une ouverture des fenêtre automatique est nécessaire pour pouvoir les réguler.
    Cependant, nous ne fournissons pas de telles fonctionnalités.
]

==== Mesure des phases de sommeil

Ce domaine assure la récupération et l'exploitation des données relatives aux phases de sommeil de l'utilisateur, fournies par sa montre connectée.
Il permet d'estimer l'état de sommeil de l'utilisateur au cours de la nuit et fournit les informations nécessaires à la régulation de l'environnement et à la gestion du réveil.
Ces données constituent également une entrée essentielle pour l'évaluation de la qualité du sommeil.

#blockquote()[
    *Note :*
    La diversité des modèles de montres connectées et de leurs interfaces nécessite de développer des mécanismes d'intégration adaptés à chaque modèle supporté.
    Dans le cadre du POC, un seul modèle de montre sera pris en charge afin de limiter la complexité de cette intégration.
]

==== Gestion des équipements connectés

Ce domaine assure la gestion du cycle de vie des équipements nécessaires au contrôle de l'environnement de sommeil.
Il prend notamment en charge leur installation, leur découverte, leur appairage et leur configuration.
Il assure également le suivi de leur état de fonctionnement, notamment leur disponibilité et leur niveau de batterie, afin de fournir au système les informations nécessaires à leur utilisation et à leur maintenance.

==== Sûreté de fonctionnement

Ce domaine garantit la sécurité de l'utilisateur et des équipements en appliquant des mécanismes indépendants du système intelligent.
Il détecte les anomalies critiques et les situations dangereuses, notamment à partir des états remontés par les équipements, puis applique les règles de sécurité appropriées.
Il peut interdire certaines actions, mettre un équipement en sécurité ou procéder à son arrêt lorsque son fonctionnement présente un risque.
En cas de situation critique, il déclenche les alertes nécessaires et peut provoquer un réveil d'urgence.

==== Configuration utilisateur

Ce domaine permet à l'utilisateur de personnaliser le fonctionnement de la solution en fonction de ses préférences et de ses besoins.
Il assure notamment la configuration des préférences de température et d'environnement, des paramètres de réveil ainsi que l'activation ou la désactivation de fonctionnalités telles que les bruits blancs.
Les paramètres définis par l'utilisateur sont pris en compte par les stratégies de contrôle, dans la limite des contraintes imposées par la sûreté de fonctionnement.

==== Consultation des indicateurs et des alertes

Ce domaine permet à l'utilisateur de consulter les informations relatives au fonctionnement de la solution.
Il restitue notamment les indicateurs de suivi du sommeil, l'état des équipements et les éventuelles alertes de dysfonctionnement.
Il contribue ainsi à informer l'utilisateur sur le fonctionnement de la solution et à le rassurer quant à son bon fonctionnement.

=== 2.1.3 Generic Subdomains

==== Communication avec les équipements

Ce domaine assure les communications entre la solution et les équipements connectés en garantissant leur fiabilité et leur sécurité.
Il prend notamment en charge la persistance des messages importants afin de limiter les pertes de données ou de commandes, ainsi que le chiffrement des échanges sensibles.
Il contribue également à sécuriser les communications en s'appuyant sur des mécanismes d'authentification et de gestion des identités et des accès.

- *Persistance des messages importants*

    Assure la conservation des messages nécessitant une garantie de traitement ou de transmission, afin de limiter les pertes en cas d'interruption de communication.

- *Chiffrement des messages sensibles*

     Protège la confidentialité des échanges entre la solution et les équipements en empêchant leur lecture par des acteurs non autorisés.

- *Gestion des identités et des accès*

    Contrôle l'accès aux équipements connectés et aux interfaces de la solution en distinguant les utilisateurs autorisés des éventuels intervenants chargés de l'installation ou de la maintenance.

==== Récupération des données météorologiques

Ce domaine assure la récupération de données météorologiques externes susceptibles d'influencer les conditions de sommeil.
Ces données viennent compléter les mesures réalisées directement dans la chambre afin d'enrichir la représentation de l'environnement et de fournir des informations supplémentaires au système de décision.
Elles peuvent notamment contribuer à anticiper certaines variations environnementales et à adapter les stratégies de contrôle.


== 2.2 Context Map

#figure(
    image("./res/context-map.png", width: 135%),
    caption: "Context Map",
)

La context-map met en évidence quatre bounded contexts, chacun regroupant des responsabilités cohérentes au sein du système.

=== 2.2.1 Gestion de l'environnement de sommeil

Ce contexte regroupe les fonctionnalités permettant de préparer et de réguler l'environnement de la chambre afin de favoriser le sommeil.
Il s'appuie sur les mesures de l'environnement, les phases de sommeil, les données météorologiques ainsi que sur les préférences de l'utilisateur pour alimenter la prise de décision intelligente.
Les décisions prises sont ensuite traduites en actions sur les équipements connectés, notamment pour la préparation de l'environnement, sa régulation pendant la nuit et la gestion du réveil.

=== 2.2.2 Fine-tuning du modèle de prise de décision

Ce contexte est consacré à l'adaptation du système de prise de décision à partir des résultats observés au cours des nuits précédentes.
Il s'appuie sur l'évaluation de la qualité du sommeil et de son amélioration afin d'ajuster progressivement le modèle par apprentissage par renforcement.
Cette adaptation vise à améliorer les décisions futures, tout en conservant les mécanismes de décision et les contraintes définis par le système.

=== 2.2.3 Suivi du sommeil et des équipements

Ce contexte fournit à l'utilisateur une vue synthétique de l'évolution de son sommeil et de l'état des équipements présents dans sa chambre.
Il permet notamment de consulter les indicateurs de qualité du sommeil, les progrès réalisés au fil des nuits ainsi que les alertes et informations relatives aux équipements.
Il s'appuie sur les évaluations produites par le système et sur les informations transmises par les mécanismes de surveillance.

=== 2.2.4 Sûreté de fonctionnement

Ce contexte regroupe les mécanismes destinés à garantir le fonctionnement sûr du système et à protéger l'utilisateur.
Il surveille les équipements, détecte les anomalies et applique les règles de sécurité nécessaires, indépendamment des décisions adaptatives du système intelligent.
En cas de situation critique, il peut empêcher certaines actions, déclencher un mode de fonctionnement sûr ou transmettre une alerte à l'utilisateur.


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 3. Analyse de risques <toc-3>

== 3.1 Matrice des risques (non-exhaustive)

#figure(
    image("./res/risk-matrix.png", width: 125%),
    caption: "Matrice des risques",
)

- *Réveil :* un réveil en plein sommeil profond, tardif ou absent perturbe le sommeil ou compromet l'heure de réveil souhaitée.
- *Régulation thermique :* une défaillance du système chauffant perturbe le sommeil ; une surchauffe du sur-matelas peut même provoquer des brûlures.
- *Qualité de l'environnement :* une mauvaise qualité de l'air peut provoquer des céphalées, et l'humidité peut s'accumuler.
- *Évaluation et apprentissage :* une évaluation inadaptée du sommeil conduit à un apprentissage incorrect et dégrade les décisions du système.
- *Confiance de l'utilisateur :* une dégradation persistante du sommeil ou des dysfonctionnements répétés entraînent l'abandon de la solution.


== 3.2 Bowties

=== 3.2.1 Perte de contrôle du système chauffant

L'événement redouté est la perte de contrôle de la régulation thermique du sur-matelas pendant que l'utilisateur dort.
Il peut résulter d'une perte de communication, de mesures de température incorrectes ou d'une panne matérielle.
Il peut provoquer des brûlures, perturber le sommeil ou faire perdre la confiance de l'utilisateur.

#figure(
    image("./res/risk-bowties/bowtie-1.png", width: 125%),
    caption: "Perte de contrôle du système chauffant",
)

==== Barrières préventives

Trois menaces ont été identifiées :

- *Perte de signal :* les commandes de régulation ne parviennent plus au sur-matelas.
    Pour y palier, le monitoring du réseau détecte les anomalies et permet d'adapter les commandes (vitesse de chauffe, fréquence d'envoi).
    Aussi, un protocole réseau robuste et un *keep-alive* régulier complètent cette chaîne.
- *Capteurs de température erronés :* des mesures sous-évaluées ou sur-évaluées entraînent des décisions inadaptées.
    Ainsi plusieurs capteurs permettent de croiser les données.
    Et attribuer un score de fiabilité permet au système de compenser ou ignorer les capteurs défaillants.
- *Dysfonctionnement du sur-matelas :* une défaillance matérielle empêche la régulation.
    Contre les pannes matérielles, un monitoring détecte les dysfonctionnements et une maintenance régulière est prévue.

==== Barrières mitigatives

Si la perte de contrôle survient, une coupure d'urgence du sur-matelas est prévue.
Elle s'accompagne d'un réveil de l'utilisateur à partir de 40 °C et d'un *kill switch* volontaire du sur-matelas, pour limiter le risque de brûlure.
Une explication transparente de l'anomalie sur le portail limite la perte de confiance.
La température de la pièce peut aussi être augmentée ou diminuée pour compenser, dans une plage de 16 °C à 24 °C afin de préserver le sommeil lorsque la défaillance est minime.

==== Impact sur l'architecture

La régulation thermique est une fonction normale de la solution : elle adapte les commandes selon les températures mesurées.
La sûreté doit en être indépendante, afin de détecter une situation dangereuse et couper le chauffage même si la régulation est défaillante.

L'architecture doit aussi intégrer la détection des anomalies de communication et la surveillance des capteurs.

Enfin, la compensation par la température de la pièce exige une coordination entre le contrôle du sur-matelas et la régulation thermique de la chambre.

=== 3.2.2 Réveil progressif inopportun ou absent

L'événement redouté est le déclenchement incorrect du réveil progressif intelligent chez un utilisateur qui en dépend : trop tôt, pendant le sommeil profond, ou pas du tout.
Il peut perturber le sommeil, causer un réveil tardif ou faire perdre la confiance de l'utilisateur.

#figure(
    image("./res/risk-bowties/bowtie-2.png", width: 125%),
    caption: "Réveil progressif inopportun ou absent",
)

==== Barrières préventives

Trois menaces ont été identifiées :

- *Montre connectée injoignable* (perte de communication ou batterie faible) *:* ce qui empêche la détection des phases de sommeil.
    Un test de connexion et un test de batterie sont donc réalisés avant le coucher.
    En cas d'échec, le système bascule sur un réveil à heure fixe, s'il est configuré.
- *Erreur d'estimation de l'heure de réveil par l'algorithme*: une telle erreur causerait soit un réveil trop tôt soit un réveil trop tradif.
    C'est pourquoi la phase de sommeil est confirmée par plusieurs mesures successives, puis le déclenchement est vérifié par rapport à la fenêtre de réveil autorisée.
- *Dysfonctionnement des actionneurs de réveil*: un dysfonctionnement empêcherait le déclenchement du réveil progressif.
    Pour prévenir cela, les équipements sont testés avant le coucher, et la surveillance des accusés de réception détecte l'absence de réponse.

==== Barrières mitigatives

Un réveil trop précoce est détecté et interrompu immédiatement, et l'environnement de sommeil est restauré.
Si un ou plusieurs équipements du réveil progressif sont défaillants, la diachronie de l'activation des actionneurs limite le risque d'inaction complète du système.
_Le seul cas possible étant que tout les équipements soient défaillants ou injoignables._
De plus, un réveil de secours à heure fixe, indépendant de la solution (par exemple une alarme de téléphone), est également prévu.
Une explication transparente sur le portail limite quant à elle la perte de confiance.

==== Impact sur l'architecture

Le réveil progressif intelligent et le réveil de secours doivent être indépendant.
Le premier dépend de l'estimation de la phase de sommeil et de la fenêtre autorisée : il doit recevoir les données nécessaires et piloter les actionneurs.
Le second ne dépend que d'une configuration automtique ou manuelle préalable et de l'état des équipement relatif (ex: batterie du téléphone ou de la montre).
Cette séparation réduit la dépendance du réveil à l'intelligence du système et garantit l'heure de réveil souhaitée en cas de défaillance.

L'architecture doit détecter les défaillances d'équipements et pouvoir basculer en mode dégradé.

=== 3.2.3 Dérive du modèle de prise de décision

L'événement redouté est la dérive du modèle qui génère les consignes de contrôle de l'environnement de sommeil. Elle peut provenir de nuits atypiques intégrées à l'apprentissage, de données de capteurs de mauvaise qualité, de retours subjectifs erronés ou contradictoires, ou d'une fonction d'évaluation inadaptée. Elle dégrade la qualité du sommeil et la confiance de l'utilisateur.

#figure(
    image("./res/risk-bowties/bowtie-3.png", width: 125%),
    caption: "Dérive du modèle de prise de décision",
)

==== Barrières préventives

Quatre menaces ont été identifiées :

- *Nuits atypiques (maladie, substances) :* une détection d'anomalies biométriques par comparaison à la moyenne permet de les exclure du lot d'entraînement.
- *Données de capteurs de mauvaise qualité :* un filtrage et une validation des données brutes sont appliqués, puis les nuits sont pondérées par un indice de confiance.
- *Retours subjectifs erronés ou contradictoires :* la note de l'utilisateur est systématiquement croisée avec les métriques objectives.
- *Fonction d'évaluation inadaptée :* la fonction est validée avant son utilisation dans l'apprentissage.

==== Barrières mitigatives

Les paramètres de contrôle sont limités à des intervalles autorisés (bornes de sécurité), et les nouveaux paramètres sont validés avant usage, par exemple par simulation.
Le suivi du score d'évaluation détecte la dérive : s'il chute, un rollback automatique restaure un modèle précédent.
Une réinitialisation manuelle vers le modèle par défaut est aussi possible.

==== Impact sur l'architecture

La prise de décision et l'apprentissage doivent être séparés.
La première utilise le modèle courant pour produire des consignes à partir de l'état de l'utilisateur et de l'environnement.
Le second adapte les paramètres du modèle à partir de l'évaluation du sommeil.
Le modèle peut ainsi évoluer sans modifier directement les règles de décision ni les mécanismes de sûreté.

L'architecture doit également permettre de valider les nouveaux paramètres, de surveiller les performances du modèle et de revenir à un modèle précédent.

Les limites de sécurité doivent être indépendantes des paramètres appris, pour qu'une dérive ne puisse pas produire de consignes hors bornes.


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 4. Contraintes opérationnelles <toc-4>

== 4.1 Capteurs

#include "res/operating-constraints/sensors.typ"


== 4.2 Actionneurs

#include "res/operating-constraints/actuators.typ"


== 4.3 Edge

#include "res/operating-constraints/edge.typ"


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 5. Choix technologiques <toc-5>

== 5.1 Architecture réseau

// TODO: Développer & s'assurer que ça réponde aux contraintes opérationnelles et aux risques identifiés

#figure(
    image("./res/network.png", width: 125%),
    caption: "Architecture réseau",
)

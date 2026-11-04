/*
| Catégorie                    | Indicateur Clé de Performance (KPI)                         | Objectif / Cible                               |
|:-----------------------------|:------------------------------------------------------------|:-----------------------------------------------|
| **Qualité du sommeil**       | Évolution de l'écart avec un hypnogramme idéal (sur 30j)    | En baisse                                      |
|                              | Efficacité du sommeil (sur 30j)                             | En hausse                                      |
|                              | Approximation du cycle de sommeil par rapport au clinique   | 90%                                            |
|                              | Évolution des micro-réveils nocturnes                       | En baisse par rapport à l'état initial ($t_0$) |
| **Performance technique**    | Précision des capteurs après 100j de fonctionnement continu | 95% de maintien                                |
|                              | Données perdues / faussées                                  | < 5%                                           |
| **Expérience réveil**        | Taux de succès du réveil en phase de sommeil léger          | > 90% des réveils déclenchés en sommeil léger  |
|                              | Taux de fiabilité du réveil (respect de l'heure définie)    | 99,9% de réveils effectifs                     |
| **Satisfaction & Rétention** | Score de satisfaction utilisateur (après 30j)               | ≥ 4/5                                          |
|                              | Taux de rétention des utilisateurs actifs (à 30j)           | > 70%                                          |
 */

#box[
    #set text(size: 9pt)

    #pad(x: -1.5cm, table(
        columns: (auto, auto, auto),
        align: left,
        stroke: 0.5pt,
        inset: 6pt,

        table.header(
            [*Catégorie*],
            [*Indicateur Clé de Performance (KPI)*],
            [*Objectif / Cible*],
        ),

        // Qualité du sommeil
        table.cell(rowspan: 4)[*Qualité du sommeil*],
        [Évolution de l'écart avec un hypnogramme idéal (sur 30j)],
        [En baisse],
        [Efficacité du sommeil (sur 30j) ($"SE" = "ST" / "BT"$)],
        [En hausse],
        [Approximation du cycle de sommeil par rapport au clinique],
        [90%],
        [Évolution des micro-réveils nocturnes],
        [En baisse par rapport à l'état initial ($t_0$)],

        // Performance technique
        table.cell(rowspan: 2)[*Performance technique*],
        [Précision des capteurs après 100j de fonctionnement continu],
        [95% de maintien],
        [Données perdues / faussées],
        [\< 5%],

        // Expérience réveil
        table.cell(rowspan: 2)[*Expérience réveil*],
        [Taux de succès du réveil en phase de sommeil léger],
        [\> 90% des réveils déclenchés en sommeil léger],
        [Taux de fiabilité du réveil (respect de l'heure définie)],
        [99,9% de réveils effectifs],

        // Satisfaction & Rétention
        table.cell(rowspan: 2)[*Satisfaction & Rétention*],
        [Score de satisfaction utilisateur (après 30j)],
        [≥ 4/5],
        [Taux de rétention des utilisateurs actifs (à 30j)],
        [\> 70%],
    ))
]

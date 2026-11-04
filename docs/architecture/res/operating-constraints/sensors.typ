#box[
    #set text(size: 9pt)

    #pad(x: -1.5cm, table(
        columns: (1fr, 3fr),
        align: left,
        stroke: 0.5pt,
        inset: 8pt,

        table.header(
            [*Nom du capteur*],
            [*Contrainte opérationnelle*],
        ),

        [Thérmomètre],
        [Ce capteur sera accroché ou collé aux murs de la chambre. Il doit pouvoir se confondre au mur. Le capteur doit pouvoir resister aux dêpots divers (poussière, cigarette...) qui pourrais s'accumuler sans nettoyage par l'utilisateur. Il doit pouvoir capter les changements de température dans un environement au climat doux.],

        [Capteur d'humidité],
        [Ce capteur sera accroché ou collé aux murs de la chambre. Il doit pouvoir se confondre au mur. Le capteur doit pouvoir resister aux dêpots divers (poussière, cigarette...) qui pourrais s'accumuler sans nettoyage par l'utilisateur.],

        [Capteur de CO2],
        [Ce capteur sera accroché ou collé aux murs de la chambre. Il doit pouvoir se confondre au mur. Le capteur doit pouvoir resister aux dêpots divers (poussière, cigarette...) qui pourrais s'accumuler sans nettoyage par l'utilisateur.],

        [Montre connectée],
        [La montre doit offrir un confort utilisateur fort. Elle doit offrir les capteurs nécessaires à la mesure du cycle de sommeil. Elle doit aussi offrir une longue autonomie, afin d'assurer que des oublis de charge utilisateur ne bloquent pas obligatoirement un de nos core domain. La montre doit permettre le développement d'une application qui utilisera ses données capteurs afin de générer un cycle de sommeil approximatif entre l'instant t0 et l'instant t+60.],
    ))
]

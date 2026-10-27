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
    numbering: "1",
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


#set page(
    header: [#align(center)[_Architecture - Sleeping Beauty_]]
)


////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


= Table des matières

// NOTE: La table des matières peut changer

1. *Données capteurs*
    - ...

2. *Pré-traitement*
    - ...

3. *Architecture de la pipeline d'ingestion de données*
    - ...

4. *Choix technologiques*
    - ...


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


// TODO: ...

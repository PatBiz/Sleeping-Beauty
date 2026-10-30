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

1. #link(<toc-1>)[*Besoins business*]
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


= 1. Besoins business <toc-1>

// TODO: ...


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 2. Description de l'architecture <toc-2>

// TODO: ...


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 3. Analyse de risques <toc-3>

// TODO: ...


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 4. Contraintes opérationnelles <toc-4>

// TODO: ...


////////////////////////////////////////////////////////////////////////////////
#pagebreak()
////////////////////////////////////////////////////////////////////////////////


= 5. Choix technologiques <toc-5>

// TODO: ...

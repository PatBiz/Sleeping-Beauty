Notre documentation est un mixte de Typst et de Markdown.

Vous y trouverez :
- notre [architecture](./architecture/main.typ)
- notre [pipeline d'ingestion de données](./data-ingestion-pipeline/main.typ)
- ...

## Mettre en place un environnement Typst

### 1 - Installer Typst

- Sur Windows :
    ```sh
    winget install --id Typst.Typst
    ```
- Sur macOS :
    ```sh
    brew install typst
    ```
- Sur Linux :
    ```sh
    cargo install --locked typst-cli
    ```

### 2 - Configurer votre éditeur de code

> [!NOTE]
> Ici nous préciserons uniquement comment configurer VSCode.
> Toutefois, il est possible d'utiliser un autre éditeur de code.

- Installer les extensions recommandées (voir [.vscode/extensions.json](.vscode/extensions.json)) :
    - `Tinymist Typst` pour compiler les fichiers `.typ` en PDFs.
    - `vsocde-pdf` pour consulter des PDFs sur VSCode.
    - `EditorConfig for VS Code` pour se conformer au configuration générale du projet (voir [.editorconfig](.editorconfig))
- Ajouter les keybindings suivant à VSCode:
    ```json
    {
        "key": "ctrl+r",
        "when": "editorLangId == 'typst'",
        "command": "workbench.action.restartExtensionHost",
    }, {
        "key": "ctrl+shift+v",
        "when": "editorLangId == 'typst'",
        "command": "tinymist.showPdf",
    }
    ```

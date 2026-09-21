# Documentation — Project: ROG

Dossier pour les idées, specs et notes du jeu.

## Fichiers

| Fichier | Contenu |
|---------|---------|
| [GAME_DESIGN.md](./GAME_DESIGN.md) | Vision globale, mécaniques, lore, personnages |

## Structure du projet

```
assets/                 # sprites, audio, fonts (futur)
docs/                   # specs et notes de design
locale/                 # traductions i18n
scenes/
  ui/menus/             # ecrans menu (loading, main, options, saves)
scripts/
  autoload/             # singletons (LoadingManager, SaveManager…)
  ui/menus/             # scripts des ecrans menu
```

## Convention

- Un fichier par gros sujet (ex. `COMBAT.md`, `LEVELS.md`, `UI.md`…)
- Les sections `[À compléter]` = à remplir plus tard
- Nouvelles scenes : `scenes/<domaine>/`, scripts au meme chemin dans `scripts/`
- Pas de règle de format strict — l'important c'est que ce soit lisible

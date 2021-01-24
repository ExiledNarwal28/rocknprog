---
layout: post
title:  "Bases d'un repository sur GitHub"
date:   2021-01-24
categories: [project, git]
lang: fr
lang-ref: github-repository-basics
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/vl7yvB4-WmQ" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Salut! Aujourd'hui, on monte les bases de notre repository sur GitHub.

Dans les derniers articles, on a concentré nos efforts sur de la documentation de planification du projet, qu’on a mis dans le wiki. C’est assez. On commence à mettre des fichiers dans notre repo. On va commencer par créer les fichiers de documentation importants à avoir dans notre repo. Ensuite, on va jaser des différentes sections qu’on va utiliser pour le projet.

## Fichiers de documentation

On va faire quatre fichiers ensemble, soit la licence, le code de conduite, le guide de contribution et le README. On va commencer avec la licence et le code de conduite, vu qu'ils peuvent être autogénérés.

### `LICENSE`

C’est ben important de choisir une licence appropriée pour notre application. Ça va influencer comment les gens peuvent utiliser votre travail.

Alright, comment on choisit notre licence? J’m’embarquerai pas dans les aspects légaux pis les différences entre les licences. J’vous envoie sur le site [Choose a License](https://choosealicense.com/), qui torche pour expliquer tout ça.

Moi, j’me sers de Creative Commons pour mon site web, mes vidéos et le projet, vu que c’est du matériel éducatif et fictif. J’ai choisis [BY-NC-SA version 4](https://creativecommons.org/licenses/by-nc-sa/4.0/), qui stipule que :

- Les gens peuvent partager mon application et mon code ;
- Les gens peuvent fork mon repo et modifier mon application pour adapter ça à leurs besoins ; 
- Que ce soit pour partager ou modifier mon code, il faut mentionner que ça vient de moi (BY) ;
- Mon application et ses éventuelles modifications ne peuvent pas servir à faire du profit (NC) ;
- La licence que j’utilise doit être utilisée pour chaque futur partage et modification de mon code (SA).

Pour avoir la licence en markdown sur mon repo GitHub, je me sers du [repo de Jan T. Sott](https://github.com/idleberg/Creative-Commons-Markdown), qui contient des versions à jour de licences Creative Commons prête à être utilisée. Dans mon README, je vais mentionner que ça vient de lui.

En passant, quand vous faites une licence sur GitHub, il suffit d’écrire `LICENSE` comme nouveau nom de fichier à la racine de votre codebase et GitHub va vous proposer plusieurs licences déjà faites. Pratique.

Ma licence est assez longue, alors, plutôt que l'écrire ici, je vous envoie sur mon repo pour la voir : [https://github.com/ExiledNarwal28/space-elevator/blob/main/LICENSE.md](https://github.com/ExiledNarwal28/space-elevator/blob/main/LICENSE.md)

### `CODE_OF_CONDUCT.md`

Good, le code de conduite. Ça décrit comment l’équipe derrière un projet s’engage à contribuer à la communauté.

Celui-là est assez simple, j’vous recommande d’utiliser un de ceux que GitHub propose. Comme la licence, il suffit d’écrire `CODE_OF_CONDUCT.md` comme nom de fichier à la racine de votre codebase et vous allez avoir des choix.

Perso, j’utilise le [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/). En gros, c’est un code de conduite basé sur l’entraide et le bien-être de la communauté open-source.

Encore une fois, ce fichier est assez long. Alors, plutôt que l'écrire ici, le voici sur mon repo : [https://github.com/ExiledNarwal28/space-elevator/blob/main/CODE_OF_CONDUCT.md](https://github.com/ExiledNarwal28/space-elevator/blob/main/CODE_OF_CONDUCT.md)

### `CONTRIBUTING.md`

Good, on a fini avec les documents autogénérés. On passe au guide de contribution.

Le guide de contribution c’est la description des processus pour modifier le codebase. C’est comment, étape par étape, on veut que notre code soit changé, ajouté ou supprimé. Quand le code de conduite n’est pas directement écrit ici, on le référence au moins, vu que c’est très lié.

Perso, je me traîne un template de projet en projet que j’adapte. J’ai ça comme sections :

- Une référence vers le code de conduite, en premier, parce que c’est fucking important ; 
- Un guide de suivi de tâches ;
- Un guide de développement ;
- La liste des gens qui ont contribué au projet.
  
Le guide de suivi de tâches et le guide de développement ont des sous-sections. Checkons ça ensemble.
  
#### Guide de suivi de tâches

D’abord, j’explique que je me sers du wiki pour décrire les fonctionnalités à implémenter dans l’application. J’dis aussi que c’est là qu’on peut trouver les stories et les use-cases, ainsi que toute la documentation de planification. C’est important de parler de ça en premier, parce que c’est la première étape du suivi de tâche : le besoin. Donc, ce qu’on décrit avant même de créer une tâche (une issue).

Ensuite, je dis que les tâches seront trackées avec GitHub. On va se servir des issues. Je vais aussi décrire la manière dont on planifie les milestones, qui utiliseront le même versionnage que les releases, qui suit le [Semantic Versioning 2.0.0](https://semver.org/). Basically, c’est de représenter les numéros de versions en trois nombres : majeur (breaking changes), mineur (non-breaking changes) et patch (bug fix).

Prochaine section : le project board. Je décris comment je groupe les issues dans un tableau kanban. On va y revenir plus tard dans l'article.

Next, je parle du bug reporting. D’abord, je dis clairement que, dans ma définition, un test (unitaire, intégration ou end-to-end) qui ne passe pas est un bug. Juste pour enlever cette confusion. Après ça, je dis que les bugs spottés doivent être reportées sous forme d’issue avec le bon template. Ensuite, on les place dans le project board, dans la colonne `To do`, en haut des issues qui ne sont pas des bugs.

Ensuite, on parle de pull requests. J’informe les gens qu’on se sert de [Git Flow](https://datasift.github.io/gitflow/IntroducingGitFlow.html), qui permet de structurer clairement les noms des branches, ce qui a pour effet direct de clarifier les PRs. Je dis que chaque PRs doit passer le CI check et avoir 2 approvals. Je dis comment je veux que les PRs soient nommées et à quel genre de review je m’attends. Ça sert aussi de guide pour faire une bonne review.

Dans cette section, je dis aussi que notre branche de développement est `develop`. La branche principale, celle du code stable, est `main`. Sidenote : GitHub a droppé le standard de nommer la branche principale `master`, vu que ça faisait référence à de l’esclavage. Je vous encourage fortement à suivre ce trend. Anyway, `main`, ça fait du sens et ça commence aussi par `m`, alors on s’en rappelle bien.

Finalement, on a la definition of done. J’explique qu’un milestone est terminé lorsque toutes ses issues le sont et qu’une issue est terminée quand tous ses requirements sont fulfilled et que sa PR est merged.

#### Guide de développement

Le guide de développement concerne l’aspect technique du codebase.

Ça commence par le code style. Je dis quel code style je me sers pour chaque langage utilisé. Ici, j’ai juste Java à mentionner. Je donne aussi la commande pour formater le code. Je dis aussi que je veux voir aucun commentaire dans le code, mis à part des TODOs qui peuvent aider à se retrouver entre les issues. Par contre, je veux pas de TODOs quand on merge dans `main`.

J'vais faire une parenthèse pour ça : quand je dis "pas de TODOs", c'est qu'il est préférable d'en faire des issues. Un IDE peut trouver tous les TODOs du codebase, ce qui permet de garder la location de changements à faire. Pour ça, c'est chill. Par contre, logiquement, quand on merge dans `main`, on veut transformer les TODOs restant en issues. Une bonne idée, c'est d'écrire nos TODOs comme ça `TODO #123 : Implement InMemoryAccountRepository.get(...)` où "123" est le numéro de l'issue associée. C'est donc plus facile, lorsqu'on travaille sur cette issue, de voir où nos changements sont à faire.

Pour les commentaires, si votre code est bien fait et que votre archi suit un modèle DDD, c'est bien rare que les commentaires sont utiles. Votre code est assez lisible pour être compris. Voilà pourquoi je préfère simplement dire que j'en veux pas dans mon codebase. Plusieurs commentaires qui explique ce qui se passe, c'est un code smell. Y'a moyen de faire mieux!

Ensuite, je dis que tout le code doit être fait en TDD (Test Driven Development), soit d’écrire les tests unitaires avant d’implémenter le code. Je décris où sont les tests et comment on les écrit.

Good, on a fini avec le guide de contribution! Voici ce que ça donne : 

<script src="https://emgithub.com/embed.js?target=https%3A%2F%2Fgithub.com%2FExiledNarwal28%2Fspace-elevator%2Fblob%2Fmain%2FCONTRIBUTING.md&style=github&showBorder=on&showLineNumbers=on&showFileMeta=on"></script>
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/blob/main/CONTRIBUTING.md))*

### `README.md`

Alright, vous savez probablement tous ce qu’est un README. C’est la première chose qu’on voit en arrivant sur votre repo. On va y mettre les informations les plus importantes sur votre projet, comment le démarrer et des liens vers les ressources à connaître pour contribuer.

Le site [Make a README](https://www.makeareadme.com/) est très utile pour faire votre propre README. Je le consulte souvent pour me rappeler les sections importantes.

D’abord, on va écrire le nom du projet et l’expliquer brièvement. Directement après le nom du projet, c’est là qu’on va mettre les badges, quand on en aura. Par exemple, j’aime bien montrer les statuts du CI, CD et des tests end-to-end. Le code coverage et le code quality peuvent aussi être pratiques. Le site [shields.io](https://shields.io/) a plusieurs badges faciles à intégrer, si vous voulez.

Dans la partie d’installation, on va expliquer comment installer les dépendances et builder le projet avec Maven.

Ensuite, on va expliquer comment utiliser l’application. Il suffit de donner la ligne de commande pour exécuter le projet et de dire sur quel URL le retrouver. Quand on aura une documentation d’API, ça vaudrait la peine de la lier ici.

Après ça, on parle de la contribution. Évidemment, il faut référencer le guide de contribution. On donne ensuite les commandes pour rouler les tests, créer un rapport de code coverage, appliquer le code style et générer la documentation d’API.

Finalement, on va référencer notre licence.

Ouin, là j’me rend compte que mon README est pas mal pareil que ceux de mes projets d’école en Java, mais, hey, tu changes pas une formule gagnante. Voici ce que ça donne :

<script src="https://emgithub.com/embed.js?target=https%3A%2F%2Fgithub.com%2FExiledNarwal28%2Fspace-elevator%2Fblob%2Fmain%2FREADME.md&style=github&showBorder=on&showLineNumbers=on&showFileMeta=on"></script>
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/blob/main/README.md))*

## Sections du repository

Alright, on a fini les documents qui expliquent le projet pis comment on le fait. Chill. On passe aux sections du repo!

D’abord, juste là où on entre dans le repo, c’est bien de laisser des tags pour chaque technos utilisées et ce qui a rapport à l’app. Je vais laisser ça vide pis remplir au fur et à mesure que j’implémente des trucs.

### Issues et issue templates

D’abord, on va jaser d’issues. Quossé ça? C’est les tâches à faire dans l’app. J’vais les voir vite, parce qu’on va en créer dans le prochain article. En gros, gardez en tête que chaque issue aura :

- Un titre évocateur ; 
- Une référence vers un use-case et/ou story ; 
- Des étapes pour être considéré comme complété ; 
- Des étapes pour reproduire un bug, dans le cas des issues de bug ; 
- Une personne attitrée ; 
- Des étiquettes, pour filtrer tout ça ; 
- Un milestone associé ; 
- **UNE PULL REQUEST**. Un issue = un PR. La seule raison qu’il y en a plusieurs, c’est qu’on réouvre l’issue.
  
Savez-vous ce qui aide as fuck? Les templates d’issues. En gros, quand une personne crée une nouvelle issue, on peut fournir des modèles déjà faits pour aider à écrire l’issue comme il faut.
  
J’aime bien en avoir trois : un pour les bugs, un pour les features et un pour les features, mais version simplifiée. On va les voir ensemble.

Les templates d’issues, on les place dans `.github/ISSUE_TEMPLATE`. Ça commence par du YAML, où on peut préciser le nom du template et des settings de base.

Prenons le template de bug report, on veut décrire le bug, donner les steps pour le reproduire et expliquer ce qu’on veut qui se produise normalement. On laisse aussi des espaces pour les screenshots et l’info additionnelle, si besoin est.

<script src="https://emgithub.com/embed.js?target=https%3A%2F%2Fgithub.com%2FExiledNarwal28%2Fspace-elevator%2Fblob%2Fmain%2F.github%2FISSUE_TEMPLATE%2Fbug_report.md&style=github&showBorder=on&showLineNumbers=on&showFileMeta=on"></script>
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/blob/main/.github/ISSUE_TEMPLATE/bug_report.md))*

Alright, et pour les features à implémenter? On commence par les tâches à accomplir pour terminer l’issue. Ensuite, on décrit réellement ce qu’on veut implémenter et on donne du contexte additionnel, si c’est nécessaire.

<script src="https://emgithub.com/embed.js?target=https%3A%2F%2Fgithub.com%2FExiledNarwal28%2Fspace-elevator%2Fblob%2Fmain%2F.github%2FISSUE_TEMPLATE%2Ffeature_request.md&style=github&showBorder=on&showLineNumbers=on&showFileMeta=on"></script>
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/blob/main/.github/ISSUE_TEMPLATE/feature_request.md))*

Good! Pis pour la version simplifiée? Celle-là, je la fais d’avance pour les rush de fin d’itération. Rendu là, on a souvent en masse conscience de c’qui faut ajouter pis on veut juste créer des issues pour se souvenir de faire certaines choses. J’recommande pas de s’en servir, mais j’t’un calisse de cowboy. C’est la même chose que l’autre template de features, mais c’est juste une liste de tâches.

<script src="https://emgithub.com/embed.js?target=https%3A%2F%2Fgithub.com%2FExiledNarwal28%2Fspace-elevator%2Fblob%2Fmain%2F.github%2FISSUE_TEMPLATE%2Ffeature_request_simple.md&style=github&showBorder=on&showLineNumbers=on&showFileMeta=on"></script>
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/blob/main/.github/ISSUE_TEMPLATE/feature_request_simple.md))*

Perf, on va faire les issues de notre première itération au prochain article.

### Project board

Good, regardons un peu les autres sections du repo. D’abord, le project board!

Celui-là, on va le garnir au prochain article. J’vais quand même expliquer vite comment moi je le fais!

D’abord, je place que des issues. Vu qu’une issue a une seule PR, pas besoin de mettre les PRs.

Checkons les colonnes ensemble :

- `Maybe` : C’est les trucs importants à mettre au backlog. C’est pas juste des features, c’est des trucs qui doivent être implémentés, mais pas tout de suite. J’met ça parce que je - préfère avoir une colonne `Maybe` que d’archiver des issues qui sont importantes.
- `To do` : C’est les issues de l’itération en cours.
- `In progress` : Les issues qu’on est en train de travailler dessus
- `Under review` : Les issues qui ont une PRs prête à être review ou en train de se faire review. On garde les issues là quand on a des modifications à faire suite à une review.
- `Done` : Yeah, c’est merged dans `develop`!
  
On pourrait avoir un autre colonne pour différencier les issues réglées dans `develop` et dans `main`. J’pense pas avoir besoin de ça, mais c’est une bonne idée.

Sérieux, j’encourage toutes les teams à utiliser un tableau en kanban comme le project board de GitHub pour leur issue tracking. Pas juste les product owners et scrum masters et tralala. Tous les devs. Ça parle pas ben ben une liste de issues quand c’est planifié pour une grosse période de temps. Ce qui parle, c’est un tableau comme ça, où on peut visualiser notre progression.

### Wiki

Bon, j’vais vous parler du wiki, mais crisse j’tanné de le voir, on fait juste ça depuis le début du projet.

Dans mes cours, quand j’avais des rapports à produire, c’est là que je les mettais. Sinon, c’est l’endroit idéal pour mettre la documentation de planification, donc les stories, use-cases et tout le beau kit.

Si vous faites une librairie ou un package utilisé par plusieurs personnes et que vous avez pas de site web pour hoster votre doc, c’est aussi une bonne place pour mettre ça. Vous pouvez structurer votre sidebar comme il faut, ça aide à se retrouver. Le footer c’est une bonne place pour mettre vos infos générales qui sont vraies pour chaque page.

### Settings

Alright! Les settings. Ici, vous pouvez choisir quelles sections afficher dans votre repo. Par exemple, si vous vous servez pas du wiki ou du project board, enlevez-les.

Moi, y’a deux choses primordiales que je fais dans les settings : je déploie un GitHub pages pour la documentation d’API et je protège les branches principales (`main` et `develop`).

Présentement, j’ai pas de doc d’API. Je vais montrer comment utiliser les GitHub pages rendu là.

Pour ce qui est de la protection de branche, j’vous recommande de setter 2 review approvals, un CI check qui passe et une branche à jour avant de merge les PRs. Ça va vous éviter de mettre du code pas stable et pas trustable dans vos bonnes branches. De mon bord, évidemment, je mettrai pas 2 review approvals, vu que je travaille seul, mais vous comprendrez que c’est important en équipe.

## Conclusion

Good, ça fait pas mal le tour! GitHub c’est huge et c’est très configurable. Si vous avez des questions avec vos repos, hésitez pas à me laisser un commentaire sur YouTube (ou sur mon site, quand j'vais avoir configuré ça!).

Le prochain article est quand même cool : on va décider notre première itération et faire les issues pour ça. J’vais me servir du project board pour structurer la suite de tâches à faire.

À la prochaine, salut là!

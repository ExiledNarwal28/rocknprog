---
layout: post
title:  "De fonctionnalités à récits (stories)"
date:   2020-12-31
categories: [project, documentation]
lang: fr
lang-ref: functionalities-to-stories
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/T-DEoxwhnQA" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Salut!

Aujourd’hui, je vous présente la première partie d’un guide pour aller d’une liste de fonctionnalités à des récits à des cas d’utilisations. J’ai décidé de le couper en deux pour présenter plus en détail les concepts. Si vous voulez voir comment écrire des cas d’utilisations à partir de récits, sautez au prochain article, [“De récits à cas d’utilisation (use-cases)"]({% post_url 2021-01-08-stories-to-use-cases %}).

Bon.

J’avais parlé d’un ascenseur spatial. Mais on fait quoi au juste?

Honnêtement, j’vais fournir des consignes pour c’qu’on a à faire, j’ai choisi des trucs de base. En gros, je vais une liste de fonctionnalités qu’on veut dans notre livrable final. Mais, spoiler alert, y’a des chances qu’on les fasse pas toutes pis y’a des chances qu’on en ajoute.

L’affaire, c’est que ce projet-là sert à couvrir des concepts de développement logiciel intéressants. Si deux cas d’utilisation différents demandent les mêmes patrons de conceptions et les mêmes technos, j’risque de juste pas le faire ou de le faire en dehors des vidéos / articles.

Aussi, j’pars de des fonctionnalités de base pis on va construire ensemble les récits et cas d’utilisation précis qu’on veut. Pourquoi? Parce que, que ce soit à la job ou à l’école, vous allez partir votre projet d’une liste de fonctionnalités, de récits ou de cas d’utilisation. Donc, j’préfère commencer du début et, si vous voulez, vous pouvez aller directement lire ce qui vous intéresse. La chose que je ferai pas, c’est de partir d’avant la liste de fonctionnalités. Ça, j’suis désolé, mais si vous avez juste une idée vague ou une pitch de vente, j’vous donne la responsabilité de trouver les fonctionnalités de votre app. Mais inquiétez vous pas, c’est pas plus compliqué que de vous demander ce que vous voulez que l’app fasse pour vous.

## Fonctionnalités

Ok.

Voici la liste de fonctionnalités que j’ai écris pour l’application de gestion d’un ascenseur spatial. J’ai fait ça vite sur un wiki GitHub, mais on va revenir à GitHub dans une autre article.

```markdown
 - User creation
 - One-time use passes
 - Period passes (single date, many dates, week or month)
 - Usage of passes to access the elevator
 - Transactions and bills
 - Reporting of events
 - Authentication on sensible routes
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Functionalities))*

Donc, ça c’est les fonctionnalités auxquelles j’ai pensé. On va peut-être en ajouter d’autres, j’vous laisse me donner des suggestions. Mais, par contre, sachez qu’avant même de sauter dans le code, j’ai beaucoup de choses à couvrir parce que je tiens à partir de zéro.

Good, donc, on est rendu à la prochaine étape : les récits (et personas). J’ai eu des projets où on me donnait directement les récits plutôt que juste les fonctionnalités. Comme c’est pas toujours le cas, on va faire ça ensemble.

## Personas

La première étape, c’est de déterminer les personas. C’est quoi ça? C’est des utilisateurs types de votre application. Normalement, on ferait la job de leur donner un nom et une vie et plein de trucs qui ont rapport à l’application pis pas en même temps, mais on va juste y aller avec un nom et une fonction pour tout de suite. Moi, dans l’app, j’en vois deux. On va avoir l’utilisateur qui utilise l'ascenseur et la personne qui va chercher les rapports. Si on avait d’autres fonctionnalités, genre vérifier les conditions de l’ascenseur ou lister le personnel, on aurait d’autres personas. Mais là, pas besoin.

![Exemple de persona](/public/img/posts/example-persona.png)
*(exemple de persona, tiré du [blogue de Roman Pichler](https://www.romanpichler.com/blog/persona-template-for-agile-product-management/))*

Aussi, side note, c’est bon d’avoir plusieurs personas pour les mêmes fonctionnalités. Par exemple, pour l’achat de passes, y’a beaucoup de monde différent qui peuvent faire les mêmes actions. Ces gens-là ont pas tous le même background et les mêmes besoins. Là, on fait un API qui reçoit des requêtes simples, on fait pas un site web ou une app mobile par dessus. Par contre, si on avait à le faire, c’est bon d’avoir en tête plusieurs façon différentes d’utiliser l’app pour accommoder tout le monde!

Donc, comment on les nomme nos deux personas? Moi je dis que l’utilisateur qui achète des passes et qui se sert de l'ascenseur c’est Bob. Pis la personne qui crée des rapports, c’est Alice. Les noms, ça l’air niaiseux, mais ça ajoute du piquant à notre doc pis ça nous rappelle qu’on fait ça pour du monde, pis pas juste pour des données qui passe d’un boutte à l’autre de l’app.

J’vais vous laisser lire ce que j’ai écrit. Yep, c’est en anglais (comme les fonctionnalités). Au moment où c’est dans le repo et le codebase, je pense qu’on doit produire de quoi qui peut être compris par la plus grande quantité de monde possible. Ça aide au partage de connaissance et ça permet d’ouvrir les frontières de qui peut potentiellement aider avec le projet!

```markdown
## Bob - User of passes

 - Wants to use the space elevator for one-time uses
 - Wants to use the space elevator for periodic uses
 - Wants (?) to pay their bills

## Alice - Administrator of the elevator

 - Wants to create reports of user creation
 - Wants to create reports of access pass creation
 - Wants to create reports of bill payments
 - Wants to create reports of elevator usage
 - Wants nobody else to access reports creation
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

## Récits (stories)

Good, les personas c’est fait! On passe aux récits / stories. C’est quoi ça? C’est des histoires qui représentent une personne qui utilise l’application pour une raison. C’est le step avant les cas d’utilisation. C’est plus global, pis ce qu’on peut montrer à nos boss et à notre clientèle pour que ça soit compris sans que ça devienne trop technique.

![Exemple de récit (story)](/public/img/posts/example-story.png)
*(exemple de récit (story), tiré de [Aha!](https://www.aha.io/roadmapping/guide/requirements-management/what-is-a-good-feature-or-user-story-template))*

Ok, on va voir trois stories ensemble pis je vais présenter vite le reste. On va faire la création d’utilisateur et l’achat de passe.

Une bonne pratique est de regrouper les récits dans des aventures (ou epics), qui regroupent les récits qui vont ensemble.

On a Bob. Bob veut acheter des passes d’accès. Pour ça, il doit d’abord se faire un utilisateur et ensuite acheter une passe. On a besoin de quelles informations? Normalement, je dirais que le courriel et le nom c’est en masse. Par contre, on doit penser à ce qu’on a besoin dans l’app. On fait quoi? On fait une app de gestion d’ascenseur spatial. Là, c’est fictif mais on va quand même faire comme si. On a besoin d’un courriel parce que ça va être un identifiant unique pis, ben, c’est toujours pratique. Mais à part ça? Moi je dis qu’on a seulement besoin du poids pis de la taille. En tout cas, c’est ce qu’on va assumer.

```markdown
### Adventure 1 : User creation

#### Story 1 : User creation

Bob wants to create a user. They enter the following information : 

 - Email address
 - Full name
 - Height in centimeters
 - Weight in grams
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Good. Aventure 2 : Achat de passe. On va voir ensemble le récit pour l’achat de passes à accès unique.

On a besoin de quoi? Comme on a pas de concept de catégorie de passe et qu’on n’a pas vraiment besoin d’autres informations (ou du moins, à ce que je sache), on va seulement demander de préciser que la passe est pour un accès unique. Ensuite, j’aime bien préciser ce qu’on veut qui arrive lorsqu’on achète une passe. C’est pas toujours explicite dans les récits qu’on nous donne, mais je pense que ça aide énormément de ne pas laisser de place au doute. Ici, on veut avoir un code pour la passe et on veut qu’une facture soit créée pour Bob.

```markdown
### Adventure 2 : Access pass creation

#### Story 1 : One-time access pass creation

Bob wants to buy a one-time use access pass. This pass allows Bob to enter and leave the space station using the elevator. To create this pass they need to : 

 - Specify this is a one-time use access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob.
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

On va en voir un dernier ensemble et après je vous montre le reste. On va faire l’achat d’une passe pour une date donnée. On a besoin de quoi dans ce cas-là? Pour l’instant, je pense qu’on peut simplifier ça et seulement envoyer la date.

Oh! Mais on peut envoyer plusieurs dates non? Les fonctionnalités listent des passes d’accès pour une date, plusieurs dates, une semaine ou un mois. C’est vrai. Par contre, pour ce qui est des récits, pas besoin de préciser le format de requête à envoyer à l’API. Ça, on va s’occuper de ça dans les cas d’utilisation, où on va écrire explicitement le JSON à envoyer et à recevoir.

Voici ce que j’ai écrit : 

```markdown
#### Story 2 : Periodic access pass creation for a single date

Bob wants to buy a periodic access pass for a single date. This pass allows Bob to enter and leave the space station using the elevator anytime they want within the given date. They enter the following information : 

 - Date for access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob.
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Ok, on s’éternise. Je vais montrer vite le reste des récits avec vous et préciser ce qui est important.

Pour l’aventure 2, la création / achat de passes d’accès, il suffit d’avoir un récit par période de passe d’accès et un récit pour lister les passes. Encore une fois, je mets le paquet pas mal. Je préfère avoir trop d'informations sur ce qu’on doit faire que pas assez. Oubliez pas que dans un contexte scolaire, vous pouvez ajouter des récits pour vous, si vous trouvez que trop de choses sont implicites et méritent de la précision!

```markdown
#### Story 3 : Periodic access pass creation for many dates

Bob wants to buy a periodic access pass for a many dates. This pass allows Bob to enter and leave the space station using the elevator anytime they want within the given dates. They enter the following information :

- Dates for access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob.

#### Story 4 : Periodic access pass creation for a week

Bob wants to buy a periodic access pass for a week. This pass allows Bob to enter and leave the space station using the elevator anytime they want within the given week. They enter the following information :

- Week for access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob.

#### Story 5 : Periodic access pass creation for a month

Bob wants to buy a periodic access pass for a month. This pass allows Bob to enter and leave the space station using the elevator anytime they want within the given month. They enter the following information :

- Month for access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob.

#### Story 6 : Listing access passes

Bob wants to know which access passe they own. Access passes that are not available anymore must be at the end. Other access passes must be ordered by date (earliest not-passed date for many dates and start date for week and month).
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Aventure 3 : Accès à l’ascenseur. Bon. En écrivant j’me dis qu’une belle upgrade à l’app c’est qu’on fasse des voyages de monde, plutôt que donner toujours accès à une personne pour l'ascenseur. Fuck, ben ça va dans le backlog. Pas grave.

On va juste avoir deux récits : un pour monter et un pour descendre jusqu’à la station au bout de l’ascenseur.

```markdown
### Adventure 3 : Elevator access

#### Story 1 : Going up

Bob wants to use their access pass to ascend. They enter only the access pass code.

Of course, Bob can only ascend if they are on Earth.

#### Story 2 : Going down

Bob wants to use their access pass to descend. They enter only the access pass code.

Of course, Bob can only descend if they are up in the station.
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Aventure 4 : Payer des factures. On veut seulement payer et lister les factures pour Bob. Pour payer, ça va prendre le numéro de facture, qu’on peut obtenir en listant nos factures. Makes sense.

```markdown
### Adventure 4 : Bill payment

#### Story 1 : Paying a bill

Bob wants (?) to pay their bill. To do so, they only enter the bill number. They only need to enter the amount to pay.

#### Story 2 : Listing bills

Bob wants to list their bills. Bills must be ordered by date. Paid bills are placed at the bottom.
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Si vous avez pas remarqué jusqu’à date, je catégorise un peu mes récits en calls de REST API. On va revenir à ce que c’est ça, mais si vous savez c’est quoi, wink wink.

Dernière aventure, 5 : Les rapports.

Pour ça, on va utiliser une architecture de rapport style scope-period-dimension-metric. On va revenir à ces concepts là dans un autre article, mais en gros, chaque récit est techniquement une métrique qu’on veut calculer dans l’app. On peut aggloméré les données (genre, max, min, …) et on peut dimensionner (séparer) les données des métriques selon des critères. Ça se peut que ça semble nébuleux et overkill, mais c’est le fun pis c’est propre fait que eh.

![Architecture de reporting](/public/img/posts/diagram-reporting.png)
*(architecture de reporting de style scope-period-metric-dimension)*

```markdown
### Adventure 5 : Event reporting

Annie wants to report events happening in the app. For this, they want to use a scope-period-metric-dimension style reporting.

All reports can be displayed as : 

 - Grouped by day, week, month, quarter or year
 - Aggregated by maximum, minimum, average and median

#### Story 1 : User creation reporting

Annie wants a report of user creation by date. This can be displayed as : 

 - Dimensioned by if they have a bill or not
 - Dimensioned by if a bill has payment or not
 - Dimensioned by if a bill was fully paid or not

#### Story 2 : Access pass creation reporting

Annie wants a report of access pass creation by date. This can be displayed as : 

 - Dimensioned by period type
 - Dimensioned by if a bill has payment or not
 - Dimensioned by if a bill was fully paid or not

#### Story 3 : Bill creation reporting

Annie wants a report of bill creation by date. This can be displayed as : 

 - Dimensioned by if bill code (reason)
 - Dimensioned by if bill has payments or not
 - Dimensioned by if bill is fully paid or not

#### Story 4 : Bill payment reporting

Annie wants a report of bill payment by date. This can be displayed as : 

 - Dimensioned by if bill has payments or not
 - Dimensioned by if bill is fully paid or not

#### Story 5 : Elevator usage reporting

Annie wants a report of elevator usage by date. This can be displayed as : 

 - Dimensioned by if bill has payments or not
 - Dimensioned by if bill is fully paid or not
 ```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Yah! Fini!

Y’a un truc que je mets pas dans les stories. L’authentification. Créer un utilisateur ne requiert pas de sécurité puissante, mais il faudrait bien s’assurer qu’une personne qui utilise une passe d’accès est bien la personne qui l’a achetée, non? Idem pour payer une facture. Pour ça, on se cassera pas le bicycle et on va juste envoyer le code de la passe d’accès ou le numéro de la facture. Une meilleure authentification, ça sera un nice-to-have pour plus tard, disons.

Un autre truc que j’ai pas encore mentionné, c’est le prix des passes d’accès. Ça pourrait être indiqué dans les récits, mais pour notre projet, on va seulement utiliser un fichier statique qui liste les prix en fonction des périodes des passes d’accès.

Boooooon.

Alright la gang, on a des récits. J’espère que cet article vous a aidé à mieux comprendre comment passer d’une liste de fonctionnalités à des aventures et des récits. Et, aussi, c’est quoi tout ça.

Dans le prochain article, on va passer de récits à des cas d’utilisation, des use-case.

Aight, salut là!

 - [Wiki du projet, où toute la documentation énoncée est disponible](https://github.com/ExiledNarwal28/space-elevator/wiki)

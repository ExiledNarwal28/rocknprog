---
layout: post
title:  "Têtes d'agrégats et conceptualisation de domaine"
date:   2021-01-13
categories: [project]
lang: fr
lang-ref: aggregate-heads-and-domain-conceptualization
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/33cKvBi4MAE" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Salut!

Hey, c’est l’heure de faire des dessins. Dans les derniers articles, on a établi la liste de fonctionnalités de l’app qu’on a transformée [en récits]({% post_url 2020-12-31-functionalities-to-stories %}), puis en [cas d’utilisation]({% post_url 2021-01-08-stories-to-use-cases %}). Maintenant, on a une bonne idée des différents concepts qui vont être dans l’app. On va faire des beaux diagrammes.

Je ne veux pas m'embarquer dans des diagrammes plus formels, comme des [diagrammes UML](https://en.wikipedia.org/wiki/Unified_Modeling_Language) ou de la [documentation C4](https://c4model.com/). Ces deux-là peuvent être très utiles, particulièrement la documentation C4, qui permet de décortiquer les composantes d'une application en début de projet. Je veux plutôt avoir un diagramme simple des classes principales de mon domaine. Le but est simplement d'illustrer les liens entre les concepts importants qu'on va avoir à implémenter.

## Pis c'est quoi ça, un domaine?

Le [domaine](https://en.wikipedia.org/wiki/Application_domain) c’est le cœur de votre application. C’est là que vous mettez la logique, les règles et les liens entre vos différents concepts. Le but c’est d’isoler entièrement le centre de votre app de tout ce qui concerne les technologies utilisées. En plus de ça, vous voulez séparer votre domaine en packages, en modules, qui dépendent les uns des autres le plus simplement possible. Idéalement, la dépendance ne sera jamais circulaire.

Par exemple, ça fait du sens que les passes d’accès connaissent les concepts d’argent, ou au moins juste de facture. Le contraire, par contre, non. Une facture ne doit pas connaître ce qu’est une passe d’accès. Pourquoi elle le ferait?

Du [domain-driven design (DDD)](https://en.wikipedia.org/wiki/Domain-driven_design) c'est de décrire votre domaine applicatif comme vous décrivez vos récits. C'est de coder (classes, variables, méthodes, ...) avec les mêmes termes que vous utilisez pour expliquer les concepts de votre app. Concrêtement, ça se fait avec des méthodes comme `bill.pay(amount)` ou `user.buyAccessPass(...)`.

C’est quoi la différence avec une app classique? Ça dépend de ta définition d’une app classique. De mon bord, une app en DDD, c’est pas mal ça, une app classique. Plutôt que de faire des god-classes et des services qui contiennent beaucoup trop de logique, on va déléguer tout ça au domaine, dans des classes appropriées. Si la logique de création a pas mal d'étapes, on va faire des [factories](https://refactoring.guru/design-patterns/factory-method). Si un calcul est complexe, on va faire une classe (une [strategy](https://refactoring.guru/design-patterns/strategy), peut-être) qui détermine un résultat selon des paramètres. On va revenir aux patrons de conception à utiliser, mais pour tout de suite, retenez juste que le domaine c’est genre votre flambeau. C’est votre p’tit bébé, c’est là que vous concentrez vos efforts.

Plus un domaine est intelligent, plus le code est simple à lire, plus il fait du cristie de sens.

Le domaine c’est le centre de [l’architecture hexagonale](https://en.wikipedia.org/wiki/Hexagonal_architecture_(software)), de l’architecture en ports & adapters. Je vais dédier un article complet à ce genre d’architecture, vu que c’est celle qu’on va utiliser. Par contre, ça va être dans un bout, car je veux y venir juste avant d’entrer dans le code.

Dernière affaire pour le domaine : on peut avoir un domaine riche ou de type CRUD ou quelque chose entre les deux. CRUD signifie Create-Read-Update-Delete. Si vous avez déjà fait de la BD, de bases de données, un peu, vous comprenez que ça veut dire que le domaine est très proche de comment les données sont sauvegardées. Dans une app comme ça, le domaine est pas mal la définition des tables de la BD et que y’a pas grande logique là-dedans. L'app devient un simple transport d'information entre un frontend et une base de données. Plus un domaine est riche, plus il contient de règles et d’obtention complexe de données. Notre domaine va être aussi riche que je peux le rendre.

J’veux un beau domaine, ok?

## Têtes d'agrégats

Un agrégat c’est une grappe de classes, d’objets, de concepts de l’app. Donc, la tête d’agrégat c’est le sommet d’une grappe. C’est l’objet qui contient les autres. Dans notre app, vu qu’on va avoir un stockage de données simple sans base de données (on pourrait avoir une BD classique, mais il faudrait structurer les entitées à sauvegardées et les convertir vers le domaine), on va avoir des grosses grappes. Tant qu’à loader en mémoire un compte d’utilisateur, on va loader ses passes et ses factures aussi.

Logiquement, les têtes d’agrégats seront la base des routes qu’on peut appeler sur notre app. Donc, c’est les endpoints. En tout cas, si on doit décider nos routes qui agissent sur un concept dans une grappe, on doit aller en ordre vers le concept voulu, à partir de la tête.

Par exemple, pour créer un compte, on va appeler la route `/accounts`. Pour aller chercher les factures d’un compte, on va appeler `/accounts/:accountId/bills`. Le prochain article va aller plus en détails là-dedans.

Dans l’app, je veux une seule tête d’agrégat : les comptes.

## Conceptualisation de domaine

Ok!

Maintenant, on va décortiquer les classes principales du domaine et la grappe complète pour tout ça. Je vais me servir de [diagrams.net](https://www.diagrams.net/), anciennement draw.io, qui est une app que j’aime beaucoup.

Voici le diagramme complet que j'ai fait. Le reste de cet article sera consacré à expliquer chaque concept et pourquoi il est structuré ainsi.

![Conceptualisation des classes principales du domaine](/public/img/posts/diagram-conceptualization-classes.png)
*(conceptualisation des classes principales du domaine, disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Main-classes-diagram))*

Je vais y aller package par package. Pour éviter la confusion, lorsque je parle d'un concept (d'une classe) qui va dans un autre package, ça sera en gras.

### Package : `Accounts`

Commençons avec les comptes et les utilisateurs. J’avais dit que la seule tête d’agrégat va être les comptes. Si je l’ai dis, ça doit être vrai.

`Account` : Y’a quoi dans le compte? On a un ID et l’utilisateur. Éventuellement, on pourrait avoir une liste de users, mais c’est pas encore le cas.

`AccountId` : Good! L’ID d’account c’est quoi ça? Ça va être un UUID. Par contre, on va faire un wise move et on va déplacer ça dans une autre classe. On va en faire un value object. Comme ça, si le type d’ID change, disons qu’on veut un nombre plutôt qu’un UUID, ça réduit le ripple effect et on a pas grand chose à changer à l’app et les tests.

`User` : Ok! L’utilisateur. En fait, c’est les informations d’un compte. Comme j’ai dis, on en a juste un par compte présentement, mais c’est pas trop grave. On va avoir les informations qu’on envoie à la création de compte, donc l’email, le nom complet, le poids et la taille. On va aussi avoir la liste des passes d’accès et l’instant de création, qui sera utilisé à des fins de reporting.

Est-ce qu’on a besoin d’un identifiant pour l’utilisateur? Pour tout de suite, pas besoin de `UserId` ou de quoi dans le genre. On sait déjà que l’email est unique, alors on peut se servir de ça éventuellement. Mais, si on a un jour plusieurs utilisateurs par compte, le mieux serait d’avoir un `UserId`. Pas là.

Good! Je vais mettre ces concepts-là en vert. Ils seront dans le même package, alors c’est parfait.

`Instant` : L’instant c’est quoi? C’est pour représenter un temps précis. C’est en bleu, **c’est un autre package**.

### Package : `AccessPasses`

Alright, on va faire le package des passes d’accès.

`AccessPass` : La passe d’accès contient son code, son instant de création, son type de période, les périodes qu’elle couvre, la liste d’utilisation de l'ascenseur et sa facture. Je vais mettre une liste de périodes vu qu’on peut avoir plusieurs dates. Pour les passes d’une semaine ou d’un mois, on aura une seule période dans la liste.

`AccessPassCode` : Ok, et pour le code? Comme l’ID de compte, on va en faire un value object. Ça va être un string qu’on va générer à notre façon. On verra comment générer ça rendu au code. Tout ce qu’on a à savoir pour tout de suite, c’est que c’est une classe à part de la passe d’accès.

`PeriodType` : Le type de période? C’est une énumération, ben simple.

Aight, on met ça en violet.

`Period` : La période, **ça va dans le package avec les instants**. C’est un début et une fin. Pas besoin d’aller plus loin.

`Date`, `Week` et `Month` : Wait, comment on fait pour display les informations sur les dates, les semaines et les mois? Sans entrer dans les détails, on va avoir des classes complexes qui représentent ces périodes-là. Je vais les placer **dans le package des instants**.

### Package : `ElevatorUsages`

`ElevatorUsage` et `ElevatorDirection` : Pour tout de suite, l’utilisation de l’ascenseur doit seulement être enregistrer pour les rapports. Je veux qu’on ait un domaine intelligent, qui n’a pas besoin de classe d’événement pour les rapports. Donc, on va faire une classe pour l’utilisation de l’ascenseur. On a juste besoin de l’instant et de la direction. La direction est une énumération.

Un beau orange pour ça. Je pourrais mettre ça dans le package des passes d’accès, mais j’trouve que ça manque de consistance avec les autres concepts des passes.

### Package : `Bills`

Alright, les factures et l’argent.

`Bill` : Les factures c’est une classe qui contient le numéro de facture, l’instant de création, la raison, la description, le montant et une liste de paiements.

`BillNumber` : Le numéro de facture, c’est comme l’ID de compte et le code de passe d’accès, on veut un value objet. Donc, c’est une classe à part.

`BillReason` : Ensuite, on a quoi? La raison, c’est une énumération. Easy enough.

`Money` : L’argent, on va en faire une classe aussi. Pour tout de suite, c’est un value object. Par contre, dans le futur, ça pourrait devenir assez intelligent, avec des concepts comme la conversion d’une currency à l’autre. En tout cas, mettons ça là. Anyway, les prix de passes d’accès pour un type de période devront s’en servir aussi. Sans aller trop loin, ça va être une classe en mémoire qui a un map. On va retourner un prix, un `Money`, en fonction d’un type de période.

`BillPayment` : Les paiements. Pourquoi je veux une classe pour ça? Encore une fois, c’est parce que je connais mes besoins de reporting. On veut pouvoir stocker efficacement chaque paiement qui a été fait. Donc, on va en faire une liste d’une classe à part, qui contient seulement l’instant et le montant payé.

En rouge, parce que le capitalisme c’est mal.

Hey, pourquoi c’est pas les comptes qui possèdent les factures? Honnêtement, ça ferait du sens, mais je sais que dans mon reporting j’ai besoin de savoir si une passe d’accès a des paiements dans sa facture. Alors, je place ça là. Si on a d’autres façons de créer des bills, il va sûrement falloir changer la structure un peu, mais rien de trop grave.

### Package : `Reports`

Okkkkkkkkkkkkkkkkk, les osties de rapports.

J’ai planifié le domaine pour qu’il soit assez wise pour pas avoir besoin d’une classe lightweight où on enregistre des événements dans l’app. Nice! Par contre, on a quand même besoin de quelques concepts définis : les dimensions, métriques, périodes, scopes, ...

Je vais omettre ça de la conceptualisation. On va voir ça au complet dans un ou plusieurs articles sur le sujet. Rendu là, on va devoir dessiner encore.

`Quarter` et `Year` : Pour tout de suite, sachez juste qu’avec ce qu’on a là, on va avoir des classes qui définissent des semaines, mois, quarts d’années et années. D’ailleurs, va falloir se servir de ça pour l’achat de passes, pour trouver les périodes couvertes par les passes. Alright, je vais juste ajouter les périodes des rapports au diagramme. **Ça va dans le même package que les instants et les périodes.**

Remarquez que la flèche ici est blanche plutôt que noire. Ça sera pas de l’héritage aussi simple que ça, y va y avoir pas mal de concepts à plugger, mais pour un diagramme rapide, c’est en masse.

## Retour sur le diagramme complet

Bam, on a le diagramme final de notre domaine simplifié!

![Conceptualisation des classes principales du domaine](/public/img/posts/diagram-conceptualization-classes.png)
*(conceptualisation des classes principales du domaine, disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Main-classes-diagram))*

Juste un dernier truc, voici les dépendances entre les packages de l’app. Comme vous pouvez voir, on a pas de dépendance circulaire et ça fait quand même pas mal de sens :

![Conceptualisation des packages princpaux du domaine](/public/img/posts/diagram-conceptualization-packages.png)
*(conceptualisation des packages principaux du domaine, disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Main-classes-diagram))*

YES ON EST VENU À BOUT DU DOMAINE. FAUT JUSTE LE CODER ASTHEURE.

J’espère que vous avez aimé ça. J’suis quand même fier de la job qu’on a fait, notre domaine va être ben beau pis ben logique. J’suis content.

Le prochain article va être sur les endpoints et les routes dans notre API REST. Aussi, j’vais montrer vite c’est quoi ça, REST.

Parfa, à la prochaine, salut là!

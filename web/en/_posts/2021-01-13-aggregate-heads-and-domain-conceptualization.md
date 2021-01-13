---
layout: post
title:  "Aggregate heads and domain conceptualization"
date:   2021-01-13
categories: [project]
lang: en
lang-ref: aggregate-heads-and-domain-conceptualization
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/33cKvBi4MAE" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Sup!

Hey, the time has come to do some drawings. In the last posts, we established a list of functionalities that we transformed into [stories]({% post_url 2020-12-31-functionalities-to-stories %}) and then into [use-cases]({% post_url 2021-01-08-stories-to-use-cases %}). Now, we have a good idea of the different concepts used within our app. Let's make some diagrams.

I don't wanna get into formal diagrams, like [UMLs](https://en.wikipedia.org/wiki/Unified_Modeling_Language) or [C4 documentation](https://c4model.com/). These two can be pretty useful, especially C4 documentation, which helps deciding an app's components at the beginning of a project. Instead, I want to produce a diagram that represents the main classes of my domain. My goal is simply to illustrate the links between some important concepts that we'll have to implement.

## And what is that, a domain?

A [domain](https://en.wikipedia.org/wiki/Application_domain) is the heart of your application. This is where you put your logic, rules and links between concepts. The goal is to completely isolate the core of your app from the technologies you use. Moreover, you want to separate your domain in package, in modules, that depends from one another in the simplest way possible. Ideally, these dependencies will never be circular.

For instance, it makes sense that the access passes know about money, or at least about bills. The opposite does not make sense. A bill does not have to know what an access pass is. Why would it?

[Domain-driven design (DDD)](https://en.wikipedia.org/wiki/Domain-driven_design) is describing your application domain in the same way you describe your stories. It's about coding (classes, variables, methods, ...) with the same words you'll use to explain the concepts of your app. We do that with methods like `bill.pay(amount)` or `user.buyAccessPass(...)`.

What's the difference with a regular app, you ask? That depends on your definition of a regular app. To me, a DDD app pretty much is a regular app. Instead of making god-classes and services that contains way too much logic, we'll delegate all that to the domain, in appropriate classes. If the creation logic has many steps, we'll make [factories](https://refactoring.guru/design-patterns/factory-method). If a calculation is too complex, we'll make a class (maybe a [strategy](https://refactoring.guru/design-patterns/strategy)) that will compute a result based on parameters. We'll come back to design patterns, but, for right now, let's just keep in mind that the domain is your pride and joy. It's your baby, it's where you must concentrate all your efforts.

The more a domain is intelligent, the more the code is simple to read and makes some goddamn sense.

The application domain is the core of the [hexagonal architecture](https://en.wikipedia.org/wiki/Hexagonal_architecture_(software), of the ports & adapters architecture. I'll dedicate another blog post to this type of architecture, since that's the one we'll be using. That's gonna be in while, though. We're still far from our first line of code.

One last thing about the domain : we can have a rich domain, a CRUD-type domain or anything in between. CRUD means Create-Read-Update-Delete. If you ever played with DB, databases, you'll know that this means a domain that is really close to how the data is stored. In such an app, the domain is pretty much the definition of the database tables and do not hold much logic. An app like this is more of an information transfer from a frontend to a database than an app, really. The more a domain is rich, the more it contains rules and complex obtaining of data. Our domain will be as rich as I can make it.

I just want a beautiful domain, ok?

## Aggregate heads

An aggregate is a bunch of classes (objects, concepts) of the app. So, an aggreagate head is to top of the bunch. It's the object that contains all the others. In our app, since we'll have a simple storage of data with no database (we could have a classic DB, but we would have to structure some entities to save and convert them into the domain), we'll have some big bunches. Since we have to load a user's account in memory, we'll also load their passes and bills.

Logically, aggregate heads will be the base of the routes you can call on our app. So, they are the endpoints. Well, if we have to decide what the routes that acts on a concept in a aggregate are, we might as well follow the route to this concept, from the aggregate head.

For instance, to create an account, we'll call `/accounts`. To get the bills of an account, we'll call `/accounts/:accountId/bills`. The next post will go further into details about that.

In this app, I see a single aggregate head : the accounts.

## Domain conceptualization

___

Ok!

Maintenant, on va décortiquer les classes principales du domaine et la grappe complète pour tout ça. Je vais me servir de diagrams.net, anciennement draw.io, qui est une app que j’aime beaucoup.

Voici le diagramme complet que j'ai fait. Le reste de cet article sera consacré à expliquer chaque concept et pourquoi il est structuré ainsi.

![Conceptualisation des classes principales du domaine](/public/img/posts/diagram-conceptualization-classes.png)
*(conceptualisation des classes principales du domaine, disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Main-classes-diagram))*

Je vais y aller package par package. Pour éviter la confusion, lorsque je parle d'un concept (d'une classe) qui va dans un autre package, ça sera en gras.

### Package : `Accounts`

Commençons avec les comptes et les utilisateurs. J’avais dit que la seule tête d’agrégat va être les comptes. Si je l’ai dis, ça doit être vrai.

`Account` : Y’a quoi dans le compte? On a un ID et l’utilisateur. Éventuellement, on pourrait avoir une liste de users, mais c’est pas encore le cas.

`AccountId` : Good! L’ID d’account c’est quoi ça? Ça va être un UUID. Par contre, on va faire un wise move et on va déplacer ça dans une autre classe. On va en faire un value object. Comme ça, si le type d’ID change, disons qu’on veut un nombre plutôt qu’un UUID, ça réduit le ripple effect et on a pas grand chose à changer à l’app et les tests.

`User` : Ok! L’utilisateur. En fait, c’est les informations d’un compte. Comme j’ai dis, on en a juste un par compte présentement, mais c’est pas trop grave. On va avoir les informations qu’on envoie à la création de compte, donc l’email, le nom complet, le poids et la taille. On va aussi avoir la liste des passes d’accès et l’instant de création, qui sera utilisé à des fins de reporting.

Est-ce qu’on a besoin d’un identifiant pour l’utilisateur? Pour tout de suite, pas besoin de UserId ou de quoi dans le genre. On sait déjà que l’email est unique, alors on peut se servir de ça éventuellement. Mais, si on a un jour plusieurs utilisateurs par compte, le mieux serait d’avoir un `UserId`. Pas là.

Good! Je vais mettre ces concepts-là en vert. Ils seront dans le même package, alors c’est parfait.

`Instant` : L’instant c’est quoi? C’est pour représenter un temps précis. Je vais le mettre loin, car on va s’en servir pas mal. C’est en bleu, **c’est un autre package**.

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

`Money` : L’argent, on va en faire une classe aussi. Pour tout de suite, c’est un value object. Par contre, dans le futur, ça pourrait devenir assez intelligent, avec des concepts comme la conversion d’une currency à l’autre. En tout cas, mettons ça là. Anyway, les passes d’accès pour un type de période devront s’en servir aussi. Sans aller trop loin, ça va être une classe en mémoire qui a un map. On va retourner un prix, un Money, en fonction d’un type de période.

`BillPayment` : Les paiements. Pourquoi je veux une classe pour ça? Encore une fois, c’est parce que je connais mes besoins de reporting. On veut pouvoir stocker efficacement chaque paiement qui a été fait. Donc, on va en faire une liste d’une classe à part, qui contient seulement l’instant et le montant payé.

En rouge, parce que le capitalisme, c’est mal.

Hey, pourquoi c’est pas les comptes qui possèdent les factures? Honnêtement, ça ferait du sens, mais je sais que dans mon reporting j’ai besoin de savoir si une passe d’accès a des paiements dans sa facture. Alors, je place ça là. Si on a d’autres façons de créer des bills, il va sûrement falloir changer la structure un peu, mais rien de trop grave.

### Package : `Reports`

Okkkkkkkkkkkkkkkkk, les osties de rapports.

J’ai planifié le domaine pour qu’il soit assez wise pour pas avoir besoin d’une classe lightweight où on enregistre des événements dans l’app. Nice! Par contre, on a quand même besoin de quelques concepts définis : les dimensions, métriques, périodes, scopes, …

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

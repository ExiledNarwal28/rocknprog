---
layout: post
title:  "Endpoints et routes dans un API REST"
date:   2021-01-17
categories: [project, rest]
lang: fr
lang-ref: endpoints-and-routes-in-a-rest-api
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/w_jQdXXseWs" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Salut!

Aujourd’hui, on décide les routes et les endpoints de notre app, donc de la couche d’API REST.

Hey, on commence à avoir pas mal de job de fait. On a les fonctionnalités, les récits, les use-cases et un diagramme des classes principales du domaine. Bien joué, gang. Mais! Il nous reste encore beaucoup de matière à couvrir avant de coder.

Avant de commencer l'article, j’veux faire un p’tit shoutout à une entreprise insane. J’ai changé l’hébergement de mon site Web d’Heroku à [Shelter-Bay Cloud](https://shelterbaycloud.ca), un hébergeur écologique de ma région, la Côte-Nord. C’est le genre de projet malade que je supporte à fond, alors quand mon boy, Émile, m’a reach out pour me demander si je voulais être hébergé chez eux, j’ai tout de suite été down.

Sérieux, si vous voulez héberger une application ou un site, que ce soit pour du développement ou pour de la production, pour vous ou pour de la clientèle, j’vous recommande vraiment d’y faire un tour. C’est fucking important d’encourager les entreprises locales avec de belles valeurs, pis vous aurez jamais de la proximité et du contact humain du genre avec des méga-entreprises.

Hésitez pas à les contacter, peu importe votre type d’application, y’a moyen de faire affaire et vous aurez tout le support donc vous aurez besoin. Y’a des forfaits pour les petits développeurs, so no worries si c’est juste pour essayer!

Vraiment, merci à la gang de Shelter-Bay Cloud, vous faites une job de malade.

Bon. Hey, avant d’entrer dans le sujet d’aujourd’hui, je veux juste revenir vite sur les diagrammes de l'[article précédent]({% post_url 2021-01-13-aggregate-heads-and-domain-conceptualization %}). J’ai remarqué un petit truc qui manque dans les passes d’accès. Pour les dates, les semaines et les mois, on a les périodes pour utiliser l’ascenseur avec la date donnée. Par contre, pour les one-time uses, on fait quoi? J'ajouterai rien au diagramme, vu que c’est un brouillon, anyway. Éventuellement, on va voir la création d’issue, alors je le mentionnerai quand on fera les issues du use-case pour ça. De toute façon, les issues, bien entendu, viennent des stories et use-cases, et non du diagramme du dernier article.

## Alright, c'est quoi un API REST?

Okay, mais, aujourd’hui, c’est API REST, endpoints et routes. C’est quoi ça un API REST?

Alright. API c’est [Application Programming Interface](https://en.wikipedia.org/wiki/API). C’est une application, ou plus souvent une partie d’application, qui reçoit des requêtes et envoie des réponses. Ce qui s’en sert, ça peut être n’importe quoi : un site web, une app mobile, un interface de ligne de commandes, Postman, name it. Dans notre application à nous, l’API c’est un port de la couche externe de notre architecture hexagonale. C’est la partie de notre application qui s’occupe de la communication HTTP standard.

Fun fact : ma blonde pensait que je prononçait mal “Appli” quand je disais “API”. NON MADAME J’CONNAIS LA PATENTE BEN PLUS QUE ÇA.

Ensuite, REST c’est [Representational State Transfer](https://en.wikipedia.org/wiki/Representational_state_transfer). C’est une architecture logicielle basée sur un concept de ressources. On dit souvent d’un API REST qu’il est RESTful. Ça veut juste dire qu’il suit la mentalité REST dans sa représentation de collections, d’items et d’actions. Je vais vous shooter des exemples.

Voici un [super bon guide qui explique les différents concepts](https://www.smashingmagazine.com/2018/01/understanding-using-rest-api/). Y’a de la doc en masse en ligne sur le sujet, mais celle-là est simple et solide. J’vais m’en servir pour expliquer ce qui suit.

Y’a quatre principes fondamentaux en REST : les ressources, les méthodes, les headers et le data (body).

Je vais expliquer tout ça avec des exemples bidons. On va dire qu’on a un API REST qui représente des livres, qui contiennent chacuns des pages. On peut aller chercher les livres et les pages dans leur ensemble ou individuellement.

### Ressources

Les ressources, on les représente le plus clairement possible, en collections et en items. Par exemple, pour aller chercher la collection des livres, on peut utiliser `/books`. Pour aller chercher un livre individuel, donc un item de la collection des livres, on peut utiliser `/books/:bookId`. Si on veut la collection des pages pour un livre, on a `/books/:bookId/pages`.

Notez qu’ici, `/books` est un endpoint. C’est aussi une tête d’agrégat dans cet exemple. En fait, le path jusqu’à pages est aussi un endpoint, mais j’aime visualiser les endpoints comme étant les points d’entrées dans l’API. Désolé si cela porte à confusion. Rendu au code, ça aide à convertir chaque endpoint en ressource (la classe, pas la ressource REST).

Derniers détails pour les ressources : en REST, on appelle le path vers une ressource un URI, pas un URL. URI c’est [Uniform Resource Identifier](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) alors que URL c’est [Uniform Resource Locator](https://en.wikipedia.org/wiki/URL). La différence, c’est qu’ici on veut accèder à une ressource à partir d’un root-endpoint (le simple slash, ou genre /api, /apiv3, …) en URL, écrit directement le protocole, genre “http://…” ou “ftp://…”, et le domaine. Avec un URI, on peut permettre plusieurs méthodes qui sont des actions sur une resources. D’ailleurs...

### Méthodes

Ok comme vous savez sûrement y’a [pas mal de méthodes HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods). Par contre, en REST, on utilise principalement quatre méthodes, qui reviennent slightly au CRUD (Create-Read-Update-Delete) :

 * `POST` : Création d’item dans une collection ou action portée à l’app. Souvent, si vous ne savez pas trop où placer ou quoi faire avec une action sur une ressource, c’est un POST sur la ressource en question avec un nom d’action ou quelque chose de similaire. 
 * `GET` : Obtention de collection, d’item ou d’information dans le genre. On peut utiliser des query params pour filtrer ou modifier la requête.
 * `PUT` : Modification d’une ressource. Y’a des gens qui s’en servent comme un `POST`, mais fuck em, ça pue.
 * `DELETE` : Suppression d’une ressource.

Vous pouvez envoyer un body (comme du data en JSON) avec n’importe laquelle de ces quatres méthodes. Par contre, ça serait de la merde. Normalement, on fait seulement ça avec `POST` et `PUT`. `GET` et `DELETE` n’ont logiquement pas besoin de body et ça serait un blasphème d’en envoyer un. Si vous pensez que c’est nécessaire à votre API, revoyer vos routes un peu, y’a moyen de faire ça clean. Sinon, écrivez-moi!

Avec les exemples des livres et des pages, voici ce que ça pourrait donner :

 * `POST /books` : Création d’un livre
 * `GET /books` : Liste de tous les livres
 * `DELETE /books` : Suppression de tous les livres (wash, pas super, on évite ça)
 * `GET /books/:bookId` : Détails d’un livre
 * `PUT /books/:bookId` : Modification d’un livre
 * `DELETE /books/:bookId` : Suppression d’un livre
 * `GET /books/:bookId/pages` : Liste les pages d’un livre
 * ...
   
### Headers

Un [header (en-tête) HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers) c’est les informations qu’on envoie avec un call HTTP, que ça soit une requête ou une réponse. De notre bord, dans les deux cas, on doit spécifier que le type de data du body est du JSON. Sinon, les requêtes des rapports devront être authentifiées, c’qui se gère avec le header.

Évidemment, on va beaucoup se servir des headers pour les [status](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status) de nos réponses. Qu’ossé ça? C’est un code de trois chiffres classé comme ça :

 * `1xx` : Information
 * `2xx` : Yeah, ça marche
 * `3xx` : Redirection
 * `4xx` : Ton erreur (client)
 * `5xx` : Mon erreur (application)
   
Une action ou une obtention de ressource s’est bien passé? `200 OK`.

Une création s’est faite comme il faut? `201 CREATED`.

Données invalides envoyées? `400 BAD REQUEST`.

T’as pas l’authentification pour accéder à de quoi? `401 UNAUTHORIZED`.

T’as pas le droit de faire de quoi et c’est pas lié à de l’authentification? `403 FORBIDDEN`.

Numéro de référence de ressource qui n’existe pas ou URI inexistant? `404 NOT FOUND`.

L’application a chié? `500 INTERNAL SERVER ERROR`. Ça arrivera jamais ça, on est trop pro.

Autre truc qu’on va se servir, le header location. Ça, on va s’en servir quand on crée une ressource pour montrer son numéro de référence (genre, le ID ou le code généré) en envoyer le URI complet vers la nouvelle ressource.

Mettons que tu crées un nouveau livre avec `POST /books`, on va répondre en location `/books/:bookId` avec le nouvel ID.

### Data

Finalement, y’a le data. Comme j’ai dis quand on était aux méthodes, quand on fait un `POST` ou un `PUT`, on peut envoyer un body à notre requête. Dans notre cas, c’est le JSON qu’on envoie.

## Décision des endpoints et des routes

Good, maintenant que tout ça est défini, on va appliquer cette belle matière à notre projet. On va se servir des [use-cases](https://github.com/ExiledNarwal28/space-elevator/wiki/Use-cases) et du [diagramme des classes](https://github.com/ExiledNarwal28/space-elevator/wiki/Main-classes-diagram) pour trouver les URI et les actions à poser dans l’app.

![Conceptualisation des classes principales du domaine](/public/img/posts/diagram-conceptualization-classes.png)
*(conceptualisation des classes principales du domaine, disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Main-classes-diagram))*

C’est quoi les actions et les obtentions de ressources qu’on a dans l’app?

 * Créer un compte (et utilisateur, en même temps)
 * Acheter une passe
 * Lister les passes d’un compte (d'un utilisateur, en fait)
 * Lister des factures d’un compte
 * Payer une facture
 * Utiliser l’ascenseur
 * Demander un rapport

Ok, faisons ça étape par étape.

### Route : Créer un compte

Selon notre divin diagramme de classes, `Account` c’est notre tête d’agrégat pour pas mal tout. Donc, ça sera notre point d’entrée pour ce que possède un compte, soit les passes d’accès et les factures.

Comment on crée un utilisateur? `POST /accounts`. On reçoit du JSON et on répond la location du nouvel account avec son ID. `201 CREATED` si c’est good, `400 BAD REQUEST` si les données sont invalides.

```markdown
- /accounts
  - POST
    - Based on the user creation use-case
    - Creates an account and a user for the application
    - Receives user information as JSON
    - Responds 201 CREATED when successful
    - Responds 400 BAD REQUEST when received data is invalid
    - Responds /accounts/:accountId as a header location when successful
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : Acheter une passe

Ok, et comment on achète une passe? Les passes seront sous `/accounts/:accountId/accessPasses`. Comme on a un seul utilisateur par compte, même si c’est l’utilisateur et non le compte qui possède les passes, ça fait du sens dans un API REST.

C’est donc un `POST /accounts/:accountId/accessPasses`. On reçoit le JSON pour la nouvelle passe et on répond son code en header location. Ça crée la passe et la facture, je vais préciser ça. J’parlerai pas du email, vu que ça concerne pas la couche d’API. Même affaire pour la création de compte. Les status, c’est quoi? `201 CREATED` si c’est good, `400 BAD REQUEST` si les données sont invalides et `404 NOT FOUND` si l’account ID existe pas.

```markdown
- /accounts
  - /:accountId
    - /accessPasses
      - POST
        - Based on the access pass creation use-cases
        - Creates an access pass and adds it the user
        - Creates a bill for buying an access pass and adds it to the access pass
        - Receives access pass information as JSON
        - Responds 201 CREATED when successful
        - Responds 400 BAD REQUEST when received data is invalid
        - Responds 404 NOT FOUND when account ID is non existent
        - Responds /accounts/:accountId/accessPasses/:accessPassCode as a header location when successful
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : Lister les passes d’un compte

Good, lister les passes? C’est une collection sous les comptes et on a juste besoin d’un `GET`. `200 OK` si ça marche, `404 NOT FOUND` si l’account ID existe pas. On répond les passes en JSON.

```markdown
- /accounts
  - /:accountId
    - /accessPasses
       - GET
         - Based on the access passes listing use-case
         - Responds 200 OK when successful
         - Responds 404 NOT FOUND when account ID is non existent
         - Responds the list of access passes owned by the user as JSON
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : Lister des factures d’un compte

Très similairement, pour lister les factures d’un compte, on va faire un `GET`. `200 OK` si c’est good, `404 NOT FOUND` si l’account ID est not found. On répond les bills en JSON.

```markdown
- /accounts
  - /:accountId
    - /bills
      - GET
        - Based on the bills listing use-case
        - Responds 200 OK when successful
        - Responds 404 NOT FOUND when account ID is non existent
        - Responds the list of bills owned by the user as JSON
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : Payer une facture

Good, et pour payer une facture? On va bien avoir `/accounts/:accountId/bills/:billNumber`, mais comment on paie? Vous vous souvenez, quand j’ai dis que `POST` permettait aussi de porter des actions sur une ressource? Si on veut être très RESTful, on va avoir l’action `pay` sur un item dans la collection de factures.

On reçoit le JSON du montant à payer. `200 OK` si ça marche, `400 BAD REQUEST` si le montant à payer est invalide, `404 NOT FOUND` si l’account ID ou le bill number n’existe pas. Le bill number ne doit pas seulement exister, il doit exister dans le compte. C’est évident avec comment les ressources sont emboîtées les unes dans les autres dans l’URI! Finalement, on répond la facture à jour en JSON.

```markdown
- /accounts
  - /:accountId
    - /bills
      - /:billNumber
        - /pay
          - POST
            - Based on the bill payment use-case
            - Receives amount to pay as JSON
            - Responds 200 OK when successful
            - Responds 400 BAD REQUEST if given amount to pay is invalid
            - Responds 404 NOT FOUND when account ID or bill number is non existent
            - Responds updated bill as JSON
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : Utiliser l’ascenseur

Alright, on est rendu à l’utilisation de l’ascenseur. Logiquement, comme on se sert des passes, on va avoir une action à poser sur les passes avec un `POST`, non?

Estie que ça fait du sens pis que j’serais down, mais y’a un bémol. Checkez ça dans [les récits](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories#adventure-3--elevator-access) : “They enter only the access pass code.”.

Comment je vois ça, c’est que le endpoint `/accounts` et tout ce qui est en dessous, c’est vraiment pour la gestion de compte, pour l’achat et le paiement. Lorsqu’on utilise l’ascenseur, on veut pas entrer notre account ID. On veut seulement entrer notre code de passe d’accès, comme si on scannait notre passe avant d’entrer dans l’ascenseur.

Pour moi, c’est obligatoire d’avoir deux endpoints, deux points d’entrée différents. Anyway, si jamais on veut l’imbriquer sous les passes dans les comptes, sachez que le changement sera pas bien compliqué. Alors, on va vraiment faire un nouveau endpoint pour tout de suite! Par contre, personnellement, j’avoue pas être friand de placer une référence / identifiant dans le corps de la requête. Le plus possible, j’essaie de les placer dans le path.

Good, alors on va avoir `/elevatorUsage/:accessPassCode/goUp` pour aller en haut et `/elevatorUsage/:accessPassCode/goDown` pour aller en bas. On pourrait aussi déplacer le code dans le JSON, mais je pense que cette solution est quand même clean. Faites-moi savoir si vous pensez que non, encore une fois, c’est un changement très simple à faire.

Donc, on envoie du JSON pour la date. On répond `200 OK` si ça marche, `400 BAD REQUEST` si la date est invalide, `403 FORBIDDEN` si la passe ne couvre pas la date donnée ou si l’utilisateur est déjà en haut lorsqu’il monte, ou qu’il est déjà en bas lorsqu’il descend et `404 NOT FOUND` si la passe n’existe pas.

P’tite question : pourquoi `200 OK` et pas `202 ACCEPTED`? Selon le naming, ça ferait plus de sens, non? Sorry, les noms des status codes sont pas toujours on-point. `202 ACCEPTED` implique que la requête est acceptée mais encore en train d’être processée. Donc, dans notre cas, `200 OK` fait plus de sens.

```markdown
- /elevatorAccess
  - /:accessPassCode
    - /goUp
      - POST
        - Based on the elevator access use-case to go up
        - Receives date as JSON
        - Responds 200 OK when successful
        - Responds 400 BAD REQUEST if given date is invalid
        - Responds 403 FORBIDDEN when access pass do not cover given date or user is already up in the station
        - Responds 404 NOT FOUND when access pass code is non existent
    - /goDown
      - POST
        - Based on the elevator access use-case to go down
        - Receives date as JSON
        - Responds 200 OK when successful
        - Responds 400 BAD REQUEST if given date is invalid
        - Responds 403 FORBIDDEN when access pass do not cover given date or user is already up down on Earth
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : Demander un rapport

Ah, les rapports. Pour tous les rapports qu’on a à produire, c’est un seul URI avec des query parameters. C’est un simple `GET /reports`.

Ce endpoint demande une authentification. Les query parameters, on a metrics, year et scope qui sont obligatoires. Sinon, y’a dimensions, month et aggregations qui sont optionnels. On répond `200 OK` si ça marche, `400 BAD REQUEST` si on a des query parameters invalides et `401 UNAUTHORIZED` si l’authentification est incorrecte. On répond la liste des périodes demandées pour le rapport.

```markdown
- /reports
  - GET
    - Based on the event reporting use-cases
    - Requires authentication
    - Receives metrics, year and scope as obligatory query parameters
    - Receives dimensions, month and aggregations as optional query parameters
    - Responds 200 OK when successful
    - Responds 400 BAD REQUEST when one or many received query parameters are invalid or missing
    - Responds 401 UNAUTHORIZED when authentication is incorrect
    - Responds list of report periods as JSON
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

## Et finalement

Bam, done! On a donc la [planification des routes pour notre API REST](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes). Elle est donc comme suit : 

```markdown
- /accounts
  - POST
  - /:accountId
    - /accessPasses
      - POST
      - GET
    - /bills
      - GET
      - /:billNumber
        - /pay
          - POST
- /elevatorAccess
  - /:accessPassCode
    - /goUp
      - POST
    - /goDown
      - POST
- /reports
  - GET
```
*(disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

Vous savez quand je parle de documentation de calls d’API? Au final, ça, c’est un mélange entre le document qu’on vient de produire et les corps de requêtes décrit dans les use-cases. Mais... la documentation qu’on fait depuis le début du projet, c’est de la planification. On a rien codé encore. L’affaire avec la documentation d’API, c’est que c’est pas une demande pour ce qu’on veut que ça fasse, c’est littéralement ce que notre application fait. Ce qu’elle s’attend à recevoir et ce qu’elle répond. Inquiètez vous pas, on va la faire ensemble en temps et lieux.

Hey, ça fait plusieurs articles où on fait le projet pis on a juste un crisse de wiki. J’tanné. Au prochain article, on va commencer le repo sur GitHub. J’vais vous montrer quels fichiers sont importants à avoir à base du repository et quelles sont les sections les plus importantes sur le repo GitHub. Ces notions-là s'appliquent bien sûr aussi à GitLab, Bitbucket ou pas mal n’importe quel autre hébergeur de code source.

Par contre! Là, la gang, je commence ma dernière session à temps plein à l’uni. J’ai produit des articles à la vitesse de l’éclair depuis le début du blogue, mais là j’vais avoir moins de temps libre. Faut ben que j’finisse mon bacc. J’estime être capable de faire une à deux articles par mois, mais j’vous tiendrez au courant. Hésitez jamais à m’écrire, en commentaire YouTube ou par courriel, si y’a quoi que ce soit, si vous avez des questions, ou si vous voulez des trucs pour faire survivre vos plantes.

Alright, gros love, à la prochaine, salut là!

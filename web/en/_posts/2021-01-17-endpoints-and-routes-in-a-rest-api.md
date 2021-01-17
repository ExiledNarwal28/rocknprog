---
layout: post
title:  "Endpoints and routes in a API REST"
date:   2021-01-17
categories: [project, rest]
lang: en
lang-ref: endpoints-and-routes-in-a-rest-api
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/w_jQdXXseWs" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Yo!

Today, we decide routes and endpoints in our app or, more precisely, our REST API layer.

Hey, we now have a lot of work done. We have our functionalities, stories, use-cases and a main classes diagram. Well done, people. But! We still have a lot of things to cover before coding.

Before going into this post, I wanna make a quick shoutout to an insane enterprise. I changed host for my website, from Heroku to [Shelter-Bay Cloud](https://shelterbaycloud.ca), an ecological web hosting company from my region, the Côte-Nord. That's the kind of sick project I open-heartily support, so when my boy, Émile, reached me out to ask if I wanted to be hosted at their place, I was a 100% down.

If you want to host an application or a website, for development or for production, for you or for a client, I really recommend you check it out. It's super important to support local companies with beautiful values and you won't have this kind of proximity and human contact with bigass enterprises.

Don't hesite to contact them, whatever kind of application you got, there's a way to work with them and you'll have all the support you need. There are pricings for small developpers, so no worries if you only want to try.

Really, thanks to the people at Shelter-Bay Cloud, you're doing an amazing job.

Okay. Hey, before getting into today's subject, I wanna come back to the diagrams of [my last post]({% post_url 2021-01-13-aggregate-heads-and-domain-conceptualization %}). One small thing was off concerning the access passes. For some dates, weeks or months, we got periods that we can use to validate access passes when using the elevator. Though, for one-time use passes, what do we do? I won't add anything to the existing diagram, as it's a draft, anyway. Eventually, we will go into issue creation, so I'll mention it when we'll write issues for that use-case. Anyway, issues, of course, come from stories and use-cases, not from the last post's diagram.

## Alright, and what is a REST API?

Okay, but, today, it's REST API, endpoints and routes. What's a REST API?

API stands for [Application Programming Interface](https://en.wikipedia.org/wiki/API). It's an application, or, more likely, a part of an application, that received requests and sends responses. Anything could use it : a website, a mobile app, a command-line interface, Postman, name it. In our application, the API is a port of the external layer of our hexagonal architecture. It's the part of our application that deals with standard HTTP communication.

Moreover, REST stands for [Representational State Transfer](https://en.wikipedia.org/wiki/Representational_state_transfer). It's a software architecture based on a concept of resources. We often say of a REST API that it's RESTful. That simply means it follows the REST ideology of representing collections, items and actions. I'll shoot you some examples.

Here's a [super good guide that goes into each different concepts](https://www.smashingmagazine.com/2018/01/understanding-using-rest-api/). There's a lot of documentation about this subject online, but this one is simple and solid. I'll use it for what follows.

In REST, there are four main principles : resources, methods, headers and data (body).

I'll explain all of this with some stupid example. We'll say we have a REST API that represents books, which all contain pages. We can get books and their pages in bunches or individually.

### Resources

Resources are represented as clearly as possible, in collections and items. For instance, to get the book collection, we may use `/books`. To get a single book, so an item within that collection, we can use `/books/:bookId`. If we want the collection of pages for a given book, we have `/books/:bookId/pages`.

Note that, here, `/books` is an endpoint. It's also the aggregate head in this example. In fact, the path to pages is also an endpoint, but I like seeing endpoints as the starting points in the API. Sorry if this generates some confusion. When we'll code all that, we'll convert each endpoint into a resource (the class, not the REST resource).

One last thing for resources : in REST, we call the path to a resource a URI, not a URL. URI is [Uniform Resource Identifier](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier), while URL is [Uniform Resource Locator](https://en.wikipedia.org/wiki/URL). The difference is that when we want to access a resource from a root-endpoint (a simple slash, or something like /api, /apiv3, ...) using URL, we write directly the protocol , like "http://..." or "ftp://...", and the domain. With a URI' we can use many methods, which are actions, on a resource. Speaking of methods...

### Methods

As you surely know, there are [many HTTP methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods). Though, in REST, we mostly use four methods, which are pretty alike CRUD (Create-Read-Update-Delete) : 

 * `POST` : Creating items within a collection or make an action. Often, when you don't know where to place or what to do with an action on a resource, it's a POST on the resource with an action name or something alike.
 * `GET` : Getting collections, items or information. We can use query params to filter of change our request.
 * `PUT` : Modifying a resource. Some people use it like a `POST`, but fuck em, that's bad.
 * `DELETE` : Deleting a resource.

We can send a body (like some JSON data) with any of the mentioned four methods. Though, that would be shit. Normally, we only do that with `POST` or `PUT`. `GET` and `DELETE` logically do not need a body and that would be an offense to send one. If you think that's necessary to your API, rework your routes, there's a way to do better. Otherwise, write me.

With the examples of books and pages, here's what we would have : 

 * `POST /books` : Creating a book
 * `GET /books` : Listing all books
 * `DELETE /books` : Deleting all books (not cool, we'll avoid that)
 * `GET /books/:bookId` : Getting a book's details
 * `PUT /books/:bookId` : Modifying a book
 * `DELETE /books/:bookId` : Deleting a book
 * `GET /books/:bookId/pages` : Listing all pages of a book
 * ...

### Headers

An [HTTP header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers) is the information we send with an HTTP call, be it a request or a response. In our application, in both cases, we'll specify the data type of the body is JSON. Other then that, requests to get reports must be authenticated, which is handled by the HTTP header.

Of course, we'll use headers a lot for our responses' [statuses](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status). What's that? It's a three-digit code classes like so : 

 * `1xx` : Information
 * `2xx` : Yeah, it works
 * `3xx` : Redirection
 * `4xx` : Your mistake (client)
 * `5xx` : My mistake (application)

An action or data obtaining went well? `200 OK`.

A creation was successful? `201 CREATED`.

Invalid data received? `400 BAD REQUEST`.

You don't have the authentication to get something? `401 UNAUTHORIZED`.

You cannot do something and it's not related to authentication? `403 FORBIDDEN`.

Resource reference that does not exist or unknown URI? `404 NOT FOUND`.

The application went wrong? `500 INTERNAL SERVER ERROR`. That won't happen, we're too good.

Another thing we'll use is the header location. We'll use that when creating a resource, to display it's reference (like a ID or a generated code) and send the URI to the new resource.

Let's say you create a new book with `POST /books`, we'll respond `/books/:bookId` as a location with the new ID.

### Data

Finally, there's the data. Like I said when we we're looking at methods, when we do a `POST` or a `PUT`, we can send a body with our request. In our case, that will always be JSON.

## Deciding endpoints and routes

___

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

P’tite question : pourquoi `200 OK` et pas `202 ACCEPTED`? Selon le naming, ça ferait plus de sens, non? Sorry, les noms des status codes sont pas toujours on-point. `202 ACCEPTED` implique que la requête est acceptée mais encore en train d’être processée. Donc, dans notre cas, 200 OK fait plus de sens.

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

Ce endpoints demande une authentification. Les query parameters, on a metrics, year et scope qui sont obligatoires. Sinon, y’a dimensions, month et aggregations qui sont optionnels.

On répond `200 OK` si ça marche, `400 BAD REQUEST` si on a des query parameters invalides et `401 UNAUTHORIZED` si l’authentification est incorrecte. On répond la liste des périodes demandées pour le rapport.

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

Par contre! Là, la gang, je commence ma dernière session à temps plein à l’uni. J’ai produit des vidéos à la vitesse de l’éclair depuis le début du channel, mais là j’vais avoir moins de temps libre. Faut ben que j’finisse mon bacc. J’estime être capable de faire une à deux vidéos par mois, mais j’vous tiendrez au courant. Hésitez jamais à m’écrire, en commentaire YouTube ou par courriel, si y’a quoi que ce soit, si vous avez des questions, ou si vous voulez des trucs pour faire survivre vos plantes.

Alright, gros love, à la prochaine, salut là!

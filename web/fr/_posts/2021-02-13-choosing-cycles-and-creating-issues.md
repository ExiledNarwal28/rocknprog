---
layout: post
title:  "Décision d'itérations et création d'issues"
date:   2021-02-13
categories: [project, git]
lang: fr
lang-ref: choosing-cycles-and-creating-issues
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/WGkTudoBUHY" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Yo! C'est l'heure de choisir nos itérations et de créer des issues sur GitHub.

## Les itérations

On va déterminer les itérations pour les [stories](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories) et [use cases](https://github.com/ExiledNarwal28/space-elevator/wiki/Use-cases) qu’on a fait.

Connaissez-vous le [planning poker](https://en.wikipedia.org/wiki/Planning_poker)? Les stories qu’on a fait ça fitte pas mal avec la méthodologie agile scrum. Le planning poker, ça serait la suite logique de la job qu’on a fait avec les stories, soit de déterminer l’effort à faire pour chaque story. On accorde à chaque récit ou tâche un nombre de la suite de Fibonacci et ça nous permet de répartir les tâches, découper les tâches trop grosses en plus petites tâches et trouver les itérations. Chaque itération devrait regrouper des tâches qui donnent à peu près la même somme d’effort.

On peut faire ça avec des stories ou avec des fonctionnalités précises dans chaque story, ou même avec des issues.

Nous, on fera pas ça. On a converti les récits en cas d’utilisation technique pis c’est ça qu’on va checker.

Estie que j’me casserai pas l’bicycle. On a cinq epics : la création d’utilisateur, la création de passe, l’accès à l’ascenseur, la création / paiement de facture et le reporting. Chaque epic sera une itération vers la version 1.0.0.

On va donc partir sur l’itération 1 : la version 0.1.0, qui permet de [créer un utilisateur](https://github.com/ExiledNarwal28/space-elevator/wiki/Use-cases-1-:-User-creation).

Hey oui, en passant, j’ai changé “adventure” pour “epic” dans mon wiki. C’était une erreur de traduction, j’étais habitué au terme “aventure” en français, mais j’devais pas le traduire littéralement.

## Premier milestone sur GitHub

Avant de créer les tâches, on va créer notre [milestone](https://docs.github.com/en/github/managing-your-work-on-github/about-milestones). Notre jalon, en bon français.

C’est la “Release 0.1.0”. Pas besoin de date de fin, parce que j’me stresserai pas avec mes articles ma gang de vous autres.

Suffit de dire que c’est l’implémentation de la création de compte et d’utilisateur et de dire de quel story et use case ça vient!

## Décision des issues

Good, fait que c’est quoi nos tâches? On veut créer un compte et un utilisateur. Le use case représente plusieurs étapes différentes à traiter pour répondre correctement à c’qui est demandé. D’un côté de programmation, chaque chose mentionnée du scénario représente souvent au moins une issue à créer, quelque chose à implémenter.

On a nos [routes](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes) qui représentent chaque endpoint de notre couche REST pour les use cases. Nous, c’est `POST /accounts`.

Qu’est-ce qu’on veut faire? Sans parler pas encore de factures ou de passes. On fait juste la création d’utilisateur ben simple. On veut :
- Que le compte soit enregistré dans l’application
- Envoyer des données en JSON à `POST /accounts`
- Que ça retourne `201 CREATED` si ça marche
- Que ça retourne `400 BAD REQUEST` si les données sont invalides soit :
  - Format de courriel invalide
  - Nom invalide
  - Poids non-positif
  - Hauteur non-positive
- Que ça retourne `409 CONFLICT` si l'email existe déjà
- Que ça retourne le header location avec le nouvel account id, genre “accounts/:accoundId”
- Ettttttt que ça envoie un courriel à l’utilisateur

## Note sur l’architecture hexagonale

Good, là j’vous averti, on s’en ligne un peu technique. J’vais faire un article qui couvre le sujet soon, mais, live j’vais utiliser des termes pour décrire des concepts dans l'[architecture hexagonale](https://blog.octo.com/en/hexagonal-architecture-three-principles-and-an-implementation-example/).

So, on va faire un p’tit plan de l’archi. En gros :

On a, au centre, notre domaine. Ça, c’est pure, c’est nos règles de domaine et comment tout fonctionne. C’est les concepts qu’on a trouvé [l’autre fois]({% post_url 2021-01-13-aggregate-heads-and-domain-conceptualization %}) : les comptes, les utilisateurs, les passes, les factures, pis toute ça. Les classes vont avoir ces noms là pas mal.

Tout le tour de l’app, c’est les ports vers des technos externes. Genre :

- La couche REST, qui répond à des calls HTTP en JSON
  - On va utiliser des classes `Resource`, qui représentent les point d’accès de la couche REST, les endpoints, les URIs vers nos objets et collections
- La couche d’infrastructure, qui est pas mal notre BD.
  - On pourrait avoir des `Repository`, avec des méthodes comme `get`, `save` et `update`, qui couvre les aspects techniques de la BD, quelle soit in memory, SQL, NoSQL, ... Si on avait une BD complexes des `DAO`, [Data Access Object](https://en.wikipedia.org/wiki/Data_access_object), qui représentent les tables de la BD, pourrait être pratiques, mais pas dans notre cas! On veut un accès simple à la mémoire dans la RAM.
- Les clients, qui utilisent d’autres APIs
- Le système sur lequel l’app roule
- SMTP, pour les courriels
- La console, pis ben d’autres affaires

C’est comment notre app communique avec d’autres softwares, en gros.

Pour coller tout ça ensemble, on a un [service layer](https://martinfowler.com/eaaCatalog/serviceLayer.html). Un service représente souvent un use case. Pour faire cute, on dit que ça “orchestre le domaine”. C’est magnifique. Comment ça s’appelle un test unitaire pour un service? Vu que ça sert juste à appeler les classes qui s’occupent de la logique, on veut juste voir si les données sont passées aux bons endroits dans le bon ordre juste pour que ça reste stable, c’t’un “test d’orchestration”. Ça veut tellement rien dire pis j’aime ça.

Si un service pue, il ressemble à une god class. Si ton domaine est assez intelligent, si il a assez de logique pour se régler lui-même, tes services vont être ben beau ben cute. La preuve, c’est ça qu’on va faire.

Ok!

![Diagramme simple d'architecture hexagonale](/public/img/posts/diagram-simple-hexagonal-artchitecture.png)
*(Diagramme simple d'architecture hexagonale, disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Hexagonal-architecture))*

Le flow normal de notre archi, ou en tout cas celui pour la création de compte / utilisateur, c’est :

- Le JSON est mappé en objet de requête par la `Resource`, dans la couche d’API. La `Resource` l’envoie au service pis répond `201 CREATED` avec le endpoint du nouveau compte, soit son nouvel ID.
- Le service, fait ben des affaires.
  - D’abord, il assemble la requête en objets de domain valides. Cet assemblage-là est gère par une classe à part qui throw des exceptions pour les différentes raisons que le data est invalide.
    - Oublions pas, la validation d’email existant, c’est pas live. On a besoin des données enregistrées dans l’app pour ça.
  - Le service reçoit l’objet `Account`, avec son `User`, valide.
  - Il l'envoie au `Repository`. Celui-là l’enregistre dans une liste en mémoire.
    - Le `Repository` crée aussi son ID. On pourrait techniquement faire ça à l’assemblage, mais c’est pratique commune de laisser la BD gérer les références autogénérées. Nous, on va juste plugger un générateur dans la couche d’infrastructure, à côté du repo.
    - Aussi, vu que le `Repository` a la liste en mémoire, c’est à lui de vérifier si l’email existe déjà.
  - Le service reçoit le nouvel account ID.
  - Il envoie un courriel au email avec l’account ID.
    - Ça, ça se passe avec une couche SMTP et une couche de filesystem. Pourquoi filesystem? Parce que, dans l’environnement local, on va aller chercher les infos du courriel SMTP pour envoyer le courriel avec un fichier.
  - Il retourne ça à la couche REST.

Aussi, au travers de ça, y’a des exceptions mappers. C’est parce que dans l’app, les exceptions, c’est des classes qu’on throw. Le HTTP, c’est la couche REST qui le gère, avec un exception mapper. Évidemment, dans le `Repository`, quand l’email existe déjà, c’est pas là qu’on gère le fait que c’est un `409 CONFLICT`, on est dans la couche d’infra, de BD. On lance une exception et la couche REST le pogne.

## Note sur le setup du projet

Ouin, ok pis on a besoin de d’autres tâches. Faut ben setuper le projet.

À partir de cet article, vous pouvez pas mal deviner le reste des articles que j’vais sortir. Chaque problème à résoudre ici est un concept de plus à couvrir sur le site. Si vous voulez que je couvre de quoi dites-moi le pis j’vais prioriser ça!

Donc, pour le setup du projet, on a besoin de :

- Créer un boilerplate, une base de projet, en Maven
- Plugger [Dependabot](https://dependabot.com/) pour les nouveaux packages
- Un CI, [Continuous Integration](https://www.cloudbees.com/continuous-delivery/continuous-integration)
- Un CD, [Continuous Deployment](https://searchitoperations.techtarget.com/definition/continuous-deployment)
- Uploader nos rapports de code coverage
- Des requêtes [Postman](https://www.postman.com/) pour tester ça
- Des [tests end-to-end](https://www.katalon.com/resources-center/blog/end-to-end-e2e-testing/) Postman
- Une documentation d’API

## Écriture des issues de la première itération

Ok les chums on a du pain sur la planche. J’vais utiliser les templates d’issues de feature request que j’ai fais au [dernier article, sur les bases d’un repo GitHub]({% post_url 2021-01-24-github-repository-basics %}).

### Add resource for `POST /accounts`

Première étape : on ajoute la ressource pour `POST /accounts`. Elle doit recevoir la requête, l’envoyer au service, faire `202 CREATED` et répondre le nouveau ID.

J’vais m’assigner sur chaque tâche, mettre le projet et le milestone. J’vais faire une étiquette `use-cases-1` pour indiquer quel groupe de use cases on règle. On pourrait aussi faire des étiquettes pour les couches de l’archi, mais bof.

Pour les p’tits wise d’la gang, vous remarquez que les tâches que j’ai mis là, ça représente le contrat de chaque classe, ce qu’elle se doivent de faire, et, donc, ce qu’on va tester unitairement. Bien joué.

```markdown
# Add resource for POST /accounts

- [ ] Receive AccountCreationRequest
- [ ] Send request to AccountCreationService and get account ID
- [ ] Respond 202 CREATED
- [ ] Respond location header for newly created account (with new ID)

We only need a simple javax resource with a `create` method.
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/issues/2))*

### Add account creation service

Good, après ça, le service de création de compte. On a juste à définir ce qu’il fait. Souvenez vous, y’est cool lui, il “orchestre”.

```markdown
# Add account creation service

- [ ] Assemble account from account creation request
- [ ] Add account to repository
- [ ] Return string of account id

Simply implement the chain of commands with a `create` method.
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/issues/3))*

### Assemble account from account creation request

Chaque étape du service représente une tâche en soit, parce que c’est de la job dispatchée à d’autres classes de l’app. La première, c’est l’assemblage du compte, qui vérifie les données et retourne un objet valide.

Vous comprendrez qu’ici, on va avoir plusieurs classes d’assembleur. Chaque objet de domaine devrait avoir son assembleur quand il doit être transformer vers ou depuis une autre couche. Ici, on a le compte, l’ID de compte et l’utilisateur. Le service va juste se servir de celui du compte, mais whatever, on verra rendu là.

```markdown
# Assemble account from account creation request

- [ ] Throw exception if email format is invalid
- [ ] Throw exception if name is empty
- [ ] Throw exception if weight is non-positive
- [ ] Throw exception if height is non-positive
- [ ] Return assembled account

Implement `Account`, `AccountId` and `User` assembly with appropriate classes. Make sure everything is validated and throws correct exceptions.
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/issues/4))*

### Add account to repository

Ensuite le service fait quoi? Il pitch l’objet valide de compte au `Repository`, pour qu’il l’enregistre.

Lui, il a aussi la job de générer un nouvel account ID. Il doit aussi vérifier que l’email n’existe pas déjà dans sa liste.

```markdown
# Add account to repository

- [ ] Throw if email address already exists
- [ ] Generate and set a new account ID
- [ ] Save account in memory list
- [ ] Return newly created account ID

Simple Repository pattern with `create` method. Let's use `create` as a method name instead of `save` or `add`, since we want to create an account ID.
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/issues/5))*

### Send email to newly created account

Ok on veut envoyer un courriel avec l’account ID. On va utiliser un port SMTP pour ça.

```markdown
# Send email to newly created account

- [ ] Use a listener pattern
- [ ] Notify the email sender from the account creation service
- [ ] Send email containing account ID with a SMTP client

At account creation, send an email to the given user email address containing newly created account ID. This is done after the service creates the account with the repository.
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/issues/10))*

### Implement properties file reader for SMTP credentials (local environment)

Pour le courriel, on a besoin de deux issues un peu weird : pour lire ce qu’on a besoin pour utiliser le service SMTP. On a besoin d’une issue pour l’environnement local, avec un fichier .properties, et une issue pour l’environnement déployé, avec des variables d’environnement.

```markdown
# Implement properties file reader for SMTP credentials (local environment)

Requires #10 to be done

- [ ] Setup `data/smtpCredentials.properties`
- [ ] Implement file reader for properties files
- [ ] Read `data/smtpCredentials.properties`
- [ ] Use in SMTP client

This is only for the local environment. Heroku (CD) will need env vars.
```

*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/issues/18))*

### Implement env var obtention for SMTP credentials (deployed environment)

```markdown
# Implement env var obtention for SMTP credentials (deployed environment)

Requires #10 and #11 to be done.

- [ ] Implement env vars reading
- [ ] Add env vars to Heroku
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/issues/19))*

### Return error message and description for account exceptions

Dernier truc pour le use case : on doit retourner un code d’erreur et une description pour chaque exception de l’app. C’est une issue aussi.

```markdown
# Return error message and description for account exceptions

- [ ] Map each account exception to an `ErrorResponse`
- [ ] Map each account exception to an HTTP status for the response

Pretty self-explanatory, we want to map each exception for accounts to a `ErrorResponse` (containing an error and a description) with an associated HTTP status.
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/issues/6))*

### Setup Maven boilerplate

Good, à part ça, il faut qu’on setup des trucs au projet qui sont externes au use case, particulièrement vu que c’est la première itération. On aurait pu se faire une itération juste pour ça, mais la création d’utilisateur est pas super longue.

Donc, on veut avoir un setup de base, une ressource pour tester la couche d’API et un test unitaire. On va avoir une base pour le reste de l’app.

```markdown
# Setup Maven boilerplate

- [ ] Setup basic Maven project `pom.xml`
- [ ] Add template resource
- [ ] Add template unit test

Just make sure the resource can be accessed and tests can be run.
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/issues/7))*

Pour ça, j’vais utiliser un label “setup”. C’est pas du règlage de use case, c’est du setup de projet.

### Activate Dependabot to check for new packages

Ensuite, j’avais parlé d’activer Dependabot. Ça check les nouvelles versions des packages qu’on utilise.

```markdown
# Activate Dependabot to check for new packages

Requires #7 to be done

- [ ] Simply activate Dependabot on `pom.xml`
- [ ] Add Dependabot badge to `README.md`
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal28/space-elevator/issues/8))*

### Implement CI workflow

Aussi, on veut implémenter un Continuous Integration, donc de checker notre code style et nos tests unitaires à chaque push et pull request.

```markdown
# Implement CI workflow

Requires #7 to be done

- [ ] Add CI on develop push and pull requests
- [ ] Check style
- [ ] Run tests
- [ ] Require CI to pass on each pull request to develop
- [ ] Add CI workflow badge to `README.md`

Use `.github/workflows/ci.yml` for this.
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal27/space-elevator/issues/9))*

Pour le CI et CD, on pourrait utiliser un label `devops` plutôt que `setup`, mais j’vais regrouper ça dans `setup`, vu que ça sera fait direct après le boilerplate du projet, avant de faire les use cases.

### Implement CD workflow

On veut pouvoir tester l’app déployée, soit la dernière version de develop. Pour ça, on va utiliser Heroku.

```markdown
# Implement CD workflow

Requires #7 to be done

- [ ] Setup Heroku application
- [ ] Build app
- [ ] Send app to Heroku
- [ ] Add CD workflow badge to `README.md`
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal27/space-elevator/issues/11))*

### Implement code coverage reporting

On veut aussi utiliser [codecov](https://about.codecov.io/) pour reporter notre code coverage. On va intégrer ça au CI pour pas laisser le code coverage pas dropper d’un certain pourcentage.

```markdown
# Implement code coverage reporting

Requires #9 to be done

- [ ] Add jacoco for reporting code coverage
- [ ] Add CI step to upload to codecov
- [ ] Add code coverage badge to `README.md`
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal27/space-elevator/issues/12))*

### Create Postman request for POST /accounts

On veut utiliser Postman pour stocker nos requêtes faites à l’API. On va faire un issue pour `POST /accounts`.

```markdown
# Create Postman request for POST /accounts

Add requests in `resources` directory, from root of repository
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal27/space-elevator/issues/13))*

### Create Postman end-to-end tests for POST /accounts

Dans Postman, on veut aussi un test pour le good path, le cas normal de création d’utilisateur, et un test pour chaque extension du use case, chaque raison d’invalidité. C’est des end-to-end tests. Ça test l’app qui roule en envoyant des requêtes.

```markdown
# Create Postman end-to-end tests for POST /accounts

Implement the following end-to-end tests : 

- [ ] Valid account data
- [ ] Invalid email format
- [ ] Empty name
- [ ] Non-positive weight
- [ ] Non-positive height
- [ ] Existing email

Add end-to-end tests in `resources` directory, from root of repository
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal27/space-elevator/issues/14))*

### Implement End-to-End workflow

Savez-vous c’qui est malade avec les tests end-to-end? On peut les plugger en workflow ou pipeline pour s’assurer que nos tests marchent sur develop. Avec notre CD, on peut automatiser tout ça.

```markdown
# Implement End-to-End workflow

Requires #11 and #14 to be done.

- [ ] Use newman to create a workflow that checks end-to-end tests on the deployed app.
- [ ] Add End-to-End workflow badge to `README.md`
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal27/space-elevator/issues/15))*

Petite note, notre app va être unit testée sur tout ce qui fait du sens de unit test. On va avoir quelques tests e2e pour la surface, mais c'est tout.

### Add API documentation for POST /accounts

Ensuite, on veut générer une API doc sur la couche REST. On veut écrire nos routes, les méthodes HTTP et les formats de requêtes et réponses qu’on a.

J’dois encore décider de la techno pour ça. J’hésite entre [Swagger](https://swagger.io/) et [raml2html](https://github.com/raml2html/raml2html). Si vous avez une préférence, hésitez pas à me le faire savoir!

```markdown
# Add API documentation for POST /accounts

- [ ] Decide if we use Swagger, raml2html or something else
- [ ] Setup API documentation accordingly to Postman request and end-to-end tests
- [ ] Setup GitHub pages for API documentation on develop branch
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal27/space-elevator/issues/16))*

### Unleash release 0.1.0

Et mes ami-e-s, finalement, on lâche la release 0.1.0. La création d’utilisateur est implémentée sur develop et main. On tag main comme version 0.1.0 et on fini l’itération.

```markdown
# Unleash release 0.1.0

- [ ] Remove template resource
- [ ] Remove template test
- [ ] Cleanup app
- [ ] Close all release 0.1.0 issues
- [ ] Merge develop to main
- [ ] Release 0.1.0 with tag on main
- [ ] And finally, close milestone 0.1.0

It's time, folks.
```
*(disponible sur le [repo du projet](https://github.com/ExiledNarwal27/space-elevator/issues/17))*

J’vais utiliser un label `release`, vu que c’est ni une feature, ni d’la doc, ni quoi que ce soit d’autre.

Ciboire. Sérieux j’regarde ça pis wow. J’ai une quantité conne d'articles à faire. Nice.

## Placement dans le project board

Alright, on a parlé du project board un peu dans le [dernier article]({% post_url 2021-01-24-github-repository-basics %}). Là, toutes les nouvelles issues ont été placées dans mon project board à cause des règles automatiques que j’ai mis. Mes colonnes du tableau kanban ont des settings pour que les cartes se placent direct. GitHub propose des automatisations déjà faites. Si vous voulez voir les settings de mes colonnes, check out [mon repo](https://github.com/ExiledNarwal28/space-elevator/projects/1) hehehehehehhe

J’les ai juste cordé dans le bon ordre pour les faire logiquement.

## Conclusion

Simonaque mes chums. On a fini les issues. Bien joué, c’est clair pis ça va être facile à régler.

Très bon chargé de projet. Je le recommande à 100%.

Dans le prochain article, on tombe dans le chantier. On construit les fondations de notre projet Maven en Java. J’espère que vous avez autant hâte que moi de sortir de l’ostie de documentation pis d’attaquer le projet.

Alright, portez-vous bien, salut là!

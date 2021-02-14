---
layout: post
title:  "Choosing cycles and creating issues"
date:   2021-02-13
categories: [project, git]
lang: en
lang-ref: choosing-cycles-and-creating-issues
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/WGkTudoBUHY" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Yo! The time has come to decide our development cycles and to create issues on GitHub.

## The cycles

We'll first decide our cycle for the [stories](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories) and [use cases](https://github.com/ExiledNarwal28/space-elevator/wiki/Use-cases) we have.

Do you know what [planning poker](https://en.wikipedia.org/wiki/Planning_poker) is? The stories we made fits with the agile scrum methodology. Planning poker makes us decide an estimate of the amount of effort to put in each story. We give each of them a number from the Fibonacci sequence. Then, we divide huge tasks and we choose our cycles. Each cycle groups tasks with around the same total effort.

We can do that with stories or with precise functionalities within each story, or even with issues.

We won't do that. We converted our stories in technical use cases and we'll use directly that.

I'll go the easy way : each epic becomes a cycle. That's user creation, pass creation, elevator usage, bill payment and reporting. Each epic will be a cycle to version 1.0.0.

We'll start with cycle 1 : version 0.1.1, which we'll implement [user creation](https://github.com/ExiledNarwal28/space-elevator/wiki/Use-cases-1-:-User-creation).

Hey, by the way, I changed "adventure" to "epic" in my wiki. It's a translation mistake. I was used to say "aventure" in French, but I shouldn't translate that literally.

## First milestone on GitHub

Before creating issues, we'll set our [milestone](https://docs.github.com/en/github/managing-your-work-on-github/about-milestones).

That's "Release 0.1.0". We don't need an end date, since I'm not going to stress over my posts :)

We can describe it as the implementation of account and user creation and tell with story / use case it's coming from.

## Deciding issues

Good, so what are our tasks? We want to create an account and a user. The use case represents many steps to respond correctly to what is demanded. From a programming standpoint, each requirement is often a task, something to implement.

We have our [routes](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes) which represent each endpoint of our REST layer for given use cases We, it's `POST /accounts`.

What do we want to do? Without talking about bills or passes yet. We want to create a simple user. We want : 
- That the account is saved in the application.
- Send JSON data to `POST /accounts`
- That we get `201 CREATED` if it works
- That we get `400 BAD REQUEST` if it does not work.
  - Invalid email address format
  - Invalid name (empty string)
  - Non-positive weight
  - Non-positive height
- That we get `409 CONFLICT` if email already exists.
- That we return the new account ID as a header location, like `/accounts/:accountId`
- Anddddd that a email is sent to the new user

## Notes on hexagonal architecture

Good, let me warn you, we're getting technical. I'll make an article about this soon, but, right now, I'll explain some things out about [hexagonal architecture](https://blog.octo.com/en/hexagonal-architecture-three-principles-and-an-implementation-example/)

So, we'll make ourselves a plan of the architecture. Basically :

In the middle, there's the domain. That's pure. That's our business logic, our domain rules and how everything works. It's the concepts that we found [last time]({% post_url 2021-01-13-aggregate-heads-and-domain-conceptualization %}) : accounts, users, passes, bills and all that. Those classes we'll have those exact names.

All around the app, it's our ports to external services. Like : 

- The REST layer, which responds to HTTPS calls as JSON
  - We'll use `Resource` classes, that represent the access points of the REST layer, the endpoints, the URIs to our items and collections
- The infrastructure layer, which is our database
  - We'll use `Repositories`, with methods like `get`, `save` and `update`, that hides under the hood the technical aspects of the database without worrying about it's type (in memory, SQL, NoSQL, ...). If we had a complexe database, `DAO`, [Data Access Object](https://en.wikipedia.org/wiki/Data_access_object), would be useful. Not in our case, we'll use the RAM.
- Clients, that use other APIs  
- The system on which the app is running
- SMTP, for emails
- Console, and many other

It's how our app communicates with other software.

To glue all that up, we got a [service layer](https://martinfowler.com/eaaCatalog/serviceLayer.html). Most of the time, a service represents a use case. To say it cute, we say it "orchestrate the domain". That's beautiful. How do we call a unit test for a service? Since it only calls other classes that operates the logic, we just want to see that the data flows the right way and that it's stable, it's an "orchestration test". That means nothing and I love it.

If a service smells, it looks like a god class. If your domain is wise, if it holds enough logic to solve itself, your services will be as pretty as they can be. As a matter of proof, that's how we'll build them.

Ok!

![Simple hexagonal architecture diagram](/public/img/posts/diagram-simple-hexagonal-artchitecture.png)
*(Simple hexagonal architecture diagram, available on the [project's wikiwiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Hexagonal-architecture))*

The regular flow of our architecture, or at least the one to create a user / account, is : 

- The JSON data is mapped into request objects by the `Resource`, in the API layer. The `Resource` sends it to the service and responds `201 CREATED` with the newly created account's endpoint, which contains the new account ID.
- The service does many things.
  - First, it assembles the object request into valid domain objects. That assembly is handled by a class on its own, which throws exceptions for each different reason the data could be invalid. Don't forget : email duplication validation is not made here. We'll need our saved data for that.
  - The service receives the valid `Account` object, with its `User`.
  - It sends it to the `Repository`. It's saved there.
    - The `Repository` also creates the ID. We could do that at the assembly, but reference generation is normally the job of the storing technology. In our case, we'll have a generator class that does just that.
    - Also, the `Repository` throws an exception if the email already exists.
  - The service receives the new account ID
  - An email is sent with the new account ID
    - That happends in the SMTP and filesystem layer. Why filesystem? Because, in the local environment, we'll get the credentials for the used STMP email address from a file.
  - The account ID is then returned to the REST layer
  
On top of all that, there's exception mappers. In the app, exceptions are classes we throw. The HTTP is handled by the REST layer, with an exception mapper. Of course, in the `Repository`, the fact that an already existing email is `409 CONFLICT` isn't handled there, we're in the infrastructure layer, the database. We launch an exception and the REST layer catches it.

## Notes on project setup

___

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

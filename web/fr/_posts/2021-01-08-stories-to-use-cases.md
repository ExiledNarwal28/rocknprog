---
layout: post
title:  "De récits à cas d'utilisation (use-cases)"
date:   2021-01-08
categories: [project, documentation]
lang: fr
lang-ref: stories-to-use-cases
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/ddQfKbyG_fA" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Salut!

Aujourd’hui on saute dans les use-cases. La dernière fois, on a changé une liste de fonctionnalités en récits et, maintenant, on est rendu à convertir ça en cas d’utilisation.

Si ce qui vous intéresse c’est d’aller de fonctionnalités à stories, j’vous envoie sur mon dernier article, ["De fonctionnalités à récits (stories)"]({% post_url 2020-12-31-functionalities-to-stories %}). Sinon, restez avec moi, on va faire des beaux use-cases.

J'vous invite à lire la liste de récits qu'on a, disponible sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories), et on va passer au next. En gros, on a :

 - Aventure 1 : Création d’utilisateurs
 - Aventure 2 : Achat et listage de passes d’accès à l’ascenseur
 - Aventure 3 : Accès à l’ascenseur avec une passe d’accès
 - Aventure 4 : Paiement de factures
 - Aventure 5 : Rapports d’événements (on veut obtenir des rapports complets pour des données de l’app)
   
Ok. Les use-cases.

## Qu'est-ce qu'un cas d'utilisation?

C’est quoi ça? Un cas d’utilisation [c’est comment, au plan technique, fonctionnel, les utilisateur s interagissent avec votre application et dans quel but](https://en.wikipedia.org/wiki/Use_case). Dans les récits, j’avais utilisé des personas. Ici, on va traduire ça en acteurs / actrices de l’app.

![Exemple de cas d'utilisation, sous forme de diagramme](/public/img/posts/example-use-case-diagram.png)
*(exemple de cas d'utilisation, sous forme de diagramme, tiré de [Wikimedia](https://commons.wikimedia.org/wiki/File:Use_case_restaurant_model.svg))*

Souvent, on retrouve ça sous forme de diagrammes. C’est des schémas des exigences fonctionnelles de votre application, donc de vos fonctionnalités. Ici, je vais plutôt y aller textuellement avec un beau template que j’ai trouvé en ligne.

![Exemple de cas d'utilisation textuel](/public/img/posts/example-use-case-text.png)
*(exemple de cas d'utilisation textuel, tiré du [blogue de Warren Lynch](https://warren2lynch.medium.com/use-case-description-example-4b04280d6435))*

Moi, je vais écrire directement les requêtes et réponses en JSON attendues par la couche d’API. De la documentation, tant qu’à la faire, autant la faire pour qu’elle soit explicative et pratique. Ma documentation d’API, rendu là, sera pas mal semblable à mes cas d’utilisation. Mais, c’est ça le but : que le livrable final réponde le plus possible à que ce qui est demandé. Si les calls à faire sont pareils aux exigences fonctionnelles fixées, ça veut dire qu’on a fait notre job comme il faut.

On va décrire le cas d’utilisation, ses étapes et toutes les conséquences possibles en fonction des variantes (extensions). Pour ça, je vais traduire trois récits en cas d'utilisation.

First : On a groupé nos stories en aventures / epics. Good. Comment on groupe nos use-cases? De mon bord, j’vais juste faire des pages différentes sur mon wiki. J’vais avoir des use-cases de structure très similaire à mes récits pour montrer clairement le lien entre les deux.

## Cas d'utilisation : Création d’utilisateur

```markdown
Bob wants to create a user. They enter the following information : 

 - Email address
 - Full name
 - Height in centimeters
 - Weight in kilograms

Bob wants to receive an email confirming their user creation.
```
*(récit de création d'utilisateur sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

On va faire le use-case de la création d’utilisateur. Si on lit le récit, il s’agit d’envoyer des données valides pour créer le compte et c’est tout. Good, on va faire ça. Un seul use-case pour ce récit-là.

En passant, y’a des trucs qui ont changés dans les récits parce que j’trouvais que ça faisait pas de sens. J’vais y revenir rendu là. Ici, j’ai changé le poids de grammes à kilogrammes. Aussi, on veut recevoir un courriel qui confirme la création d'utilisateur.

 - Description : “Une personne veut créer un utilisateur pour accéder aux fonctionnalités de l’application”
 - Acteurs : On avait Bob et Alice, mais là on veut ça sous forme de rôle. Ici, c’est “Utilisateur de l’ascenseur”.
 - Pré-condition : L’email n’existe pas dans le système.
 - Post-condition : On veut envoyer un courriel.
   
Good. Alors c’est quoi les actions pour ça?

 1. On entre les informations pour créer le compte. On va spécifier les types des attributs JSON, pis on va donner un exemple. Les exemples, on va les copier-coller dans la doc des calls d’API rendu là. Aussi, cette étape implique de vérifier les données qu’on envoie. 
 2. On valide que l’email existe pas déjà. 
 3. On répond l’account ID avec un location header du call HTTP.
    
Nice! J’avais parlé d’extensions, mais c’est quoi ça? On peut voir ça comme les exceptions de chaque étape. C’est pas mal littéralement les types d’exceptions, que notre domaine, que notre app, va handler. Pour chaque donnée qu’on envoie, il peut y avoir aucune, une ou plusieurs erreurs possibles. Histoire d’aider le monde qui se sert de l’app, on va fournir un code d’erreur pis une description assez solide.

Même si notre app c’est un simple API qui répond et reçoit des calls HTTP en JSON, on va documenter nos erreurs le plus possible. C’est pas parce qu’on fait juste un backend pis qu’on va peut-être être les seuls à y faire un frontend qu’on va pas couvrir l’éventuelle possibilité que quelqu’un d’autre travaille sur nos affaires. Histoire d’être un bon samaritain, on va être précis et descriptif le plus possible, surtout quand c’est pour faire planter des calls.

Ok.

Question de même? C’est quoi les types possibles pour un attribut JSON? [Checkez ben ça.](https://www.w3schools.com/js/js_json_datatypes.asp) Y’a six types différents. Donc, si tu veux un chiffre comme type d’attribut, un number, ça veut dire que y’a cinq façons différentes de faire potentiellement planter ton call, en plus de tes règles de domaines pis des formats que tu veux.

On a de la job. Listons les extensions pour chaque étape.

 - 1a. On envoie quoi en premier? Le courriel. Comment il peut être invalide? Si ton courriel est pas du bon format, ça marche pas. J’avais parlé des autres types que string? Le format, techniquement, ça couvre ça aussi. C’est une erreur assez générale pour ça. Oubliez pas que quand vous envoyez pas un attribut JSON à Java, quand il le sérialise en objet, la donnée membre est juste nulle. Là, je parle pas de si vous avez des décorateurs / règles plus précises ou si vous utilisez Jackson. En tout cas, on s’en rejase dans un autre article.
 - 1b. Le nom complet. On veut quoi? Un string non-vide.
 - 1c. Le poids? Un nombre positif. Pas besoin de vérifier si la donnée est débile.
 - 1d. La taille? Idem, un nombre positif. 
 - 2e. On valide si le courriel existe dans le système. La seule chose qui peut faire planter, c’est si l’email existe déjà.
   
L’étape 3, est-ce qu’elle peut planter? Comme les autres étapes, elle peut planter si l’app plante elle-même. Genre, un bug, un throw non couvert. On va lâcher un erreur 500 si ça arrive, mais ça veut dire que le problème est de notre bord.

Voici le use-case que ça donne : 

<table>
  <tr>
    <th colspan=3>User creation</th>
  </tr>
  <tr>
    <td>Description</td>
    <td colspan=2>A non-user creates a user to access the users' functionalities of the application</td>
  </tr>
  <tr>
    <td>Actors</td>
    <td colspan=2>Elevator users</td>
  </tr>
  <tr>
    <td>Pre-condition</td>
    <td colspan=2>The user's email must not already be in use</td>
  </tr>
  <tr>
    <td>Post-condition</td>
    <td colspan=2>After a successful user creation, an email is sent to the user containing their account id.</td>
  </tr>
  <tr>
    <th>Main Scenarios</th>
    <th>Serial No</th>
    <th>Steps</th>
  </tr>
  <tr>
    <td>Actors/Users</td>
    <td>1</td>
    <td>
      Enter email, full name, weight and height : 
<pre lang=json>
{
  "email": string,
  "fullName": string,
  "weight": number,
  "height": number
}
</pre>
      Example : 
<pre lang=json>
{
  "email": "jean.paul@email.com",
  "fullName": "Jean Paul",
  "weight": 77.1,
  "height": 183
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>2</td>
    <td>Validate email does not already exist</td>
  </tr>
  <tr>
    <td></td>
    <td>3</td>
    <td>Respond newly created account id as a location header.</td>
  </tr>
  <tr>
    <td>Extensions</td>
    <td>1a</td>
    <td>
      Missing or invalid email format. The following is returned : 
<pre lang=json>
{
  "error": "INVALID_EMAIL_FORMAT",
  "description": "Email must be of a valid format, such as email@domain.com"
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>1b</td>
    <td>
      Missing, empty or bad type for full name. The following is returned : 
<pre lang=json>
{
  "error": "INVALID_FULL_NAME",
  "description": "Full name must be a non-empty string"
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>1c</td>
    <td>
      Missing or non-positive weight. The following is returned : 
<pre lang=json>
{
  "error": "NON_POSITIVE_WEIGHT",
  "description": "Weight (in kilograms) must be a positive number"
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>1d</td>
    <td>
      Missing or non-positive height. The following is returned : 
<pre lang=json>
{
  "error": "NON_POSITIVE_HEIGHT",
  "description": "Height (in centimeters) must be a positive number"
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>2e</td>
    <td>
      Already existing email. The following is returned : 
<pre lang=json>
{
  "error": "ALREADY_EXISTING_EMAIL",
  "description": "Email {{email}} already exists in the system : please choose another one or use the associated account ID"
}
</pre>
    </td>
  </tr>
</table>
*(cas d'utilisation de création d'utilisateur sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Use-cases-%3A-User-creation))*

## Cas d'utilisation : Achat de passe d’accès à usage unique

```markdown
Bob wants to buy a one-time use access pass. This pass allows Bob to enter and leave the space station using the elevator. To create this pass they need to :

- Specify this is a one-time use access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob. Bob wants to receive an email confirming their bill creation.
```
*(récit d'achat de passe d'accès à usage unique sur le [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Good, selon le récit 2.1, en tant qu’utilisateur, je peux acheter une passe d’accès à usage unique juste en précisant que ça en est une. Pas trop pire.

 - Les acteurs? Les mêmes que l’autre use-case, les utilisateurs de l’ascenseur.
 - Pré-condition? L’utilisateur doit exister.
 - Post-condition? On envoie un courriel (oui j’ai changé ça dans les récits) et on facture le compte. Parf.
   
Les étapes?

 1. On entre l’ID de compte. Ça va simplement être dans le path URI pour tout de suite, mais whatever. 
 2. On doit spécifier que c’est un one-time use. Pour ça, j’vais avoir une énumération de valeurs possibles pour de quoi qu’on appeler “periodType”. Comme ça, en créant ta passe d’accès, tu sélectionne son type et tu envoie les données que t’as besoin. Ici, on a juste à dire que le “periodType” c’est “oneTimeUse”. 
 3. On répond le code d’accès, en location d’header HTTP, comme à l’autre use-case.
    
Good! Et maintenant, comment ça peut planter?

 - 1a. Si l’ID de compte n’existe pas, c’est un 404 not found. Qu’il soit fautif, null, ou de mauvais format, dans tous les cas, si on l’a pas, ça plante.
 - 2b. On envoie seulement le type de période. Comme on veut que ça soit une valeur dans une énumération, on veut planter si le type envoyé n’existe pas.
   
Alright, c’est juste ça!

<table>
  <tr>
    <th colspan=3>One-time use access pass creation</th>
  </tr>
  <tr>
    <td>Description</td>
    <td colspan=2>A user creates a one-time use access pass to use the elevator</td>
  </tr>
  <tr>
    <td>Actors</td>
    <td colspan=2>Elevator users</td>
  </tr>
  <tr>
    <td>Pre-condition</td>
    <td colspan=2>The account must be created</td>
  </tr>
  <tr>
    <td>Post-condition</td>
    <td colspan=2>After a successful access pass creation, an email is sent to the user containing their access pass code. Also, an associated bill is added to the account.</td>
  </tr>
  <tr>
    <th>Main Scenarios</th>
    <th>Serial No</th>
    <th>Steps</th>
  </tr>
  <tr>
    <td>Actors/Users</td>
    <td>1</td>
    <td>Enter account ID</td>
  </tr>
  <tr>
    <td></td>
    <td>2</td>
    <td>
      Enter period type : 
<pre lang=json>
{
  "periodType": string
}
</pre>
      Example : 
<pre lang=json>
{
  "periodType": "oneTimeUse"
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>3</td>
    <td>Respond newly created access pass code as a location header.</td>
  </tr>
  <tr>
    <td>Extensions</td>
    <td>1a</td>
    <td>
      Non existent account ID. The following is returned : 
<pre lang=json>
{
  "error": "ACCOUNT_NOT_FOUND",
  "description": "Account with ID {{accountId}} not found"
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>2b</td>
    <td>
      Bad value for period type. The following is returned : 
<pre lang=json>
{
  "error": "INVALID_PERIOD_TYPE",
  "description": "Period type must be one of {{availablePeriodTypes}}"
}
</pre>
    </td>
  </tr>
</table>
*(cas d'utilisation d'achat de passe d'accès à usage unique [wiki du projet](https://github.com/ExiledNarwal28/space-elevator/wiki/Use-cases-%3A-Access-pass-creation))*

## Cas d'utilisation : Achat de passe d’accès pour des dates

___

Prochain use-case : l’achat de passe d’accès pour des dates. Dans ma vidéo précédente, j’ai dis que, rendu à un point plus technique, l’achat de passe pour une ou plusieurs dates reviendrait au même? C’est ici qu’on le voit. On va faire un seul cas d'utilisation, parce que, dans tous les cas, on va vouloir recevoir une liste de dates. Après, si tu veux une seule date, ben, t’en envoie juste une.
Ok, c’est pas mal un copié-collé du dernier use-case, sauf qu’on envoie une liste de dates et que le type de période est setté aux dates.
Y’a un truc qui ajoute du olé-olé par contre. Ça serait cool d’empêcher les utilisateurs d’acheter une passe si la période couverte pas la passe est déjà couverte pas une autre.
J’empêcherai pas d’acheter une passe de mois si t’as déjà la passe pour une date dans le mois. Le contraire, par contre, ferait pas mal de sens. Ça empêcherait les erreurs utilisateurs un peu et, comme on veut que chaque passe appartienne à une seule personne, ça fait du sens. On va donc ajouter cette étape là.
Comment ça peut planter? Comme au précédent use-case, l’account ID et le type de période peuvent être invalider la requête. Et pour les dates?
Ok, on va s’établir des règles de domaine. Est-ce qu’on veut des passes pour des dates avec une liste de dates vide? Non. On veut que chaque date soit du bon format? Ben, pas le choix. Est-ce qu’on veut une passe avec deux fois la même date? Nope. Une date dans le passé? Non. Good!
La dernière exception, c’est ce que j’ai mentionné tantôt, qu’on veut pas acheter une passe d’une durée de temps courte dans une période déjà couverte pas une autre passe.
Hey, avant de voir le reste des cas d’utilisation, j’veux juste rappeler une affaire : les status HTTP. Je pourrais les mettre dans la doc, mais j’pense que, pour les cas d’utilisation, on peut considérer qu’ils sont implicites. J’vais les mettre dans la doc des calls d’API, mais on peut s’entendre que not found c’est 404 pis invalid ou bad format c’est 400.
Cas d’utilisation de passes d’accès
Ok, pis le reste des passes d’accès?
On a les passes pour une semaine et un mois. Pour elle, je vais demander l’année en même temps. Il va falloir pas mal les mêmes choses que pour les passes d’accès de dates.
On a la dernière, pour lister les passes d’accès. Remarquez que celle-là a pas de post-condition, parce que y’a pas de changement d’états dans les données ou d’autre action attendue. On veut juste afficher des informations. La seule façon de faire planter ça, c’est envoyer un mauvais ID de compte.
Cas d’accès à l’ascenseur
Pour l’accès à l’ascenseur, c’est ben simple, on veut seulement monter et descendre.
On veut que l’utilisateur et la passe existe. Faire ça implique ensuite que l’ascenseur est en haut. Pas trop sur de ce que ça implique avec les petites fonctionnalités qu’on a live, mais peu importe.
Donc, les étapes, c’est
Entrer l’ID de compte
Entrer le code de passe d’accès
Entrer la date, parce que je veux pas assumer que le système où l’application roule est toujours la date qu’on veut et pour simplifier les tests.
On valide que l’utilisateur est pas déjà monter dans la station
On valide la passe d’accès pour la date donnée
On répond que c’est good!
Les exceptions à lancer sont à peu près ce que vous vous attendez pour chaque étape listée. Le cas d’utilisation pour descendre est le même, mais, à l’envers.
Cas d’utilisation de factures
Pour les factures on voulait quoi? Pas mal juster les payer et les lister.
Pour payer, le compte et la facture doivent exister. On s’entend à ce qu’après, le montant qu’on paie soit enlever de la facture.
Les étapes?
Entrer l’ID de compte
Entrer le numéro de facture
Entrer le montant à payer. On va assumer que ça vient d’une autre app à nous sécure et que l’argent va vraiment être payée.
On répond la facture à jour. On pourrait juste faire un HTTP status, mais c’est un peu poche de pas au moins montrer le nouveau montant du. On va répondre le bill au complet pour être fin.
Les erreurs?
Le compte existe pas
Le bill existe pas
Le montant à payer est pas un chiffre positif
Le montant payé surpasse ce qui est du
Pis pour lister? Ça ressemble à la liste de passe d’accès. Y’a pas grande vérification à faire à part l’ID de compte et on répond la liste de factures.
Cas d’utilisation de reporting
Aight, la bête noire. Le reporting va être rough, genre pas mal plus qu’on pense. J’vais vous montrer les cas d’utilisation mais y’a 1000 concepts là-dedans qu’on a pas à retenir tout de suite. Ça va être pas mal plus tard dans le projet.
On a cinq cas d’utilisation, qui correspondent aux cinq récits, qui correspondent aux cinq métriques. On va faire une twiste, on va quand même laisser les gens prendre plusieurs métriques en même temps, parce que ça nous complique pas tant la job et ça met tout ça dans le même christie de call HTTP. On va uniformiser le reporting.
Avant qu’on passe dans les cas d’utilisation, juste savoir que j’ai changé les récits de reporting parce que les combinaisons métriques/dimensions que j’avais mis marchaient pas.
En gros, on veut :
Que la personne s’authentifie
Demande la ou les métriques qu’a veut
A demande les dimensions qu’a veut, qui fittent avec les métriques demandées, et c’est pas obligatoire
A demande l’année de la période voulue
A demande le mois, si elle veut affinée sa période, donc c’est pas obligatoire
Le scope, donc comment on fragmente temporellement la période qu’on veut
Si on veut, on demande les fonctions d'agrégats, donc le regroupement de données pour avoir le minimum et tralala
Ensuite, on répond le data dans ce format-là. Comme vous pouvez voir, ça ressemble pas mal au diagramme que j’ai montré l’autre fois.
Les raisons de plantés sont :
Authentification qui marche pas
Aucune métrique sélectionnée
Métrique qui n’existe pas
Dimension qui n’existe pas
Dimension qui n’existe pas pour une des métriques données
Année absente
Année invalide
Mois invalide
Portée / scope absent
Scope invalide
Fonction d'agrégat invalide
Ok. Pis c’est la même affaire pour chaque métrique, soit la création d’utilisateurs, la création de passe, la création de bill, le paiement de bill et l’utilisation de l’ascenseur.
Fiou.
En passant, pour les métriques, les dimensions, le scope et la période, c’est des query parameters. C’est pas du JSON à envoyer en body, c’est un GET à faire en spécifier des paramètres dans le URI.
Conclusion
OK.
J’espère que vous avez aimé ça. C’était juste de la doc, mais c’était plus le fun à faire que je pensais. Le prochain vidéo va être quand même cool. On va faire des dessins. Astheure qu’on a les cas d’utilisations techniques de l’app, c’est le temps de décortiquer notre domaine. On va trouver les têtes d'agrégats et on va lister nos objets principaux.
Alright, à la prochaine, SALUT LÀ.
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

Okay!

Now, let's find out the main classes of the domain and the whole aggregate for all that. I'll use [diagrams.net](https://www.diagrams.net/), which used to be draw.io, an app I really like.

Here is the complete diagram. The rest of this post will be dedicated to explain each concept and why it's structured that way.

![Conceptualization of the domain's main classes](/public/img/posts/diagram-conceptualization-classes.png)
*(conceptualization of the domain's main classes, available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Main-classes-diagram))*

I'll go package by package. To remove any confusion, when I'll talk about a concept (a class) that goes into another package, it will be written in bold.

### Package : `Accounts`

Let's start with accounts and users. Like I said, the only aggregate head are the accounts. If I said it, it must be true.

`Account` : What's in an account? We got an ID and a user. Eventually, we could have a list of users, but that's not the case right now.

`AccountId` : Good! The account ID, what is that? It'll be a UUID. Though, we'll make a wise move and we'll place this in another class. So, we'll make a value object out of it. This way, if the type of ID ever changes, if we need a number instead of a UUID, it reduces the ripple effect and we won't have much to change to the app and the tests.

`User` : Ok! The user. In fact, it's the information of an account. Like I said, we only got one per account right now, but that's not a problem. We'll have the information we send at the account creation, so the email, full name, weight and height. We'll also have a list of access passes and the creation instant, that will be used for reporting.

Do we need an identifier for users? Now right now, no need for a `UserId` or anything alike. We already know that the email is unique, so we could temporarily use that. But, if, one day, we have many users per account, we should add a `UserId`. Story for another time.

Good! I'll put those in green. They are in the same package, so that's cool.

`Instant` : What is an instant? It represents a precise time. It's in blue, since **it's in another package**.

### Package : `AccessPasses`

Alright, let's do the access passes package.

`AccessPass` : The access pass contains its code, creation instant, period type, covered periods, elevator usage list and bill. The covered periods are a list, since we can have many dates. If the pass is for a week or a month, it'll have a single period in its list.

`AccessPassCode` : Ok, what about the code? Like the account's ID, it's a value object. It'll be a string that will generate somehow. We'll see how to create that when we'll code it. For right now, just know it's a class separated from the access pass.

`PeriodType` : The period type is a simple enumeration.

Alright, let's make this purple.

`Period` : The period **goes into the same package as the instants**. It's a start and an end. No need to go any further.

`Date`, `Week` and `Month` : Wait, how do we display the information for dates, weeks and months? Without going into details, we'll have complex classes that represent those period types. I'll place them **in the same package as the instants**.

### Package : `ElevatorUsages`

`ElevatorUsage` and `ElevatorDirection` : For right now, the elevator usage is only saved for reports. I want to have an intelligent domain that does not need a classe to register events happening for the sake of reporting. So, we'll have a class for the elevator usage. We only need the instant and the direction. The direction is an enumeration.

A beautiful orange for that. I could put those two into the access passes package, but I feel like it lacks consistency with the other concepts.

### Package : `Bills`

Alright, bills and money.

`Bill` : Bills are a class that contains the bill number, creation instant, reason, description, amount and payment list.

`BillNumber` : Bill number is very alike account ID and access pass code, so we want a value object, a class separated from bills.

`BillReason` : What else? Reason, it's an enumeration. Easy enough.

`Money` : Money will also be its own class. Let's start with a value object. Maybe, in the future, we could have something more intelligent, like having some concepts of currency conversion. Anyways, let's place it there for now. Access pass prices for a period type will also use this. Without going too far, that will be a class that contains a map. It will return a price, a `Money`, in function of a period type.

`BillPayment` : Payments. Why do I make a class for this? Once again, it's because I'm aware of my reporting needs. We want to store each payment that was made. So, we'll make a list and a separate class that only contains the instant and the amount paid.

In red, because capitalism is evil.

Hey, why don't accounts contain the bills? Honestly, that would make sense, but I know that for the sake of reporting, I need to know if an access pass has payments on its bill. So, I place it there. If we ever have other bill reasons, we'll have to change this structure a bit, but it's nothing to worry about.

### Package : `Reports`

Okkkkkkkkkkkkkkkkk, the fucking reports.

I planned the domain so that it's wise enough not to need a lightweight class of event registering. Nice! Though, we still have to define some concepts : dimensions, metrics, periods, scopes, ...

I won't add this to the conceptualization. We'll see all of those in one or many posts about this precise subject. At that point, we'll have to draw again.

`Quarter` and `Year` : With what we have right now, let's just know we'll have classes that defined weeks, months, quarters and years. Some of those are already used by access passes. Alright, I'll just add the missing periods to the diagram. **That's gonna be in the `Instants` package.**

Note that those arrows are white, not black. It's not gonna be some simple heritage, there's gonna be a lot of concepts to implement. For a quick diagram, a different arrow color is enough.

## Back to the complete diagram

Bam, we got our final diagram of simplified domain!

![Conceptualization of the domain's main classes](/public/img/posts/diagram-conceptualization-classes.png)
*(conceptualization of the domain's main classes, available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Main-classes-diagram))*

One last thing, here are the dependencies for the packages. As you can see, there's no circular dependency and the whole thing makes sense : 

![Conceptualization of the domain's main packages](/public/img/posts/diagram-conceptualization-packages.png)
*(conceptualization of the domain's main packages, available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Main-classes-diagram))*

YEAH WE ARE DONE WITH THE DOMAIN. WE ONLY NEED TO CODE IT NOW.

I hope you liked this. I'm actually proud of the job we've done. Our domain is pretty and logical. I'm happy.

The next post will be about endpoints and routes in our REST API. Also, I'll got into what is REST.

Until next time, see ya!

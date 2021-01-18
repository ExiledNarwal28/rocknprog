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

Note that, here, `/books` is an endpoint. It's also the aggregate head of this example. In fact, all paths, all routes, to a resource is an endpoint. When we'll code all that, we'll try to find a structure that is as clear as possible into small resources (here, I mean a class, not a REST resource).

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

Good, now that we got many things defined, let's apply those to our project. We'll use the [use-cases](https://github.com/ExiledNarwal28/space-elevator/wiki/Use-cases) and the [main classes diagram](https://github.com/ExiledNarwal28/space-elevator/wiki/Main-classes-diagram) to find the URIs and the actions in our app.

![Conceptualization of the domain's main classes](/public/img/posts/diagram-conceptualization-classes.png)
*(conceptualization of the domain's main classes, available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Main-classes-diagram))*

What actions do we have in our app?

 * Create an account (an a user, at the same time)
 * Buy an access pass
 * List an account's access passes (a user's, actually)
 * List an account's bills
 * Pay a bill
 * Use the elevator
 * Ask for a report

Ok, let's do this step by step.

### Route : Create an account

According to our holy main classes diagram, `Account` is the aggregate head of pretty much everything. So, it's gonna be the starting point of what an account possesses, like access passes and bills.

How do we create a user? `POST /accounts`. We receive JSON and respond the location of the newly created account with its ID. `201 CREATED` if it's good, `400 BAD REQUEST` if the data is invalid.

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
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : Buy an access pass

Ok, and how do we buy a pass? Passes will be under `/accounts/:accountId/accessPasses`. Since we have a single user by account, even if it's the user and not the account that owns the passes, it still makes sense in a REST API.

So it's a `POST /accounts/:accountId/accessPasses`. We received JSON for the new pass and we respond its code as a header location. It created the pass and the bill, which I will explicitly write. I won't talk about emails, because it does not concern the API layer. Same thing for account creation. What are the statuses? `201 CREATED` if it's good, `400 BAD REQUEST` is the data is invalid and `404 NOT FOUND` if the account ID does not exist.

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
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : List an account's access passes

Good, listing passes? It's a collection under the accounts, so we just need a `GET`. `200 OK` if it works, `404 NOT FOUND` if the account ID does not exist. We respond passes as JSON.
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
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : List an account's bills

Very similarly, to list an account's bills, we'll use a `GET`. `200 OK` if it works, `404 NOT FOUND` if the account ID does not exist. We respond bills as JSON.

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
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : Pay a bill

Good, and paying a bill? We'll have `/accounts/:accountId/bills/:billNumber`, but how do we pay. If you remember, I said that `POST` can also be used for actions on a resource. If we want to be RESTful, we'll have the action `pay` on an item of the bill collection.

We receive JSON of the amount to pay. `200 OK` if it works, `400 BAD REQUEST` if the amount to pay is invalid, `404 NOT FOUND` if the account ID or bill number does not exist. The bill number must not only exist, it must exist within the account. It's pretty clear with how our resources are structured in the URI. Finally, we respond the updated bill as JSON.

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
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : Use the elevator

Alright, we're at the elevator usage. Logically, wince we use passes, we will have an action on them with a `POST`, no?

Now wouldn't that make some goddamn sense, but there's a problem. Look at the [stories](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories#adventure-3--elevator-access) : “They enter only the access pass code.”.

The way I see it, the endpoint `/accounts` and everything beneath it is for account management, buying and paying. When we use the elevator, we do not want to enter our account ID. We only want to use our access passe code, like if we scanned to pass at the elevator entrance.

To me, it's necessary to have a second endpoint. Anyway, if we want to move this into the passes, it's not too complicated. So, I'll make another endpoint. Personally, I don't like putting a reference / identifier in a request body. I'll throw it in the path.

Good, we'll have `/elevatorUsage/:accessPassCode/goUp` to go up and `/elevatorUsage/:accessPassCode/goDown` to go down. We could place the code in the JSON, but I think this way of doing things is pretty clean. Let me know if you believe it should be changed. Once again, it's not a big change.

So, we send JSON for the date. We respond `200 OK` if it works, `400 BAD REQUEST` if the date is invalid, `403 FORBIDDEN` if the pass do not cover the given date or if the user is already up in the station when going up, or already down on Earth when going down, and `404 NOT FOUND` if the pass do not exist.

Quick question : why `200 OK` and not `202 ACCEPTED`? According those names, it would make more sense, no? Sorry, names of status codes are not always on-point. `202 ACCEPTED` implies that the request has been accepted, but is still being processed. In our case, `200 OK` makes more sense.

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
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

### Route : Ask for a report

Ah, reports. For all the reports we'll have to produce, a single URI with query parameters can do the job : a simple `GET /reports`.

This endpoint needs an authentication. Metrics, year and scope query parameters are necessary. Dimensions, month and aggregations query parameters are optional. We repond `200 OK` if it works, `400 BAD REQUEST` if we have invalid query parameters and `401 UNAUTHORIZED` if the authentication is incorrect. We respond the list of periods for the requested report.

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
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

## And finally

Bam, done! We got our [planned routes for our REST API](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes). It's as follows : 

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
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Planned-routes))*

You know, when I talk about API documentation? Well, that's a mix of the document we made today and the request bodies described in the use-cases. But... the documentation we have been doing since my first post is just planning. We didn't code anything yet. The thing with API documentation, it's that it's not requirements for what your app must do, it's what your app actually does. It's what it expects to received and what is responds. Don't worry, we'll look into that soon enough.

Hey, we've only built our wiki yet. It's enough. In the next post, we'll start working on our GitHub repo. I'll show you which files must be added at the repository's base and which sections are the most important on GitHub. Know that all of this also applies to GitLab, Bitbucket or any other source code hosting service.

But! Folks, I'm starting my last full-time semester of university. I wrote posts at an amazing rate so far, but I will have a lot less free time. I have to get my diploma. I should be able to add one or two post a month. You can always send me an email if I can help you with anything, or if you want tips on plants survival.

Alright, big love, see ya!

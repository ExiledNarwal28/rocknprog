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
    - That happens in the SMTP and filesystem layer. Why filesystem? Because, in the local environment, we'll get the credentials for the used STMP email address from a file.
  - The account ID is then returned to the REST layer
  
On top of all that, there's exception mappers. In the app, exceptions are classes we throw. The HTTP is handled by the REST layer, with an exception mapper. Of course, in the `Repository`, the fact that an already existing email is `409 CONFLICT` isn't handled there, we're in the infrastructure layer, the database. We launch an exception and the REST layer catches it.

## Notes on project setup

Alright, we'll need more tasks. We got to setup the project.

From this post and on, you'll get that each post we'll probably be dedicated to one issue each. Each problem to solve here is one more concept to cover on this site. If you want me to talk about something first, let me know!

So, to setup our project, we'll need : 

- Create a boilerplate, the base of our project, in Maven
- Add [Dependabot](https://dependabot.com/) for new packages
- A CI, [Continuous Integration](https://www.cloudbees.com/continuous-delivery/continuous-integration)
- A CD, [Continuous Deployment](https://searchitoperations.techtarget.com/definition/continuous-deployment)
- Upload our code coverage reports
- [Postman](https://www.postman.com/) Requests to test all that
- Some Postman [end-to-end tests](https://www.katalon.com/resources-center/blog/end-to-end-e2e-testing/)
- An API documentation

## Writing issues of the first cycle

Alright people we got job to do. I'll use the issue templates for feature requests I made in the [last post, about the basic of a GitHub repository]({% post_url 2021-01-24-github-repository-basics %}).

### Add resource for `POST /accounts`

First step, we'll add the resource for `POST /accounts`. It must receive a request, send it to the service, return `202 CREATED` and respond the new ID.

I'll assign myself to each issue, add it to the project and set the milestone. I'll make a `use-cases-1` label to show which use case group we're solving. We could have labels for each layer of the architecture, but nah.

For the smartest of y'all, you'll know that the tasks I write correspond to the contract for each class, what they must be doing and, so, what we'll unit test. Well done.

```markdown
# Add resource for POST /accounts

- [ ] Receive AccountCreationRequest
- [ ] Send request to AccountCreationService and get account ID
- [ ] Respond 202 CREATED
- [ ] Respond location header for newly created account (with new ID)

We only need a simple javax resource with a `create` method.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/issues/2))*

### Add account creation service

After that, the service for account creation. We'll have to define what it does. Remember, this one "orchestrate".

```markdown
# Add account creation service

- [ ] Assemble account from account creation request
- [ ] Add account to repository
- [ ] Return string of account id

Simply implement the chain of commands with a `create` method.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/issues/3))*

### Assemble account from account creation request

Each step of the service corresponds to a task, since its job is to dispatch jobs to other classes. The first job is account assembly, which verifies the given data and return a valid domain object.

You'll understand that here, there are going to be many assembler classes. Each domain object will have its own assembler, if we need to transform it from layer to layer. Here, we got the account, the account ID and the user. The service will only know the account one, but, whatever, we'll see when we'll get there.

```markdown
# Assemble account from account creation request

- [ ] Throw exception if email format is invalid
- [ ] Throw exception if name is empty
- [ ] Throw exception if weight is non-positive
- [ ] Throw exception if height is non-positive
- [ ] Return assembled account

Implement `Account`, `AccountId` and `User` assembly with appropriate classes. Make sure everything is validated and throws correct exceptions.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/issues/4))*

### Add account to repository

What does the service do after that? It sends the valid domain object to the `Repository`, which saves it.

Its job is also to set a new account ID and to make sure the email does not already exist.

```markdown
# Add account to repository

- [ ] Throw if email address already exists
- [ ] Generate and set a new account ID
- [ ] Save account in memory list
- [ ] Return newly created account ID

Simple Repository pattern with `create` method. Let's use `create` as a method name instead of `save` or `add`, since we want to create an account ID.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/issues/5))*

### Send email to newly created account

Ok, and we want to send an email with the account ID. We'll use the SMTP port for that.

```markdown
# Send email to newly created account

- [ ] Use a listener pattern
- [ ] Notify the email sender from the account creation service
- [ ] Send email containing account ID with a SMTP client

At account creation, send an email to the given user email address containing newly created account ID. This is done after the service creates the account with the repository.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/issues/10))*

### Implement properties file reader for SMTP credentials (local environment)

For the email, we'll need two weird issues : to read what we need to use the SMTP service. We'll need an issue for the local environment, where we use a .properties file, and an issue for the deployed environment, where we use environment variables.

```markdown
# Implement properties file reader for SMTP credentials (local environment)

Requires #10 to be done

- [ ] Setup `data/smtpCredentials.properties`
- [ ] Implement file reader for properties files
- [ ] Read `data/smtpCredentials.properties`
- [ ] Use in SMTP client

This is only for the local environment. Heroku (CD) will need env vars.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/issues/18))*

### Implement env var obtention for SMTP credentials (deployed environment)

```markdown
# Implement env var obtention for SMTP credentials (deployed environment)

Requires #10 and #11 to be done.

- [ ] Implement env vars reading
- [ ] Add env vars to Heroku
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/issues/19))*

### Return error message and description for account exceptions

Last thing for this use case : we'll return an error code and a description for each exception of the app. That's an issue too.

```markdown
# Return error message and description for account exceptions

- [ ] Map each account exception to an `ErrorResponse`
- [ ] Map each account exception to an HTTP status for the response

Pretty self-explanatory, we want to map each exception for accounts to a `ErrorResponse` (containing an error and a description) with an associated HTTP status.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/issues/6))*

### Setup Maven boilerplate

Other than that, we'll need to setup some basic things for our project that do not directly concern the use case, since it's the first cycle. We could have had a single cycle for that, but user creation is fairly simple.

So, we'll need to have a basic setup, a resource to test the API and a unit test. That's the template for the rest of the app.

```markdown
# Setup Maven boilerplate

- [ ] Setup basic Maven project `pom.xml`
- [ ] Add template resource
- [ ] Add template unit test

Just make sure the resource can be accessed and tests can be run.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/issues/7))*

For that, I'll use a `setup` label. It's not use case solving, it's project setup.

### Activate Dependabot to check for new packages

I talked about Dependabot. It checks for new versions of the packages we use.

```markdown
# Activate Dependabot to check for new packages

Requires #7 to be done

- [ ] Simply activate Dependabot on `pom.xml`
- [ ] Add Dependabot badge to `README.md`
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/issues/8))*

### Implement CI workflow

Also, we want to implement a continuous integration, to check our code style and unit tests at each push and pull request.

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
*(available on the [project's wiki](https://github.com/ExiledNarwal27/space-elevator/issues/9))*

For the CI and CD, we'll could use a `devops` label rather than `setup`, put I'll put them in `setup` too cause I'll do that alongside the setup, before working on use cases.

### Implement CD workflow

We'll want to test our deployed add, so the last version of `develop`. For this, we'll use [Heroku](https://www.heroku.com/).

```markdown
# Implement CD workflow

Requires #7 to be done

- [ ] Setup Heroku application
- [ ] Build app
- [ ] Send app to Heroku
- [ ] Add CD workflow badge to `README.md`
```
*(available on the [project's wiki](https://github.com/ExiledNarwal27/space-elevator/issues/11))*

### Implement code coverage reporting

We'll also use [codecov](https://about.codecov.io/) to report our code coverage. We'll integrate it to the CI to not let the code coverage drop from a given percentage.

```markdown
# Implement code coverage reporting

Requires #9 to be done

- [ ] Add jacoco for reporting code coverage
- [ ] Add CI step to upload to codecov
- [ ] Add code coverage badge to `README.md`
```
*(available on the [project's wiki](https://github.com/ExiledNarwal27/space-elevator/issues/12))*

### Create Postman request for `POST /accounts`

We'll use Postman to store our requests made to the API. We'll make an issue for `POST /accounts`.

```markdown
# Create Postman request for POST /accounts

Add requests in `resources` directory, from root of repository
```
*(available on the [project's wiki](https://github.com/ExiledNarwal27/space-elevator/issues/13))*

### Create Postman end-to-end tests for `POST /accounts`

In Postman, we want to set a test for the good path, the normal case of user creation, and a test for each extension of the use case, for each invalidity reason. Those are end-to-end tests, which require the app to be running.

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
*(available on the [project's wiki](https://github.com/ExiledNarwal27/space-elevator/issues/14))*

### Implement End-to-End workflow

You know what's awesome with end-to-end tests? You can add them to your workflow or pipeline and make sur the tests pass on `develop`. With our CD, we can automate all that.

```markdown
# Implement End-to-End workflow

Requires #11 and #14 to be done.

- [ ] Use newman to create a workflow that checks end-to-end tests on the deployed app.
- [ ] Add End-to-End workflow badge to `README.md`
```
*(available on the [project's wiki](https://github.com/ExiledNarwal27/space-elevator/issues/15))*

Side note, our app will be unit tested on everything that makes sense unit testing. We'll have some e2e tests on the surface layer, but that's it.

### Add API documentation for `POST /accounts`

Then, we want to generate an API documentation on the REST layer. We'll want to write our routes, the HTTP methods and the request / request format we got.


I still need to decide the technology I'll use for that. I'm hesitating between [Swagger](https://swagger.io/) and [raml2html](https://github.com/raml2html/raml2html). If you got any suggestion, let me know!

```markdown
# Add API documentation for POST /accounts

- [ ] Decide if we use Swagger, raml2html or something else
- [ ] Setup API documentation accordingly to Postman request and end-to-end tests
- [ ] Setup GitHub pages for API documentation on develop branch
```
*(available on the [project's wiki](https://github.com/ExiledNarwal27/space-elevator/issues/16))*

### Unleash release 0.1.0

And finally, my friends, we launch release 0.1.0. Use creation is implemented on `develop` and `main`. We tag main as version 0.1.0 and we finish the cycle.

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
*(available on the [project's wiki](https://github.com/ExiledNarwal27/space-elevator/issues/17))*

I'll use a `release` label since its neither a feature nor documentation nor anything else.

Damn. I got a lot of posts to make to get through all that. Nice.

## Placement in the project board

Alright, I talked about the project board in my [last post]({% post_url 2021-01-24-github-repository-basics %}). Today, all my new issues were placed in the project board automatically because of some rules I set. The columns of my kanban board have settings to cards get placed directly. GitHub offers some pre-made automations. If you want to se my columns settings, checkout my [repo](https://github.com/ExiledNarwal28/space-elevator/projects/1) hehehehe

I still re-ordered them to make it more logical.

## Conclusion

Well folks. We finished writing our issues. Congratulations, it's clear and it'll be easy to solve.

Great project lead, 100% recommended.

In the next post, we're going big. It's time we set up our Maven project. I hope you're as happy as me to get out of documentation and attack the project.

Alright, wish you the best, see ya!

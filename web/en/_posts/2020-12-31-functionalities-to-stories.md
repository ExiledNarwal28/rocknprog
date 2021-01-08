---
layout: post
title:  "From functionalities to stories"
date:   2020-12-31
categories: [project, documentation]
lang: en
lang-ref: functionalities-to-stories
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/T-DEoxwhnQA" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Hi!

Today, I will present to you the first part of a guide to go from a list of functionalities to stories to use-cases. I decided to cut this guide in two so I can present some concepts better. If you want to see how to go from stories to use-cases, check out the next article, ["From stories to use-cases"]({% post_url 2021-01-08-stories-to-use-cases %}).

Alright.

I wrote about a space elevator. What are we doing exactly?

Honestly, I will provide some basic elements of what we have to do, but those are really surface-level.

The thing is, this project is only used to present some concepts of software development. So, here, I'm writing a list of functionalities we want in our final product. But, spoiler alert, we might do more and we might do less. Things that require the same concepts or technologies as previously covered subjects will be either not done at all or done offscreen.

Also, as I wrote, I'll go from a list of functionalities and we will build together the stories and precise use-cases that we want. Why? Because, at school or at work, you will have to start your project from one of those things. So, I prefer starting from functionalities and, if you want, you can only read what you need. What I will not do is cover what happens before having the list of functionalities. Sorry, but if you only have a vague idea or a sales pitch, you will have the responsibility to write this list. Worry not, it's pretty much the easiest part.

## Functionalities

Ok.

Here is the list of functionalities I wrote for an app that handles a space elevator. I wrote this quick on a GitHub wiki (but we'll come back to GitHub in another article).

```markdown
 - User creation
 - One-time use passes
 - Period passes (single date, many dates, week or month)
 - Usage of passes to access the elevator
 - Transactions and bills
 - Reporting of events
 - Authentication on sensible routes
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Functionalities))*

Those are the functionalities I thought about. We might add more and it's up to you to give me some suggestions. Though, beware, I got a lot of things to cover already and we're starting from zero.

Good, so we're at the next step : stories (and personas). I had projects where stories were directly given, instead of only providing a list of functionalities. As it's not always the case, we'll write them together.

## Personas

The first step is decided what the personas are. What's that? Personas are typical users of your application. Normally, we would write them a name, a life and many personnal traits unrelated or not to the project, but we'll only give them a name and a function. I see two in our app : someone who buys passes and use the elevator and someone who creates reports. If we add more distinct functionalities, like maintaining the elevator or listing employees, we would have other personas. But here, no need.

![Example of persona](/public/img/posts/example-persona.png)
*(example of persona, from [Roman Pichler's blog](https://www.romanpichler.com/blog/persona-template-for-agile-product-management/))*

Also, side note, it's usually good to have many personas for the same functionalities. For instant, for pass creation, there could be a lot of different people that wants to do the same actions. Those people do not all have the same background and needs. Here, we're building an API that received and sends basic JSON, we're not making a website or a mobile app on top of that. Though, if we had to do this, it would be a good idea to have multiple ways to do the same actions, depending on how people want and except to use the app.

So, how do we name our personas? I say the user that creates passes and uses the elevator is Bob. The one creating reports is Alice. Names might not look like much, but they add some magic to our documentation and they help us remember we're doing this whole thing for people, not only to transfer and process data from one end to the other.

I'll let you read what I wrote.

```markdown
## Bob - User of passes

 - Wants to use the space elevator for one-time uses
 - Wants to use the space elevator for periodic uses
 - Wants (?) to pay their bills

## Alice - Administrator of the elevator

 - Wants to create reports of user creation
 - Wants to create reports of access pass creation
 - Wants to create reports of bill payments
 - Wants to create reports of elevator usage
 - Wants nobody else to access reports creation
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

## Stories

Good, personas are done, we're not at writing stories. What are those? Stories represent something someone wants to do with the app. It's the step before use-cases. Stories are more global than use-cases, they help explaining what the app those (and what we want it do to) to our bosses and clients, without going too much into details.

![Example of story](/public/img/posts/example-story.png)
*(example of story, from [Aha!](https://www.aha.io/roadmapping/guide/requirements-management/what-is-a-good-feature-or-user-story-template))*

I will fully explain three stories and I will go fast over the rest. We will see user and pass creation.

Grouping stories in adventures (or epics) by similarities and goals is often a good idea.

We got Bob. Bob wants to buy access passes. To do this, they first need to create a user and, only then, they can buy passes. What information do we need? Normally, I'd say asking for their email and name is sufficient. Though, we must think about what we need in our app. We are building an app that handles a space elevator. Okay it's fictive, but whatever. I say wee need their weight and height. Anyway, that's what I'll assume.

```markdown
### Adventure 1 : User creation

#### Story 1 : User creation

Bob wants to create a user. They enter the following information :

- Email address
- Full name
- Height in centimeters
- Weight in grams
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Good. Adventure 2 : Pass buying. Let's write the story to buy one-time use passes.

What do we need? Since we have no concept of pass category and we do not need any other information then the fact what this is a request for a one-time use pass, I say we stick to this single information. I also like to precise what we want to occur when Bob asks for an access pass. It's not always explicit in the stories we're given, but I believe it helps a lot to write it anyways. It removes all confusion. In this case, we provide Bob an access pass code that they will use to access the elevator and we bill them.

```markdown
### Adventure 2 : Access pass creation

#### Story 1 : One-time access pass creation

Bob wants to buy a one-time use access pass. This pass allows Bob to enter and leave the space station using the elevator. To create this pass they need to : 

 - Specify this is a one-time use access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

We'll see one last story together, and then I'll show the rest really quick. We'll write the story of a single date access pass. What information do we need? Keep it simple : we only need a date.

Oh! But we can also buy a pass for many dates, no? True, but for the actual stories, we do not have to precise how the request will be formatted when requesting the API. That's the job of use-cases, where the JSON will be clearly written.

Here's what I wrote : 

```markdown
#### Story 2 : Periodic access pass creation for a single date

Bob wants to buy a periodic access pass for a single date. This pass allows Bob to enter and leave the space station using the elevator anytime they want within the given date. They enter the following information : 

 - Date for access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Alright, this is taking a long time. Let's see what else I wrote for the list of functionalities previously presented.

For adventure 2, the creation / buying of access passes, we only need one story per period type and one story to list passes. Then again, that's a lot of precision. I'd rather have too much information in my documentation then not enough. This way, what has to be done is clear. Do not forget that in the context of a school project, you can always add your own stories, if you believe the ones you got lack precision!

```markdown
#### Story 3 : Periodic access pass creation for many dates

Bob wants to buy a periodic access pass for a many dates. This pass allows Bob to enter and leave the space station using the elevator anytime they want within the given dates. They enter the following information :

- Dates for access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob.

#### Story 4 : Periodic access pass creation for a week

Bob wants to buy a periodic access pass for a week. This pass allows Bob to enter and leave the space station using the elevator anytime they want within the given week. They enter the following information :

- Week for access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob.

#### Story 5 : Periodic access pass creation for a month

Bob wants to buy a periodic access pass for a month. This pass allows Bob to enter and leave the space station using the elevator anytime they want within the given month. They enter the following information :

- Month for access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob.

#### Story 6 : Listing access passes

Bob wants to know which access passe they own. Access passes that are not available anymore must be at the end. Other access passes must be ordered by date (earliest not-passed date for many dates and start date for week and month).
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Adventure 3 : Elevator access. Ok, I gotta say that, writing this, I realized that a cool upgrade our app could have would be trips of many users, instead of giving access to one person at the time. Fuck it, this goes in the backlog.

We'll only have two stories : one to go up to the space station and one to go down on Earth.

```markdown
### Adventure 3 : Elevator access

#### Story 1 : Going up

Bob wants to use their access pass to ascend. They enter only the access pass code.

Of course, Bob can only ascend if they are on Earth.

#### Story 2 : Going down

Bob wants to use their access pass to descend. They enter only the access pass code.

Of course, Bob can only descend if they are up in the station.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Adventure 4 : Bill payment. We only want Bob to pay and list their bills. To pay a bill, only a bill number is required, which we can get by listing our bills. Makes sense.

```markdown
### Adventure 4 : Bill payment

#### Story 1 : Paying a bill

Bob wants (?) to pay their bill. To do so, they only enter the bill number. They only need to enter the amount to pay.

#### Story 2 : Listing bills

Bob wants to list their bills. Bills must be ordered by date. Paid bills are placed at the bottom.
```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

If you didn't see through my game, I'm organising my stories the same way I will organise my REST API calls. We'll come back to that, but, if you know, you know.

Last adventure, 5 : Event reporting.

For that, we will use a reporting architecture of scope-period-dimension-metric style. We'll come back to the concepts in another article, but, basically, each story is a metric that we want to calculate in the app. We can group data (max, min, ...) and we can dimension (separate) data of metrics according to some criterias. It might seem weird and overkill, but it's fun and it's clean so eh.

![Reporting architecture](/public/img/posts/diagram-reporting.png)
*(reporting architecture of scope-period-metric-dimension style (in French, sorry xx))*

```markdown
### Adventure 5 : Event reporting

Annie wants to report events happening in the app. For this, they want to use a scope-period-metric-dimension style reporting.

All reports can be displayed as : 

 - Grouped by day, week, month, quarter or year
 - Aggregated by maximum, minimum, average and median

#### Story 1 : User creation reporting

Annie wants a report of user creation by date. This can be displayed as : 

 - Dimensioned by if they have a bill or not
 - Dimensioned by if a bill has payment or not
 - Dimensioned by if a bill was fully paid or not

#### Story 2 : Access pass creation reporting

Annie wants a report of access pass creation by date. This can be displayed as : 

 - Dimensioned by period type
 - Dimensioned by if a bill has payment or not
 - Dimensioned by if a bill was fully paid or not

#### Story 3 : Bill creation reporting

Annie wants a report of bill creation by date. This can be displayed as : 

 - Dimensioned by if bill code (reason)
 - Dimensioned by if bill has payments or not
 - Dimensioned by if bill is fully paid or not

#### Story 4 : Bill payment reporting

Annie wants a report of bill payment by date. This can be displayed as : 

 - Dimensioned by if bill has payments or not
 - Dimensioned by if bill is fully paid or not

#### Story 5 : Elevator usage reporting

Annie wants a report of elevator usage by date. This can be displayed as : 

 - Dimensioned by if bill has payments or not
 - Dimensioned by if bill is fully paid or not
 ```
*(available on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Yeah! Done!

One thing I did not mention is authentication. Creating a user hardly requires a lot of security, but we do have to make sure a user is the actual user when buying passes or paying bills, no? Right, but we'll say screw this for now. That we'll become a nice-to-have that we might add later.

Another thing I did not mention is the price of the access passes. It could be written with the stories but, for this project, we'll only use a static file that lists prices according the period types for access passes.

Goooooooooood.

Alright people, we have stories. I hope this article helped you understand how to go from a list of functionalities to adventures (epics) and stories, as well as what all of those are.

In the next article, we'll go from stories to use-cases.

Alright, see ya!

 - [Project's wiki, where all the mentioned doc is available](https://github.com/ExiledNarwal28/space-elevator/wiki)

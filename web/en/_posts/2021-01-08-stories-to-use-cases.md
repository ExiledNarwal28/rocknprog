---
layout: post
title:  "From stories to use-cases"
date:   2021-01-08
categories: [project, documentation]
lang: en
lang-ref: stories-to-use-cases
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/ddQfKbyG_fA" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Hi!

Today, we're jumping into use-cases. Last time, we changed a list of functionalities to a list of stories and, now, it's time to convert all that to use-cases.

If what you're interested in is to go from functionalities to stories, let me send you to my previous post, ["From functionalities to stories"]({% post_url 2020-12-31-functionalities-to-stories %}). Otherwise, stick with me, we'll make some beautiful use-cases.

Let me also invite you to read the list of stories that we got, hosted on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories). Briefly, we got : 

- Adventure 1 : User creation
- Adventure 2 : Access pass creation and listing
- Adventure 3 : Elevator access using an access pass
- Adventure 4 : Bill payment and listing
- Adventure 5 : Event reporting (we want to generate complete reports for some of the app's data)

Ok. Use-cases.

## What is a use-case?

What's that? A use cas is [how, from a technical, functionnal, point of view, users interact with your app and to which end](https://en.wikipedia.org/wiki/Use_case). In the stories, I used personas. Here, we'll translate those into actors of the app.

![Example of a use-case diagram](/public/img/posts/example-use-case-diagram.png)
*(example of a use-case diagram, from [Wikimedia](https://commons.wikimedia.org/wiki/File:Use_case_restaurant_model.svg))*

In the wild, we'll most likely find them in their diagram form. Those a schemas of the functional requirements of your app, so, of your functionalities. Here, I'll instead go for a textual approach with a nice template I found online.

![Example de textual use-case](/public/img/posts/example-use-case-text.png)
*(example of a textual use-case, from [Warren Lynch's blog](https://warren2lynch.medium.com/use-case-description-example-4b04280d6435))*

Personally, I'll write directly the JSON requests and responses sent and received by the API layer. Documentation, since we have to write some, it's better to make it as descriptive and useful as possible. When it will be time to write the API documentation, it will pretty much look like the use-cases. But hey, that's the goal : that the final product responds as perfectly as possible to what is asked. If the API calls are the same as the functional requirements, well, that simply means the job is done.

I'll describe some use-cases, their steps (actions) and all the possible consequences of their variants (extensions). For this, I'll translate three stories into use-cases.

First, we grouped stories into adventures / epics. Good. How do we group our use-cases? In my case, I'll make separate pages on my wiki. I'll have the same grouping for my use-cases as the one I used for my stories. This way, the link between the two documentation artifacts will be clear.

## Use-case : User creation

```markdown
Bob wants to create a user. They enter the following information : 

 - Email address
 - Full name
 - Height in centimeters
 - Weight in kilograms

Bob wants to receive an email confirming their user creation.
```
*(story of user creation on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

We'll make the use-case for user creation. If we read the story, it's only about sending valid data to create an account. That's a single use-case.

By the way, some things have changed in to stories because they didn't make sens. I'll come back to it when it's the case. Here, I changed the weight from grams to kilograms. Also, we want to receive an email confirmation for the user creation.

 - Description : “A non-user creates a user to access the users' functionalities of the application"
 - Actors : We had Bob and Alice, but, here, we want those as roles. Here, it's "Elevator users".
 - Pre-condition : The user's email must not already be in use
 - Post-condition : We want to send en email

Good. What are the actions?

 1. We enter the required information to creation an account. We'll specify the JSON data types and we'll give an example. The examples we'll be copy-pasted into the API documentation for each call. Also, this step implies that the sent information is validated.
 2. We validated that the email does not already exist.
 3. We respond the account ID with a location header of the HTTP call.

Nice! I talked about extensions, so what are those? We could see them as exceptions for each step. It's quite literally the exception types that our domain, our application, will handle. For each piece of data received, we can have none, one or many possible errors. We'll provide an error code and a description to help people using our app.

Here if our app is a simple API that responds and receives HTTP calls as JSON, we'll describe our errors as much as possible. It's not because we're only doing a backend and that we might be the only ones making a frontend for it that we won't think about the eventual possibility that someone else works on our stuff. Let's be good people and be ultra-precise, especially when it comes to requests getting refused.

Ok.

Quick question. What are the possible data types for a JSON attribute? [Check this out.](https://www.w3schools.com/js/js_json_datatypes.asp) There are six different types. That means that if you want a number as an attribute, there are five possible ways to obliterate your call, on top of your domain rules and required formats.

We got job to do. Let's list the possible extensions for each step.

 - 1a. What do we send first? An email address. How could be invalid? If your email isn't of the right format, it won't work. I wrote about other data types, but format do really cover all of that. Do not forget that not sending a JSON attribute serializes a null value in Java. That is considering you don't use special decorators or rules and that you're not using Jackson. Anyways, that's a story for another post.
 - 1b. Full name. What do we want? A non-empty string.
 - 1c. Weight? A positive number. No need to validate stupid values.
 - 1d. Height? Same, a positive number.
 - 2e. We validate that the email do not already exist within our system. The only thing that could go wrong, is if that email is already there.

Is there anything that could make the step 3 go wrong? Sure, like all other steps, if the app itself goes wrong. Like, a bug or an unhandled throw. We'll send an error 500 if that happens, but that means it's our problem.

Here's the use-case : 

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
*(use-case of user creation on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Use-cases-%3A-User-creation))*

## Use-case : One-time use access pass creation

```markdown
Bob wants to buy a one-time use access pass. This pass allows Bob to enter and leave the space station using the elevator. To create this pass they need to :

- Specify this is a one-time use access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob. Bob wants to receive an email confirming their bill creation.
```
*(story of one-time use access pass creation on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Good, according to story 2.1, as a user, I can buy an access pass for a single usage only by specifying it's a single-use pass. Not so rough.

 - Actors? The same as the other use-case, so the elevator's users
 - Pre-condition? The user must exist.
 - Post-condition? We send an email (yes, this also was changed in the stories) and the account is billed. Good.

Steps?

 1. We enter the account ID. That's gonna be a simple path URI parameter.
 2. We specify it's a one-time user pass. For this, I'll use an enumeration of possible values for something we'll call "periodType". This way, when creating your access pass, your select the desired type and you send the additional required data. Here, only the period type is necessary.
 3. We respond the access pass code as an HTTP location header, like in the last use-case.

Good. And now, how can it crash?

 - 1a. If the account ID does not exist, that's a 404 not found. If it's faulty, null or of a bad format, it doesn't matter.
 - 2b. We only send the period type. So, we want it to be a valid value of the enumeration.

Alright, that's all of it!

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
*(use-case of one-time use access pass creation on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Use-cases-%3A-User-creation))*

## Use-case : Access pass for dates creation

```markdown
#### Story 2 : Periodic access pass creation for a single date

Bob wants to buy a periodic access pass for a single date. This pass allows Bob to enter and leave the space station using the elevator anytime they want within the given date. They enter the following information : 

 - Date for access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob. Bob wants to receive an email confirming their bill creation.

#### Story 3 : Periodic access pass creation for many dates

Bob wants to buy a periodic access pass for a many dates. This pass allows Bob to enter and leave the space station using the elevator anytime they want within the given dates. They enter the following information : 

 - Dates for access pass

Bob then expects to receive an access pass code, which will be used to access the elevator. This action creates a bill to Bob. Bob wants to receive an email confirming their bill creation.
```
*(stories of access pass for dates creation on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Personas-and-stories))*

Next use-case : buying access pass for dates. You might have guessed that, when reaching a certain technical level, buying an access pass for one or many dates is pretty much the same. We'll write a single use-case since, in all cases, we want a list of dates. If you want a single date, well, you can still only send one.

Ok, this one is pretty much a copy of the last use-case. Though, here, we receive a list of dates and the period type is for dates.

One thing is pretty yeehaw, though. It would be cool to restrict users from buying an access pass for a period already covered by another one of their access passes. I won't stop them from buying an access pass for a month they already have one date covered in. The opposite will be restricted, which makes a lot more sense. That will stop users from making mistakes and, since we want all passes to belong to a single user, it's okay. We'll add that step.

How can it go wrong? Like in the previous use-case, the account ID and period type can invalidate the request. What about the dates?

We'll establish some domain rules. Do we want some passes with no dates? Nope. Do we want all dates to be of correct format? Sure, otherwise they can't be processed. Do we want the same date twice in a pass? No. Do we want dates in the past? Nope. Alright!

I'll add one more exception for what I previously mentioned. If a pass covers the period asked for, that's a big no-no.

<table>
  <tr>
    <th colspan=3>Dates access pass creation</th>
  </tr>
  <tr>
    <td>Description</td>
    <td colspan=2>A user creates an access pass for given dates to use the elevator</td>
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
      Enter period type and dates : 
<pre lang=json>
{
  "periodType": string,
  "dates": array of strings
}
</pre>
      Example : 
<pre lang=json>
{
  "periodType": "dates",
  "dates": [
    "2021-12-01",
    "2021-12-02",
  ]
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>3</td>
    <td>Validate the user do not already have an access pass for given dates (with dates, week or month access passes)</td>
  </tr>
  <tr>
    <td></td>
    <td>4</td>
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
  <tr>
    <td></td>
    <td>2c</td>
    <td>
      Empty array for dates. The following is returned : 
<pre lang=json>
{
  "error": "EMPTY_DATES",
  "description": "Dates array must not be empty"
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>2d</td>
    <td>
       Invalid date format. The following is returned : 
<pre lang=json>
{
  "error": "INVALID_DATE_FORMAT",
  "description": "Date must be of format yyyy-MM-dd, such as 2021-12-01"
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>2e</td>
    <td>
       Repeated dates in array. The following is returned : 
<pre lang=json>
{
  "error": "REPEATED_DATES",
  "description": "Dates in array must not be unique"
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>2f</td>
    <td>
       One of the dates is in the past. The following is returned : 
<pre lang=json>
{
  "error": "DATE_IN_THE_PAST",
  "description": "Dates in array must not be in the past."
}
</pre>
    </td>
  </tr>
  <tr>
    <td></td>
    <td>3g</td>
    <td>
       An access pass associated to the account already covers one of the given dates. The following is returned : 
<pre lang=json>
{
  "error": "PERIOD_ALREADY_COVERED",
  "description": "Access pass {{accessPassCode}} already covers the given period"
}
</pre>
    </td>
  </tr>
</table>
*(use-case of access pass for dates creation on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki/Use-cases-%3A-User-creation))*

Hey, before checking out the other use-cases, I want to make a quick stop : HTTP status codes. I could add them in this doc, but, for the use-cases, we could consider them implicit. I'll add them in the API documentation, sure, but, for now, we can assume a not found is a 404 and an invalid or bad format attribute is a 400.

## Other use-cases

Since this post is getting pretty long, rather than going into details for each of the remaining use-case, I'll let you read through them on the [project's wiki](https://github.com/ExiledNarwal28/space-elevator/wiki). My video presents them completely, but it's in French. You can still watch it if it helps!

Ok.

I hope you liked this. It's only doc, but it was nicer to do that I though. In the next post, we're drawing stuff. Now that we have our technical use-cases figured out, it's time to conceptualize our domain. We'll find the aggregation heads and list our main objects.

Alright, until next time, see ya!

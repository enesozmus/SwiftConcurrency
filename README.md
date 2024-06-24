# 🎛 Swift Concurrency

> - ⚙️ [Error Handling 1](./SwiftConcurrency/ErrorHandling1.swift)
> > Representing and Throwing Errors, Handling Errors, Propagating Errors Using Throwing Functions, Handling Errors Using Do-Catch
> - ⚙️ [Error Handling 2](./SwiftConcurrency/ErrorHandling2.swift)
> > Throw, try and do-catch statements
> - ⚙️ [Concurrency Introduction 1](./SwiftConcurrency/Concurrency1.swift)
> > Concurrency, Defining and Calling Asynchronous Functions, Execution Suspends, How async replaces closure completion callbacks
> - ⚙️ [Concurrency Introduction 2](./SwiftConcurrency/Concurrency2.swift)
> > Why do we need asynchronous functions in Swift and iOS apps?, What is async and await in Swift?, How to write an async function in Swift, Blocking the main run loop for too long makes your app unresponsive, Cooperative Thread Pool
> - ⚙️ [Downloading Images Asynchronously](./SwiftConcurrency/DownloadingImageAsync.swift)
> > (1) @escaping closures (2) Combine (3) Async / Await
> - ⚙️ [Async/Await Keywords and Threads](./SwiftConcurrency/AsyncAwait.swift)
> > Asynchronous tasks and Background threads
> - ⚙️ [Review - From Completion Handler to Async and Await](./SwiftConcurrency/Review)
> > - In this part, we will focus on creating our models from the JSON and an APIService to process the response.
> > - In this part, we will create a generic function to handle the different api endpoints and models and use a Result based completion handler with our own designed API Error.
> > - In this part, we will be introduced to VOODO, a modified MVVM design pattern so that we can create viewmodels and views to display the content that we fetch from our API endpoints.
> > - In this part, we will also be seeing how we can use MockData so that we don't have to always make calls to the API when we design our apps.
> > - In this part, we are going to improve the user experience by doing two things.  Whenever our app is fetching and loading data, we want to present a spinning ProgressView on top of our view to indicate that the data is loading. If an error occurs, then we need to know about it so instead of printing the error to the console we want to present an alert to our users with that error information and ask them to contact us with that information.
> > - In this part, we are going to be implementing the new Asynchronous methods introduced in iOS 15. This will introduce you to new terms such as async and await, @MainActor, and a unit of asynchronous unit of work called a Task.
> > - In this part, we are going to extend that even further by introducing you to parallel asynchronous concurrency using Async let. We will create a new model to contain a user and all of that users posts in an array and use that model after fetching all users and all posts up front in two asynchronous calls running in parallel, when the UsersListView loads thus potentially, reducing the number of network requests.

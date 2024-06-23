//
//  Tasks.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 22.06.2024.
//

import SwiftUI


// MARK: ViewModel
class TasksViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(for: .seconds(5))
        do {
            guard let url = URL(string: "https://picsum.photos/200/300") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("IMAGE RETURNED SUCCESSFULLY!")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200/300") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}


struct TaskBootcampHomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("CLICK ME! ⭐") {
                    Tasks()
                }
            }
        }
    }
}


// MARK: View
struct Tasks: View {
    
    @StateObject private var viewModel = TasksViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
            }
        }
        .onDisappear {
            fetchImageTask?.cancel()
        }
        .onAppear {
            fetchImageTask = Task {
                await viewModel.fetchImage()
            }
            //            Task {
            //                print(Thread.current)
            //                print(Task.currentPriority)
            //                await viewModel.fetchImage()
            //                //await viewModel.fetchImage2()
            //            }
            //            Task {
            //                await viewModel.fetchImage2()
            //            }
            /*
            Task(priority: .high) {
                try? await Task.sleep(for: .seconds(2))
                print("high -> \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .userInitiated) {
                print("userInitiated -> \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .medium) {
                print("medium -> \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .low) {
                print("low -> \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .utility) {
                print("utility -> \(Thread.current) : \(Task.currentPriority)")
            }
            Task(priority: .background) {
                print("background -> \(Thread.current) : \(Task.currentPriority)")
            }
             */
            
            /*
            Task(priority: .low) {
                print("low : \(Thread.current) : \(Task.currentPriority)")
                
                //                Task {
                //                    print("low-inside / none -> \(Thread.current) : \(Task.currentPriority)")
                //                }
                //                Task.detached {
                //                    print("low-inside / detached -> \(Thread.current) : \(Task.currentPriority)")
                //                }
            }
             */
        }
    }
}


// MARK: Preview
#Preview {
    //Tasks()
    TaskBootcampHomeView()
}


/*
     🔴 Task
         - Asynchronous functions are just one of the building blocks of Swift concurrency.
         - Tasks are another critical piece.
         - Conceptually, a task{} is a unit of work that can be run asynchronously.
         - Task{} in Swift is an asynchronous operation that provides an alternative to traditional methods like DispatchQueue.main.async {}.
         - More specifically, an instance of the Task type provides an environment where you can execute asynchronous functions or methods.
         - By using Task, we can simplify our code and gain better control over asynchronous operations.

         ✅ Tasks can be arranged hierarchically, allowing you to run several tasks in parallel.
         - This approach is called structured concurrency, and it helps manage operations that affect all the children of a task, such as suspension and cancellation.

         ✅ Swift also allows you to explicitly create and manage tasks according to your program’s needs.
         - This approach, in turn, is called unstructured concurrency.
         - The most common use of unstructured tasks is to call an asynchronous function from synchronous code, something you need in Swift programs and SwiftUI apps, which are inherently synchronous.

         ⏬ Additionally, Task offers additional options that can be explored to further enhance task execution.
         1️⃣ One of these options is the priority parameter, which allows us to set the "priority" of the task to be executed. This functionality replaces the need to use .global(qos:) from GCD, making the code more readable and concise.
         2️⃣ Another interesting option is the use of the @MainActor attribute, which replaces DispatchQueue.main. This attribute allows the task to be executed on the main thread, simplifying code that deals with user interface updates and avoiding concurrency issues.
         3️⃣ It is possible to cancel a task using the cancel() method. This allows for interrupting the execution of an ongoing task, providing more control over the flow of asynchronous execution.
         4️⃣ Another interesting feature is the ability to create tasks that are completely decoupled from the main flow, replacing the use of Thread {} with Task.detached {}. This approach offers a more modern and secure alternative for handling execution in separate threads.


             func oldConcurrencyCode() {
                 DispatchQueue.main.async {
                     // Runs on main thread asynchronously
                 }
                 OperationQueue.main.addOperation {
                     // Runs on main thread queued
                 }
                 DispatchQueue.global(qos: .background).async {
                     // Runs on global thread asynchronously
                 }
                 let operationQueue = OperationQueue()
                 operationQueue.qualityOfService = .background
                 operationQueue.addOperation {
                     // Runs on thread queued
                 }
             }

     🟢 The improved version of the code below utilizes Task to implement the same functionalities as the previous code, making it simpler and more understandable for developers:

             func newConcurrencyCode() {
                 Task {
                     // Executes asynchronously on the main thread
                     // Depending on whether the newConcurrencyCode function
                     // is implemented by an object protected by MainActor previously
                 }
                 
                 Task { @MainActor in
                     // Executes asynchronously on the main thread
                     // explicitly
                 }
                 
                 Task(priority: .background) {
                     // Executes asynchronously on any thread
                     // with background priority
                 }
             }

     🟢 See the following example, which illustrates how to make an asynchronous request and update the views:

             func doSomeRequest() async throws -> MyModel {
                 // Make the request and throw an error if any occurs.
             }

             @MainActor
             func makesRequestAndUpdateViews() async {
                 do {
                     let model = try await doSomeRequest()
                     view.updateModel(model)
                 } catch {
                     view.switchErrorState(error)
                 }
             }
 */

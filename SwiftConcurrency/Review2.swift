//
//  Review2.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 25.06.2024.
//

import SwiftUI

// MARK: View
struct Review2: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .onAppear {
            runTest()
        }
    }
    
    private func runTest() {
        print("Test started!")
        //runStruct()
        //printDivider()
        //runClass()
        //runStruct2()
        //runClass2()
        runActor()
    }
}



/// Extensions
///
///
// MARK: Extension - 1
extension Review2 {
    
    private func runStruct() {
        let objectAA = MyStruct(title: "I'm a Struct")
        print("Struct -> ObjectAA   -> \(objectAA.title)")
        /*
            ⚠️ just their values  -> objectBB = objectAA
            objectBB is actually totally distinct and separate from objectAA.
         */
        print("❗️Pass the just VALUES of objectAA to ObjectBB")
        //let objectBB = objectAA
        // 🟥 By default, instances of structs are immutable when declared as constants with let. If you need to modify a property of a struct instance, you must use a variable declared with var.
        var objectBB = objectAA
        print("Struct -> ObjectBB   -> \(objectBB.title)")
        
        /*
            ! Cannot assign to property: 'title' is a 'let' constant
            ! Change 'let' to 'var' to make it mutable
         */
         
        /*
            ❗️When we are changing the title property inside objectBB  inside struct we're actually mutating the struct and to mutate a struct is actually swapping out totally switching what this object be is.
            ❗️We are actually swapping out totally switching what this objectBB is we are not going into objectBB and changing values inside of it although it looks like that what we are really doing is totally getting rid of the old objectBB and creating a new objectBB.
         */
        objectBB.title = "Tarabya"
        print("ObjectBB title changed.")

        print("Struct -> ObjectAA  Then  -> \(objectAA.title)")
        print("Struct -> ObjectBB  Then  -> \(objectBB.title)")
    }
    
    
    private func runClass() {
        let objectAA = MyClass(title: "I'm a Class")
        print("Class -> ObjectAA   -> \(objectAA.title)")
        
        print("❗️Pass the REFERENCE of objectAA to ObjectBB")
        // 🟥 Instances of classes can be mutable (changeable) even if declared as constants using let.
        let objectBB = objectAA
        print("Class -> ObjectBB   -> \(objectBB.title)")
        
        // just updating
        objectBB.title = "Barbaros"
        print("Class ObjectBB title changed.")

        print("Class -> ObjectAA  Then  -> \(objectAA.title)")
        print("Class -> ObjectBB  Then  -> \(objectBB.title)")
    }
    
    // 🟩 thread safe
    private func runActor() {
        // 🟥 Actor-isolated property 'title' can not be referenced from a non-isolated context
        Task {
            let objectAA = MyActor(title: "I'm a Actor")
            // 🟥 Every time we want to access something in the -actor, we need to -await.
            await print("Actor -> ObjectAA   -> \(objectAA.title)")
            
            print("❗️Pass the REFERENCE of objectAA to ObjectBB")
            // 🟥 Actor-isolated property 'title' can not be referenced from a non-isolated context
            let objectBB = objectAA
            await print("Actor -> ObjectBB   -> \(objectBB.title)")
            
            // just updating
            await objectBB.updateTitle(newTitle: "Barbaros")
            print("Actor ObjectBB title changed.")

            await print("Actor -> ObjectAA  Then  -> \(objectAA.title)")
            await print("Actor -> ObjectBB  Then  -> \(objectBB.title)")
        }
    }
    
    
    private func printDivider() {
        print("""

        -----------------
        
        """)
    }
}



// MARK: Extension - 2
extension Review2 {
    private func runStruct2() {
        
        var immutableStruct = MyStruct2(title: "I'm an Immutable Struct")
        print("Immutable Struct -> struct1   -> \(immutableStruct.title)")
        
        immutableStruct = MyStruct2(title: "I'm an Immutable Struct (new Instance)")
        print("Immutable Struct -> struct1   -> \(immutableStruct.title)")
        
        printDivider()
        
        var immutableStruct2 = MyStruct2(title: "I'm an Immutable Struct 2")
        print("Immutable Struct -> struct2   -> \(immutableStruct2.title)")
        
        immutableStruct2 = immutableStruct2.updateTitle(newTitle: "I'm an Immutable Struct 2 (updated)")
        print("Immutable Struct -> struct2   -> \(immutableStruct2.title)")
        
        printDivider()
        
        var mutatingStruct3 = MyStruct3(title: "I'm an Mutating Struct 3")
        print("Immutable Struct -> struct2   -> \(mutatingStruct3.title)")

        mutatingStruct3.updateTitle(newTitle: "I'm an Mutating Struct 3 (updated)")
        print("Immutable Struct -> struct2   -> \(mutatingStruct3.title)")


    }
}



// MARK: Extension - 3
extension Review2 {
    private func runClass2() {
        let class1 = MyClass(title: "I'm a Class")
        print("Class -> ", class1.title)
        class1.title = "I'm a Class (updated)"
        print("Class -> ", class1.title)
        
        printDivider()
        
        let class2 = MyClass2(title: "I'm a Class 2")
        print("Class 2 -> ", class2.title)
        class2.updateTitle(newTitle: "I'm a Class 2 (updated)")
        print("Class 2 -> ", class2.title)

    }
}
    


/// Data Models
///
///
// MARK: Struct
struct MyStruct {
    //let title: String
    var title: String
}
// MARK: Immutable Struct
struct MyStruct2 {
    let title: String
    
    func updateTitle(newTitle: String) -> MyStruct2 {
        MyStruct2(title: newTitle)
    }
}
// MARK: Mutating Struct
struct MyStruct3 {
    //var title: String
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}
// MARK: Class
class MyClass {
    //let title: String
    var title: String
    
    init(title: String) {
        self.title = title
    }
}
class MyClass2 {
    //let title: String
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}
// MARK: Actor
actor MyActor {
    //let title: String
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}


#Preview {
    Review2()
}

/*
     🔴 In common
         1️⃣ Structures and Classes are general-purpose of a template using the same syntax to define constants, variables, and functions.
         2️⃣ They both define properties to store values and methods to provide functionality. If we want to create an object with some properties and behaviors, we can use both of them.
         3️⃣ They both define subscripts to provide access to their values using subscript syntax
         4️⃣ Classes and structs have initializers to create instances with initial values.
         5️⃣ Conforming to protocols are also in common. Some protocols may be class only so only classes can conform to that protocol, otherwise both can conform it.
         6️⃣ Finally, they can be extended to expand their functionality beyond a default implementation.
         ❗️ An instance of a class is traditionally known as an object. However, Swift structures and classes are much closer in functionality than in other languages.


     🔴 Differences
         - Classes are reference types, meaning they are passed by reference when assigned to a variable or constant.
            → A value type is a type whose value is copied when it’s assigned to a variable or constant, or when it’s passed to a function.
            → Unlike value types, reference types are not copied when they are assigned to a variable or constant, or when they are passed to a function. Rather than a copy, a reference to the same existing instance is used.
         - Classes can have a deinitializer, which is code that gets executed when an instance of the class is deallocated from memory.
         - Classes can use inheritance, allowing them to inherit properties and methods from a superclass.
         - Classes can be marked as final, which means they cannot be subclassed.
         - Type casting enables you to check and interpret the type of a class instance at runtime.
         - Reference counting allows more than one reference to a class instance

         - Structures are value types, meaning they are passed by value when assigned to a variable or constant.
         - Structures cannot have a deinitializer.
         - Structures cannot use inheritance, but can conform to protocols.
         - Structures do not need to be marked as final because they cannot be subclassed.


    🔴 Choosing Between Structures and Classes
         - Decide how to store data and model behavior.
         - Structures and classes are good choices for storing data and modeling behavior in your apps, but their similarities can make it difficult to choose one over the other.
         ❗️ Use structures by default.
         ❗️ Use classes when you need Objective-C interoperability.
         ❗️ Use classes when you need to control the identity of the data you’re modeling.
         ❗️ Use classes when you need reference semantics, inheritance, or a complex data model.


    🔴 Structures
         - Use structures to represent common kinds of data.
         - Structures in Swift include many features that are limited to classes in other languages: They can include stored properties, computed properties, and methods.
         - Moreover, Swift structures can adopt protocols to gain behavior through default implementations.
         - The Swift standard library and Foundation use structures for types you use frequently, such as numbers, strings, arrays, and dictionaries.
         - Do not support inheritance. They cannot inherit properties or behaviors from other structs.
         - Automatically receive a memberwise initializer that initializes all their properties.
         - Don’t rely on ARC for memory management, since they are copied when assigned or passed around.
         - May involve more overhead due to reference counting and potential heap allocation.

         🍏 Using structures makes it easier to reason about a portion of your code without needing to consider the whole state of your app.
         - Because structures are value types—unlike classes—local changes to a structure aren’t visible to the rest of your app unless you intentionally communicate those changes as part of the flow of your app.
         - As a result, you can look at a section of code and be more confident that changes to instances in that section will be made explicitly, rather than being made invisibly from a tangentially related function call.
 */


/*
     🔴 How Automatic Reference Counting Works?
        - ARC (Automatic Reference Counting) to track and manage your app’s memory usage. ARC automatically frees up the memory used by class instances when those instances are no longer needed.
        - Every time creating a new class instance, ARC allocates a chunk of memory to store information about that instance and when it’s no longer needed, ARC frees up the memory used by that instance so that the memory can be used for other purposes instead.
        - Every instance of a class has a property called reference count so if reference count is greater than 0, the instance is still kept in memory otherwise, it will be removed from the memory.
 
         → In most cases, this means that memory management “just works” in Swift, and you don’t need to think about memory management yourself.
         → ARC automatically frees up the memory used by class instances when those instances are no longer needed.
     ⚠️ However, in a few cases ARC requires more information about the relationships between parts of your code in order to manage memory for you.
 */


/*
    🔴 How ARC Works
        → Every time you create a new instance of a class, ARC allocates a chunk of memory to store information about that instance.
        → This memory holds information about the type of the instance, together with the values of any stored properties associated with that instance.
        → Additionally, when an instance is no longer needed, ARC frees up the memory used by that instance so that the memory can be used for other purposes instead.
        → This ensures that class instances don’t take up space in memory when they’re no longer needed.
        → However, if ARC were to deallocate an instance that was still in use, it would no longer be possible to access that instance’s properties, or call that instance’s methods.
        → Indeed, if you tried to access the instance, your app would most likely crash.
        → To make sure that instances don’t disappear while they’re still needed, ARC tracks how many properties, constants, and variables are currently referring to each class instance.
        → ARC will not deallocate an instance as long as at least one active reference to that instance still exists.
    ⭕️ To make this possible, whenever you assign a class instance to a property, constant, or variable, that property, constant, or variable makes "a strong reference" to the instance.
        → The reference is called a “strong” reference because it keeps a firm hold on that instance, and doesn’t allow it to be deallocated for as long as that strong reference remains.
 */


/*
    🔴 ARC in Action
        → an example of how Automatic Reference Counting works.
        → This example starts with a simple class called Person, which defines a stored constant property called name:

             class Person {
                 let name: String
                 init(name: String) {
                     self.name = name
                     print("\(name) is being initialized")
                 }
                 deinit {
                     print("\(name) is being deinitialized")
                 }
             }

        ❗️ The next code snippet defines three variables of type Person?, which are used to set up multiple references to a new Person instance.
        → Because these variables are of an optional type (Person?, not Person), they’re automatically initialized with a value of nil, and don’t currently reference a Person instance.

             var reference1: Person?
             var reference2: Person?
             var reference3: Person?

        → You can now create a new Person instance and assign it to one of these three variables:
        ❗️ Because the new Person instance has been assigned to the reference1 variable, there’s now a strong reference from reference1 to the new Person instance.
        ❗️ Because there’s at least one strong reference, ARC makes sure that this Person is kept in memory and isn’t deallocated.

            reference1 = Person(name: "John Appleseed")

        → If you assign the same Person instance to two more variables, two more strong references to that instance are established:

            reference2 = reference1
            reference3 = reference1

        → There are now three strong references to this single Person instance.
        → If you break two of these strong references (including the original reference) by assigning nil to two of the variables, a single strong reference remains, and the Person instance isn’t deallocated:

            reference1 = nil
            reference2 = nil

        ❗️ ARC doesn’t deallocate the Person instance until the third and final strong reference is broken, at which point it’s clear that you are no longer using the Person instance:

            reference3 = nil
 */

/*
 
     https://github.com/enesozmus/SwiftfulThinkingContinuedLearning/blob/main/SwiftfulThinkingContinuedLearning/AutomaticReferenceCountingBootcamp.swift
     https://github.com/enesozmus/SwiftfulThinkingContinuedLearning/blob/main/SwiftfulThinkingContinuedLearning/StrongReferenceCyclesBootcamp.swift
     https://github.com/enesozmus/SwiftfulThinkingContinuedLearning/blob/main/SwiftfulThinkingContinuedLearning/WeakReferencesBootcamp.swift
 */

/*
 
 Links:
     https://blog.onewayfirst.com/ios/posts/2019-03-19-class-vs-struct/
     https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language
     https://medium.com/@vinayakkini/swift-basics-struct-vs-class-31b44ade28ae
     https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language/59219141#59219141
     https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding
     https://stackoverflow.com/questions/24232799/why-choose-struct-over-class/24232845
     https://www.backblaze.com/blog/whats-the-diff-programs-processes-and-threads/
     https://medium.com/doyeona/automatic-reference-counting-in-swift-arc-weak-strong-unowned-925f802c1b99
 
 VALUE TYPES:
 - Struct, Enum, String, Int, etc.
 - Stored in the Stack
 - Faster
 - Thread safe!
 - When you assign or pass value type a new copy of data is created
 
 REFERENCE TYPES:
 - Class, Function, Actor
 - Stored in the Heap
 - Slower, but synchronized
 - NOT Thread safe (by default)
 - When you assign or pass reference type a new reference to original instance will be created (pointer)
 
 - - - - - - - - - - - - - -
 
 STACK:
 - Stores Value types
 - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast
 - Each thread has it's own stack!
 
 HEAP:
 - Stores Reference types
 - Shared across threads!
 
 - - - - - - - - - - - - - -
 
STRUCT:
 - Based on VALUES
 - Can be mutated
 - Stored in the Stack!
 
CLASS:
 - Based on REFERENCES (INSTANCES)
 - Stored in the Heap!
 - Inherit from other classes
 
ACTOR:
 - Same as Class, but thread safe!
 
 - - - - - - - - - - - - - -
 
Structs: Data Models, Views
Classes: ViewModels
Actors: Shared 'Manager' and 'Data Stores'

 */

/*
     - When you assign an instance of a value type to a variable, a copy isn’t created in the first place. Rather, compiler optimizes by pointing it to the same instance. A new copy is created only when you mutate the variable. This compiler optimization is known as lazy copy or copy on write.

     - Value type instances are safe in a multi-threaded environment as multiple threads can mutate the instance without having to worry about the race conditions or deadlocks.

     - Value types have no references unlike reference types. Hence there is no overhead of memory leaks in value types.

     - Structs are preferable if they are relatively small and copiable because copying is way safer than having multiple references to the same instance as happens with classes.

     - ❗️ Use a reference type when you want to create shared, mutable state.

     Both class and structure can do:
         - Define properties to store values
         - Define methods to provide functionality
         - Be extended
         - Conform to protocols
         - Define initializers
         - Define Subscripts to provide access to their variables

     The only class can do:
         - Inheritance
         - Typecasting
         - Define deinitialisers
         - Allow reference counting for multiple references.

     ❤️ In this context, we’ll talk about your computer having two types of memory: volatile and nonvolatile. Volatile memory is temporary and processes in real time. It’s faster, easily accessible, and increases the efficiency of your computer. However, it’s not permanent. When your computer turns off, this type of memory resets.

     ❤️ Nonvolatile memory, on the other hand, is permanent unless deleted. While it’s slower to access, it can store more information. So, that makes it a better place to store programs.

     ❤️ Your executing program needs resources from the OS and memory to run. Without these resources, you can’t use the program. Fortunately, your OS manages the work of allocating resources to your programs automatically. Whether you use Microsoft Windows, macOS, Linux, Android, or something else, your OS is always hard at work directing your computer’s resources needed to turn your program into a running process.

     ❤️ What Is a Computer Process?
         - When a program is loaded into memory along with all the resources it needs to operate, it is called a process.
         - Having independent processes matters for users because it means one process won’t corrupt or wreak havoc on other processes. If a single process has a problem, you can close that program and keep using your computer. Practically, that means you can end a malfunctioning program and keep working with minimal disruptions.

     ❤️ What Are Threads?
         - The final piece of the puzzle is threads. A thread is the unit of execution within a process.
         - When a process starts, it receives an assignment of memory and other computing resources.
         - Each thread in the process shares that memory and resources. With single-threaded processes, the process contains one thread.
         - In multi-threaded processes, the process contains more than one thread, and the process is accomplishing a number of things at the same time (to be more accurate, we should say “virtually” the same time).
         - Earlier, we talked about the stack and the heap, the two kinds of memory available to a thread or process. Distinguishing between these kinds of memory matters because each thread will have its own stack. However, all the threads in a process will share the heap.

     🔴 Here’s what happens when you open an application on your computer.

         1️⃣ The program starts out as a text file of programming code.
         2️⃣ The program is compiled or interpreted into binary form.
         3️⃣ The program is loaded into memory.
         4️⃣ The program becomes one or more running processes. Processes are typically independent of one another.
         5️⃣ Threads exist as the subset of a process.
         6️⃣ Threads can communicate with each other more easily than processes can.
         7️⃣ Threads are more vulnerable to problems caused by other threads in the same process.

     🔴 Process vs. Threads
         Independent programs with their own memory space.
         Higher overhead due to separate memory space.
         Processes are isolated from each other.
         Each process has its own set of system resources.
         Processes are more independent of each other.
         A failure in one process does not directly affect others.
         Less need from the sychronization, as processes are isolated.
         Running multiple independent applications.
         Typically consumes more memory.
         ---
         Lightweight, smaller units of a process, share memory.
         Lower overhead as they share the same memory space.
         Threads share the same memory space.
         Threads share resources within the same process.
         Threads are dependent on each other within a process.
         A failure in one thread can affect others in the same process.
         Requires careful synchronization due to shared resources.
         Multithreading within a single application for parallelism.
         Consumes less memory compared to processes.
 
 ❗️A question you might ask is whether processes or threads can run at the same time. The answer is: it depends. In environments with multiple processors or CPU cores, simultaneous execution of multiple processes or threads is feasible.
 */

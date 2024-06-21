//
//  ErrorHandling1.swift
//  SwiftConcurrency
//
//  Created by enesozmus on 21.06.2024.
//

import SwiftUI

struct Item {
    var price: Int
    var count: Int
}
enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

class VendingMachine: ObservableObject {
    
    @Published var coinsDeposited = 0
    
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    
    // 🟢 The VendingMachine class has a vend(itemNamed:) method that throws an appropriate VendingMachineError if the requested item isn’t available, is out of stock, or has a cost that exceeds the current deposited amount:
    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        
        
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        print("Dispensing \(name)")
    }
}
struct ErrorHandling1: View {
    
    @StateObject var vm: VendingMachine = VendingMachine()
    
    var body: some View {
        Text("Click me and run the function by changing the number of coinsDeposited...")
            .foregroundStyle(.white)
            .frame(width: 300, height: 300)
            .background(.black)
            .onTapGesture {
                do {
                    try vm.vend(itemNamed: "Chips")
                } catch {
                    print(error)
                }
            }
    }
}

#Preview {
    ErrorHandling1()
}

/*
    🔴 Error Handling
        - Some operations aren’t guaranteed to always complete execution or produce a useful output.
        - Optionals are used to represent the absence of a value, but when an operation fails, it’s often useful to understand what caused the failure, so that your code can respond accordingly.
        - Error handling is the process of responding to and recovering from error conditions in your program.
        - Swift provides first-class support for throwing, catching, propagating, and manipulating recoverable errors at runtime.

        - As an example, consider the task of reading and processing data from a file on disk.
        - There are a number of ways this task can fail, including the file not existing at the specified path, the file not having read permissions, or the file not being encoded in a compatible format.
        - Distinguishing among these different situations allows a program to resolve some errors and to communicate to the user any errors it can’t resolve.
 
    🔴 Representing and Throwing Errors
        - In Swift, errors are represented by values of types that conform to the Error protocol.
        - This empty protocol indicates that a type can be used for error handling.
        - Swift enumerations are particularly well suited to modeling a group of related error conditions, with associated values allowing for additional information about the nature of an error to be communicated.
        - For example, here’s how you might represent the error conditions of operating a vending machine inside a game:

            enum VendingMachineError: Error {
             case invalidSelection
             case insufficientFunds(coinsNeeded: Int)
             case outOfStock
            }
 
    🔴 Throw
        - Throwing an error lets you indicate that something unexpected happened and the normal flow of execution can’t continue.
        - You use a throw statement to throw an error.
        - For example, the following code throws an error to indicate that five additional coins are needed by the vending machine:

            throw VendingMachineError.insufficientFunds(coinsNeeded: 5)
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
            throw VendingMachineError.invalidSelection
 
    🔴 Try
        - When a function throws an error, it changes the flow of your program, so it’s important that you can quickly identify places in your code that can throw errors.
        - To identify these places in your code, write the try keyword before a piece of code that calls a function, method, or initializer that can throw an error.
         variations
            1️⃣ try
            2️⃣ try?
            3️⃣ try!
 
    🔴 Handling Errors
        - When an error is thrown, some surrounding piece of code must be responsible for handling the error — for example, by correcting the problem, trying an alternative approach, or informing the user of the failure.
 
        - There are four ways to handle errors in Swift.
            1️⃣ You can propagate the error from a function to the code that calls that function,
            2️⃣ handle the error using a do-catch statement,
            3️⃣ handle the error as an optional value,
            4️⃣ or assert that the error will not occur.
 
    🔴 Propagating Errors Using Throwing Functions
        - To indicate that a function, method, or initializer can throw an error, you write the throws keyword in the function’s declaration after its parameters.
        - A function marked with throws is called a throwing function.
        - A throwing function propagates errors that are thrown inside of it to the scope from which it’s called.
        - If the function specifies a return type, you write the throws keyword before the return arrow (->).

            func canThrowErrors() throws -> String
            func cannotThrowErrors() -> String
 
    🟢 Example
        - In the example below, the VendingMachine class has a vend(itemNamed:) method that throws an appropriate VendingMachineError if the requested item isn’t available, is out of stock, or has a cost that exceeds the current deposited amount:
        - The implementation of the vend(itemNamed:) method uses guard statements to exit the method early and throw appropriate errors if any of the requirements for purchasing a snack aren’t met.
        - Because a throw statement immediately transfers program control, an item will be vended only if all of these requirements are met.
 
            func vend(itemNamed name: String) throws {
 
                 guard let item = inventory[name] else {
                     throw VendingMachineError.invalidSelection
                 }
             
                 guard item.count > 0 else {
                     throw VendingMachineError.outOfStock
                 }
             
                 guard item.price <= coinsDeposited else {
                     throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
                 }
             
             
                coinsDeposited -= item.price
             
            
                 var newItem = item
                 newItem.count -= 1
                 inventory[name] = newItem
                 
                 
                 print("Dispensing \(name)")
            }
 
    ❗️Because the vend(itemNamed:) method propagates any errors it throws, any code that calls this method must either handle the errors or continue to propagate them.
 
         1️⃣ using a do-catch statement,
         2️⃣ using try?
         3️⃣ using try!
         4️⃣ or continue to propagate them
 
    - For example, the buyFavoriteSnack(person:vendingMachine:) in the example below is also a throwing function, and any errors that the vend(itemNamed:) method throws will propagate up to the point where the buyFavoriteSnack(person:vendingMachine:) function is called.
    - In this example, the buyFavoriteSnack(person: vendingMachine:) function looks up a given person’s favorite snack and tries to buy it for them by calling the vend(itemNamed:) method.
    - Because the vend(itemNamed:) method can throw an error, it’s called with the try keyword in front of it.

         let favoriteSnacks = [
             "Alice": "Chips",
             "Bob": "Licorice",
             "Eve": "Pretzels",
         ]
         func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
             let snackName = favoriteSnacks[person] ?? "Candy Bar"
             try vendingMachine.vend(itemNamed: snackName)
         }
 
 🔴 Handling Errors Using Do-Catch
    - You use a do-catch statement to handle errors by running a block of code.
    - If an error is thrown by the code in the do clause, it’s matched against the catch clauses to determine which one of them can handle the error.

         do {
             try <#expression#>
             <#statements#>
         } catch <#pattern 1#> {
             <#statements#>
         } catch <#pattern 2#> where <#condition#> {
             <#statements#>
         } catch <#pattern 3#>, <#pattern 4#> where <#condition#> {
             <#statements#>
         } catch {
             <#statements#>
         }

    🟢
    - If an error is thrown, execution immediately transfers to the catch clauses, which decide whether to allow propagation to continue.
    - If no pattern is matched, the error gets caught by the final catch clause and is bound to a local error constant.
    - If no error is thrown, the remaining statements in the do statement are executed.
        var vendingMachine = VendingMachine()
        vendingMachine.coinsDeposited = 8
 
         do {
            ❗️The buyFavoriteSnack(person:vendingMachine:) function is called in a try expression, because it can throw an error.
             try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
             print("Success! Yum.")
         } catch VendingMachineError.invalidSelection {
             print("Invalid Selection.")
         } catch VendingMachineError.outOfStock {
             print("Out of Stock.")
         } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
             print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
         } catch {
             print("Unexpected error: \(error).")
         }
 */

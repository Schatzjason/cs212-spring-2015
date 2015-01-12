import UIKit

// The generateArray function randomly creates an array of Int optionals
// The following questions ask you to perform different calculations based
// on random arrays created by the function. Each time you run the playground
// you should get different results. You can force the playground to run again
// using the Editor --> Execute Playground menu item. 

func generateArray() -> [Int?] {
    let size = Int(arc4random() % 20)
    var array = [Int?]()
    var value: Int?
    
    for i in 0...size {
        value = -10 + Int(arc4random() % 110)
        array.append(value >= 0 ? value : nil)
    }
    
    return array
}

// Question 1: Counting nils
//
// Write code that counts the number of nil values in array1

let array1 = generateArray()

// Question 2: Mean
//
// Write code that calcuates the mean value of the non nil elements in array1.
// You do not necessarily need to write functions. You can start your code
// directly under the declaration of array2

let array2 = generateArray()

// Question 3: New Array
//
// Write code that creates a new array named nilFree that has the same elements
// as array3, except without the nil values. The elements in nilFree should be
// Ints, not Int optionals

let array3 = generateArray()


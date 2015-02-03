// Playground - noun: a place where people can play

import UIKit

/**
    This is a possible implementation of a model class for your calculator
    Feel free to use it, or to write completely different code.
*/

enum CalculatorOperator {
    case Plus, Minus, Equals, Clear
}

class Calculator : Printable {

    private var leftOperand: Int?
    private var rightOperand: Int?
    private var theOperator: CalculatorOperator?
    private var displayText: String = "0"
    
    func digitButtonPressed(digit: Int) {
        
        if theOperator != nil {
            // do something
        } else {
            // do something else
        }
    }
    
    func operatorButtonPressed(theOperator: CalculatorOperator) {

        switch(theOperator) {
        case .Plus, .Minus:
            self.theOperator = theOperator
        //case .Clear:
            // Your code here
        //case .Equals:
            // Your code here
        default:
            return
        }
    }
    
    var description: String {
        return displayText
    }
}

// A sample test of the calculator class. 2 + 3 = 5

let calculator = Calculator()

calculator.digitButtonPressed(2)
calculator.description

calculator.operatorButtonPressed(.Plus)
calculator.description

calculator.digitButtonPressed(3)
calculator.description

calculator.operatorButtonPressed(.Equals)
calculator.description


//
//  main.swift
//  DomainModeling
//
//  Created by Susan Wolfgram on 10/15/15.
//  Copyright © 2015 Susan Wolfgram. All rights reserved.
//

import Foundation

struct Money {
    var amount : Double
    var currency : String
    
    mutating func convert(cur2 : String) -> Double {
        let am = self.amount
        if (self.currency == "USD") {
            switch cur2 {
                case "GBP":
                    self.amount = am / 2
                case "EUR":
                    self.amount = am * 1.5
                case "CAN":
                    self.amount = am * 1.25
                default:
                    self.amount = am
            }
        } else if (self.currency == "GBP") {
            switch cur2 {
                case "USD":
                    self.amount = am * 2
                case "EUR":
                    self.amount = am * 3
                case "CAN":
                    self.amount = am * 2.5
                default:
                    self.amount = am
            }
        } else if (self.currency == "EUR") {
            switch cur2 {
                case "USD":
                    self.amount = am / 1.5
                case "GBP":
                    self.amount = am / 3
                case "CAN":
                    self.amount = am / 1.2
                default:
                    self.amount = am
            }
        } else {
            switch cur2 {
                case "USD":
                    self.amount = am / 1.25
                case "GBP":
                    self.amount = am / 2.5
                case "EUR":
                    self.amount = am * 1.2
                default:
                    self.amount = am
            }
        }
        return self.amount
    }
    
    mutating func addSubtract(var am2 : Money, op : String) -> Double {
        if (op == "+") {
            return self.amount + am2.convert(self.currency)
        } else {
            return self.amount - am2.convert(self.currency)
        }
    }
}

class Job {
    var title : String
    var salary : Double
    var salType : String
    
    init(title : String, salary : Double, salType : String) {
        self.title = title
        self.salary = salary
        self.salType = salType
    }
    
    func calculateIncome(hours : Double) -> Double {
        let am = self.salary
        if (self.salType == "per-hour") {
            return am * hours
        } else {
            return am
        }
    }
    
    func raise(perc : Double) -> Void {
        salary = salary + salary * (perc / 100.0)
    }
}

class Person {
    var firstName : String
    var lastName : String
    var age : Int
    var job : Job?
    var spouse : Person?
    
    init(firstName : String, lastName : String, age : Int, job : Job?, spouse : Person?) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = job
        self.spouse = spouse
    }
    
    func toString() -> String {
        return self.firstName + " " + self.lastName
    }
}

class Family {
    var members : [Person]
    var legal : String
    
    init(members : [Person], legal : String) {
        self.members = members
        self.legal = legal
    }
    
    func householdIncome() -> Double {
        var total = 0.0
        for member in members {
            if (member.job != nil && member.job!.salType == "per-hour") {
                total += member.job!.salary * 2000
            } else if (member.job != nil && member.job!.salType == "per-year") {
                total += member.job!.salary
            }
        }
        return total
    }
    
    func haveChild(fName : String, lName : String) -> Void {
        let child = Person(firstName: fName, lastName: lName, age: 0, job : nil, spouse : nil)
        members.append(child)
    }
    
    func legalOrNot() -> String {
        if (self.legal == "illegal") {
            for member in members {
                if (member.age >= 21) {
                    self.legal = "legal"
                }
            }
        }
        return self.legal
    }
}


print("Tests:")
print("")
var money1 = Money(amount: 10, currency: "USD")
var money2 = Money(amount: 3, currency: "EUR")
var money3 = Money(amount: 5, currency: "CAN")
var money4 = Money(amount: 2, currency: "GBP")
var am4 = money1.addSubtract(money2, op : "+")
print("10 USD + 3 EUR = \(am4) \(money1.currency)")
print("")
var am3 = money3.addSubtract(money2, op: "-")
print("5 CAN - 3 EUR = \(am3) \(money3.currency)")
print("")
var am2 = money4.addSubtract(money3, op: "+")
print("2 GBP + 5 CAN = \(am2) \(money4.currency)")
print("")
var am1 = money1.addSubtract(money4, op: "-")
print("10 USD - 2 GBP = \(am1) \(money1.currency)")
print("")
var am = money2.addSubtract(money4, op: "+")
print("3 EUR + 2 GBP = \(am) \(money2.currency)")
print("")
var job1 = Job(title: "Salesman", salary: 15, salType: "per-hour")
print("job1 is \(job1.title) $\(job1.salary) \(job1.salType)")
job1.raise(10)
print("job1 got a 10% raise and is now $\(job1.salary)")
var job2 = Job(title: "Secretary", salary: 20000, salType: "per-year")
var jim = Person(firstName: "Jim", lastName: "Halpert", age: 32, job: job1, spouse: nil)
var pam = Person(firstName: "Pam", lastName: "Halpert", age: 30, job: job2, spouse: jim)
jim.spouse = pam
var halpertFam = Family(members: [jim, pam], legal: "legal")
print("\(jim.toString()) is a \(jim.job!.title).")
print("If Jim works 300 hours, his calculated income will be $\(jim.job!.calculateIncome(300)).")
print("Jim is married to \(jim.spouse!.toString()) who is a \(jim.spouse!.job!.title).")
halpertFam.haveChild("Cece", lName: "Halpert")
print("Jim and Pam had a child! The Halpert Family is now made up of \(halpertFam.members[0].toString()), \(halpertFam.members[1].toString()), and \(halpertFam.members[2].toString()).")
print("The Halpert family's yearly income is $\(halpertFam.householdIncome())")
print("\(halpertFam.members[0].toString()) is \(halpertFam.members[0].age).")
print("Since at least one member of the Halpert family is over 21, their family is considered \(halpertFam.legalOrNot()).")




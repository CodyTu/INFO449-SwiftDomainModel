struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    func convert(_ arg: String) -> Money {
        //    1 USD = .5 GBP / 2 USD = 1 GBP
        //
        //    1 USD = 1.5 EUR / 2 USD = 3 EUR
        //
        //    1 USD = 1.25 CAN / 4 USD = 5 CAN
        
        let currentCurr = self.currency
        var USDAmount = 0
        // Convert to standardize currency (USD)
        switch currentCurr {
        case "GBP":
            USDAmount = Int(Double(self.amount) * 0.5)
        case "EUR":
            USDAmount = Int(Double(self.amount) * 1.5)
        case "CAN":
            USDAmount = Int(Double(self.amount) * 1.25)
        default:
            USDAmount = self.amount
        }
        
        // Convert standardized(USD) to inputted currency
        switch arg {
        case "GBP":
            return Money(amount: (USDAmount * 2), currency: arg)
        case "EUR":
            return Money(amount: (USDAmount * (2/3)), currency: arg)
        case "CAN":
            return Money(amount: (USDAmount * (4/5)), currency: arg)
        case "USD":
            return Money(amount: USDAmount, currency: arg)
        default:
            print("Not a valid currency")
            return Money(amount: 0, currency: "Not a valid currency")
        }
    }
    
    func add(_ arg: Money) -> Money {
//        let currAmount = Money(self.amount - arg.convert(self.currency).amount, self.currency)
//        let converted = currAmount.convert(arg.currency)
        return Money(amount: self.convert(arg.currency).amount + arg.amount, currency: arg.currency)
    }
    
    func subtract(_ arg: Money) -> Money {
        return Money(amount: self.convert(arg.currency).amount - arg.amount, currency: arg.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    var title: String
    var type: JobType
    
    func calculateIncome() {
        
    }
    
    func raise() {
        
    }
}

////////////////////////////////////
// Person
//
public class Person {
}

////////////////////////////////////
// Family
//
public class Family {
}

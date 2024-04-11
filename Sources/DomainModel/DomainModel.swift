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
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ arg: Int) -> Int {
        switch self.type {
        case .Hourly(let value):
            return Int(value) * arg
        case .Salary(let value):
            return Int(value)
        }
    }
    
    func raise(byAmount: Int) -> Job {
        switch self.type {
        case .Hourly(let value):
            return Job(title: self.title, type: Job.JobType.Hourly(value + Double(byAmount)))
        case .Salary(let value):
            return Job(title: self.title, type: Job.JobType.Salary(value + UInt(byAmount)))
        }
    }
    
    func raise(byAmount: Double) -> Job {
        switch self.type {
        case .Hourly(let value):
            return Job(title: self.title, type: Job.JobType.Hourly(value + byAmount))
        case .Salary(let value):
            return Job(title: self.title, type: Job.JobType.Salary(value + UInt(byAmount)))
        }
    }
    
    func raise(byPercent: Double) -> Job {
        switch self.type {
        case .Hourly(let value):
            return Job(title: self.title, type: Job.JobType.Hourly(value + (value * byPercent)))
        case .Salary(let value):
            return Job(title: self.title, type: Job.JobType.Salary(value + (value * UInt(byPercent))))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet{
            if age < 18 {
                job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if age < 18 {
                spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String{
        return"[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job != nil ? "\(job!)" : "nil") spouse:\(spouse != nil ? "\(spouse!)" : "nil")]"
    }
    
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    
    init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members = [spouse1, spouse2]
        } else {
            members = []
        }
    }
    
    func haveChild(_ child: Person) -> Bool {
        for i in 0...members.count {
            if members[i].spouse != nil {
                if members[i].age > 21 {
                    members.append(child)
                    return true
                }
            }
        }
        return false
    }
    
    func householdIncome() -> Int{
        var totalIncome = 0
        for i in 0...members.count {
            totalIncome += members[i].job!.calculateIncome(2000)
        }
        return totalIncome
    }
}

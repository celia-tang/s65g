//: Playground - noun: a place where people can play


func isLeap(year: Int) -> Bool {
    return  year % 400 == 0 ? true : year % 100 == 0 ? false : year % 4 == 0 ? true : false
}

let mDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
let mLDays = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

func julianDate(year: Int, month: Int, day: Int) -> Int {
    
    let yearDays = (1900..<year).map { $0 }.reduce(0, combine: {$0 + (isLeap($1) ? 366 : 365)})
    let monthDays = isLeap(year) ? mLDays[0..<month-1].reduce(0, combine: +) : mDays[0..<month-1].reduce(0, combine: +)
    
    return yearDays + day + monthDays
    
}


julianDate(1960, month:  9, day: 28)
julianDate(1900, month:  1, day: 1)
julianDate(1900, month: 12, day: 31)
julianDate(1901, month: 1, day: 1)
julianDate(1901, month: 1, day: 1) - julianDate(1900, month: 1, day: 1)
julianDate(2001, month: 1, day: 1) - julianDate(2000, month: 1, day: 1)

isLeap(1960)
isLeap(1900)
isLeap(2000)

julianDate(1901, month: 1, day: 1)


var a = ["hello", "uo", "jiji", "asdasd"]
a.contains("hello")

a[0..<a.count-1]
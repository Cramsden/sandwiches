import Foundation

extension Date {
    static func daysFromNow(_ number: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: number, to: Date())!
    }
}

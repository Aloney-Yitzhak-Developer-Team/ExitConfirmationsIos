import Foundation

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter
}()

let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
}()

let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy HH:mm"
    return formatter
}()

extension Date {
    func getDateString() -> String {
        return dateFormatter.string(from: self)
    }

    func getTimeString() -> String {
        return timeFormatter.string(from: self)
    }

    func toSimpleString() -> String {
        return formatter.string(from: self)
    }
}

extension String {
    func toDate() -> Date? {
        return formatter.date(from: self)
    }
}

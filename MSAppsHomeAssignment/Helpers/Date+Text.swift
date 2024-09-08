// Abstract: helper to get the current date and time as formatted text.

import Foundation

extension Date {
    var dayAndTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        
        if Locale.current.calendar.isDateInToday(self) {
            let timeFormat = String("Today at %@")
            return String(format: timeFormat, timeText)
        } else {
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = String("%@ at %@")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
}

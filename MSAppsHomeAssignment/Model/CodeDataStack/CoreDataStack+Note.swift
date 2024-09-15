// Abstract: methods for handling notes

import CoreData
import MapKit

extension CoreDataStack {
    
    private var unknownLocationString: String {
        NSLocalizedString("Unknown location", comment: "Description for unknown location")
    }
    
    /// Saves `Note` entity with passed text and location.
    func createNote(withText body: String, at coordinates: CLLocationCoordinate2D, locationName: String, date: Date) throws {
        let context = viewContext
        
        let location = NoteLocation(context: context)
        location.latitude = coordinates.latitude
        location.longitude = coordinates.longitude
        location.displayName = locationName
        
        let note = Note(context: context)
        note.body = body
        note.dateModified = date
        note.location = location
        
        location.note = note
        
        do {
            try context.save()
            print("Saved note: \(body.prefix(10)), last modified \(date.dayAndTimeText).")
        } catch {
            throw CoreDataError(kind: .noteSave, note: note)
        }
    }
}

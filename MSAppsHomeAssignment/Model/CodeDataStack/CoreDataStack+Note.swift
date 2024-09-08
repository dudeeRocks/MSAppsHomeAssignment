// Abstract: methods for handling notes

import CoreData
import MapKit

extension CoreDataStack {
    
    /// Saves `Note` entity with passed text and location.
    func saveNote(withText body: String, at location: CLLocationCoordinate2D) throws {
        let context = persistentContainer.viewContext
        
        let noteLocation = NoteLocation(context: context)
        noteLocation.latitude = location.latitude
        noteLocation.longitude = location.longitude
        
        let note = Note(context: context)
        note.body = body
        note.dateModified = Date.now
        note.location = noteLocation
        
        noteLocation.note = note
        
        do {
            try context.save()
            print("Saved note: \(note.body?.prefix(10)), last modified \(note.dateModified?.dayAndTimeText).")
        } catch {
            throw CoreDataError(kind: .noteSave, note: note)
        }
    }
}

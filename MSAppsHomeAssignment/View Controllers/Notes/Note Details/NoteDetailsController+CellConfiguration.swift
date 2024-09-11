// Abstract: methods that handle cell configuration for Note Details collection view.

import UIKit
import MapKit

extension NoteDetailsController {
    
    /// Used for view mode.
    func viewConfiguration(cell: UICollectionViewListCell, at row: Row) {
        var content = cell.defaultContentConfiguration()
        content.text = getTextForViewing(row)
        cell.contentConfiguration = content
    }
    
    func headerConfiguration(cell: UICollectionViewListCell, at indexPath: IndexPath, title: String) {
        var content = cell.defaultContentConfiguration()
        
        /// This number is used to determine content of the header.
        /// It's derived from the `indexPath.section` number, and on `isEditing` adjusted by the number of extra sections in edit mode.
        let adjustedSectionNumber = isEditing ? indexPath.section + 2 : indexPath.section
        
        switch adjustedSectionNumber {
        case Section.viewNote.rawValue, Section.viewLocation.rawValue, Section.map.rawValue, Section.delete.rawValue:
            content.text = nil
        default:
            content.text = title
        }
        
        cell.contentConfiguration = content
    }
    
    func textViewConfiguration(cell: UICollectionViewListCell) {
        var content = cell.textViewConfiguration()
        content.text = isNewNote ? nil : note.body
        content.onChange = { [weak self] text in
            guard let self = self else { return }
            newNoteText = text
            if text.isEmpty {
                saveButton.isEnabled = false
            } else {
                saveButton.isEnabled = true
            }
        }
        cell.contentConfiguration = content
    }
    
    func locationTextFieldConfiguration(cell: UICollectionViewListCell) {
        var content = cell.locationSearchFieldConfiguration()
        content.text = isNewNote ? nil : note.location!.displayName
        content.coordinate = isNewNote ? CLLocationCoordinate2D(latitude: 0, longitude: 0) : note.coordinate
        content.onChange = { [weak self] response, error in
            guard let self = self else { return }
            guard let response = response, error == nil else {
                Log.main.log(error: "Failed location search. Error: \(error?.localizedDescription)")
                
                if let searchError = error as? MKError {
                    switch searchError.code {
                    case .decodingFailed:
                        print("decoding failed")
                    case .placemarkNotFound:
                        print("placemarkNotFound")
                    case .serverFailure:
                        print("serverFailure")
                    default:
                        print("unknown error")
                    }
                }
                return // TODO: Show alert here
            }
            
            let mapItems = response.mapItems.prefix(5)
            var locationSearchResultsRows: [Row] = []
            
            for item in mapItems {
                let row = Row.editLocationResult(item)
                locationSearchResultsRows.append(row)
            }
            
            updateUI(for: .edit, animated: true, locationResults: locationSearchResultsRows)
        }
        cell.contentConfiguration = content
    }
    
    func dateConfiguration(cell: UICollectionViewListCell) {
        var content = cell.defaultContentConfiguration()
        if isNewNote {
            content.secondaryText = NSLocalizedString("Created: \(Date.now.dayAndTimeText)", comment: "Date created title.")
        } else {
            content.secondaryText = NSLocalizedString("Last edited: \(note.dateModified!.dayAndTimeText)", comment: "Date modified title.")
        }
        content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = content
    }
    
    func mapConfiguration(cell: UICollectionViewListCell) {
        var content = cell.mapConfiguration()
        if isNewNote {
            content.location = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        } else {
            content.location = CLLocationCoordinate2D(latitude: note.location!.latitude, longitude: note.location!.longitude)
        }
        cell.contentConfiguration = content
    }
    
    func deleteButtonConfiguration(cell: UICollectionViewListCell) {
        var content = cell.deleteButtonConfiguration()
        content.text = NSLocalizedString("Delete note", comment: "Delete button on edit note.")
        content.onTap = deleteNote
        cell.contentConfiguration = content
    }
    
    private func getTextForViewing(_ row: Row) -> String? {
        switch row {
        case .viewNote:
            return note.body
        case .viewLocation:
            return note.location?.displayName
        default:
            return nil
        }
    }
}

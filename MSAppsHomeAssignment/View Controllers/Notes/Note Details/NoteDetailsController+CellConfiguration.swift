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
    
    // MARK: - Header Configuration
    
    func headerConfiguration(cell: UICollectionViewListCell, at indexPath: IndexPath, title: String) {
        var content = cell.defaultContentConfiguration()
        
        /// This number is used to determine content of the header.
        /// It's derived from the `indexPath.section` number, and on `isEditing` adjusted by the number of extra sections in edit mode.
        let adjustedSectionNumber = isEditing ? indexPath.section + 2 : indexPath.section
        
        switch adjustedSectionNumber {
        case Section.viewNote.rawValue, Section.viewLocation.rawValue, Section.locationResults.rawValue, Section.map.rawValue, Section.delete.rawValue:
            content.text = nil
        default:
            content.text = title
        }
        
        cell.contentConfiguration = content
    }
    
    // MARK: - Text View Configuration
    /// Configuration for note text input,
    func textViewConfiguration(cell: UICollectionViewListCell) {
        var content = cell.textViewConfiguration()
        content.text = isNewNote ? nil : note.body
        content.onChange = { [weak self] text in
            guard let self = self else { return }
            newNoteText = text
            updateSaveButton()
        }
        cell.contentConfiguration = content
    }
    
    // MARK: - Location Search Field Configuration
    
    func locationTextFieldConfiguration(cell: UICollectionViewListCell) {
        var content = cell.locationSearchFieldConfiguration()
        content.text = isNewNote ? nil : note.location!.displayName
        content.onResultsUpdate = { [weak self] results in
            guard let self = self else { return }
            let cappedResults = results.prefix(5)
            var searchResultsRows: [Row] = []
            for result in cappedResults {
                let newRow = Row.editLocationResult(result)
                searchResultsRows.append(newRow)
            }
            updateUI(for: .searchResults(searchResultsRows))
        }
        cell.contentConfiguration = content
    }
    
    // MARK: - Location Auto-complete Configuration
    
    func locationSearchResultConfiguration(cell: UICollectionViewListCell, searchCompletion: MKLocalSearchCompletion) {
        var content = cell.defaultContentConfiguration()
        content.attributedText = createHighlightedString(text: searchCompletion.title, rangeValues: searchCompletion.titleHighlightRanges)
        content.secondaryAttributedText = createHighlightedString(text: searchCompletion.subtitle, rangeValues: searchCompletion.subtitleHighlightRanges)
        cell.contentConfiguration = content
    }
    
    // MARK: - Date Configuration
    
    func dateConfiguration(cell: UICollectionViewListCell) {
        var content = cell.defaultContentConfiguration()
        if isNewNote {
            content.secondaryText = "Created: \(Date.now.dayAndTimeText)"
        } else {
            content.secondaryText = "Last edited: \(note.dateModified!.dayAndTimeText)"
        }
        content.secondaryTextProperties.color = .secondaryLabel
        cell.contentConfiguration = content
    }
    
    // MARK: - Map Configuration
    
    func mapConfiguration(cell: UICollectionViewListCell) {
        var content = cell.mapConfiguration()
        content.location = note?.location
        content.onLocationUpdate = { coordinate, locationName in
            self.newLocation = coordinate
            self.newLocationName = locationName
        }
        cell.contentConfiguration = content
    }
    
    // MARK: - Delete Button Configuration
    
    func deleteButtonConfiguration(cell: UICollectionViewListCell) {
        var content = cell.deleteButtonConfiguration()
        content.text = "Delete note"
        content.onTap = deleteNote
        cell.contentConfiguration = content
    }
    
    // MARK: - Helpers
    
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
    
    private func createHighlightedString(text: String, rangeValues: [NSValue]) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.backgroundColor: UIColor.systemYellow ]
        let highlightedString = NSMutableAttributedString(string: text)


        // Each `NSValue` wraps an `NSRange` that functions as a style attribute's range with `NSAttributedString`.
        let ranges = rangeValues.map { $0.rangeValue }
        ranges.forEach { (range) in
            highlightedString.addAttributes(attributes, range: range)
        }


        return highlightedString
    }
}

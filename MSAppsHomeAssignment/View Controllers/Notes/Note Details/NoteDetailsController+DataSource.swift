// Abstract: methods for configuring diffable data source and snapshots for note details view

import UIKit
import MapKit

extension NoteDetailsController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    enum UpdateCase { case view, edit }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    func configureCollectionViewLayout() {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        collectionView.collectionViewLayout = listLayout
    }
    
    func updateUI(for updateCase: UpdateCase, animated: Bool = true, locationResults: [Row]? = nil) {
        updateNavigationBar(for: updateCase)
        switch updateCase {
        case .view:
            isEditing = false
            updateSnapshotForViewing(animated: animated)
        case .edit:
            isEditing = true
            updateSnapshotForEditing(animated: animated)
        }
    }
    
    private func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        switch row {
        case .header(let title):
            headerConfiguration(cell: cell, at: indexPath, title: title)
        case .map:
            if isNewNote {
                mapConfiguration(cell: cell, location: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
            } else {
                mapConfiguration(cell: cell, location: CLLocationCoordinate2D(latitude: note.location!.latitude, longitude: note.location!.longitude))
            }
        default:
            defaultConfiguration(cell: cell, at: row)
        }
    }
    
    private func updateSnapshotForViewing(animated: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.viewNote, .viewLocation])
        snapshot.appendItems([
            .header(Section.viewNote.title),
            .date,
            .note
        ], toSection: .viewNote)
        snapshot.appendItems([
            .header(Section.viewLocation.title),
            .location,
            .map
        ], toSection: .viewLocation)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func updateSnapshotForEditing(animated: Bool = true, locationResults: [Row]? = nil) {
        var snapshot = Snapshot()
        snapshot.appendSections([.editNote, .editLocation, .map, .delete])
        snapshot.appendItems([
            .header(Section.editNote.title),
            .editNote(note?.body)
        ], toSection: .editNote)
        snapshot.appendItems([
            .header(Section.editLocation.title),
            .locationSearchField("120 Derech nam|"),
        ], toSection: .editLocation)
        if let locationResults = locationResults {
            snapshot.appendItems(locationResults, toSection: .editLocation)
        }
        snapshot.appendItems([
            .header(Section.map.title),
            .map
        ], toSection: .map)
        snapshot.appendItems([
            .header(Section.delete.title),
            .deleteButton
        ], toSection: .delete)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

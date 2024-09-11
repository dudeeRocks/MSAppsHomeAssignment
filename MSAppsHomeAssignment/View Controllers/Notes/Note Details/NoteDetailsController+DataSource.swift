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
        listConfiguration.showsSeparators = true
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
            updateSnapshotForEditing(animated: animated, locationResults: locationResults)
        }
    }
    
    private func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        switch row {
        case .header(let title):
            headerConfiguration(cell: cell, at: indexPath, title: title)
        case .date:
            dateConfiguration(cell: cell)
        case .editNote:
            textViewConfiguration(cell: cell)
        case .editLocation:
            locationTextFieldConfiguration(cell: cell)
        case .editLocationResult(let searchResult):
            locationSearchResultConfiguration(cell: cell, searchCompletion: searchResult)
        case .map:
            mapConfiguration(cell: cell)
        case .deleteButton:
            deleteButtonConfiguration(cell: cell)
        default:
            viewConfiguration(cell: cell, at: row)
        }
    }
    
    private func updateSnapshotForViewing(animated: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.viewNote, .viewLocation])
        snapshot.appendItems([
            .header(Section.viewNote.title),
            .date,
            .viewNote
        ], toSection: .viewNote)
        snapshot.appendItems([
            .header(Section.viewLocation.title),
            .viewLocation,
            .map
        ], toSection: .viewLocation)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    private func updateSnapshotForEditing(animated: Bool = true, locationResults: [Row]? = nil) {
        var snapshot = Snapshot()
        snapshot.appendSections([.editNote, .editLocation, .map])
        snapshot.appendItems([
            .header(Section.editNote.title),
            .editNote
        ], toSection: .editNote)
        snapshot.appendItems([
            .header(Section.editLocation.title),
            .editLocation,
        ], toSection: .editLocation)
        
        if let locationResults = locationResults {
            snapshot.appendItems(locationResults, toSection: .editLocation)
        }
        
        snapshot.appendItems([
            .header(Section.map.title),
            .map
        ], toSection: .map)
        
        if !isNewNote {
            snapshot.appendSections([.delete])
            snapshot.appendItems([
                .header(Section.delete.title),
                .deleteButton
            ], toSection: .delete)
        }

        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

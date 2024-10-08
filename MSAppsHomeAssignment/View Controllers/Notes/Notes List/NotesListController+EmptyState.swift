// Abstract: extension for displaying empty state on empty notes list.

import UIKit

extension NotesListController {
    func setUpEmptyStateView() {
        emptyStateView = UIView(frame: view.bounds)
        emptyStateView.backgroundColor = .systemBackground
        
        let title = UILabel()
        title.text = "No Notes Yet"
        title.font = .preferredFont(forTextStyle: .largeTitle)
        title.textAlignment = .center
        
        let subtitle = UILabel()
        subtitle.text = "This is where your notes will appear."
        subtitle.font = .preferredFont(forTextStyle: .body)
        subtitle.textAlignment = .center
        subtitle.textColor = .secondaryLabel
        subtitle.numberOfLines = 0
        
        let button = UIButton(configuration: .borderedProminent())
        button.setTitle("Create Note", for: .normal)
        button.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .small)), for: .normal)
        button.configuration?.imagePadding = 10
        button.configuration?.buttonSize = .large
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [title, subtitle, button])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        emptyStateView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -20)
        ])
        
    }
    
    func checkIfNotesExist() {
        if notes.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
    
    func showEmptyState() {
        UIView.transition(with: emptyStateView, duration: 0.3) {
            self.tableView.backgroundView = self.emptyStateView
        }
    }
    
    private func hideEmptyState() {
        UIView.transition(with: emptyStateView, duration: 0.3) {
            self.tableView.backgroundView = nil
        }
    }
}

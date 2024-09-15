// Abstract: Note details error handling

import UIKit

extension NoteDetailsController {
    
    func showAlert(for error: Error) {
        var title: String = "Error"
        var message: String = error.localizedDescription
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}

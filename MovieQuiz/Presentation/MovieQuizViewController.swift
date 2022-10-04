import UIKit

final class MovieQuizViewController: UIViewController {
    @IBAction func yesButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction private func noButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var questionLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

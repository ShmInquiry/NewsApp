import UIKit

class NewsDetailsViewController: UIViewController {
    
    private let article: Article
    // Add UI components to display news details
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
        // Initialize UI components and populate with news details
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure UI components and layout
    }
}
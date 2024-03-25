import UIKit

class NewsDetailsViewController: UIViewController {
    
    private let article: Article
    // Add UI components to display news details
    
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
        // Initialize UI components and populate with news details
        view.backgroundColor = .white
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure UI components and layout
        
        let title = UILabel(frame: CGRect(origin: CGPoint(x: 10,y: 145), size: CGSize(width: 370, height: 270)))
        title.numberOfLines = 175
        title.font = .systemFont(ofSize: 30, weight: .semibold)
        
        title.textColor = .black
        title.text = article.title
//        label.textAlignment =
        
        view.addSubview(title)
        
        let subtitle = UILabel(frame: CGRect(origin: CGPoint(x: 20,y: 195), size: CGSize(width: 350, height: 470)))
        subtitle.numberOfLines = 175
        subtitle.font = .systemFont(ofSize: 20, weight: .light)
        
        subtitle.textColor = .black
        subtitle.text = article.description
//        label.textAlignment =
        
        view.addSubview(subtitle)
        
        
        
        newsImageView.frame = CGRect(origin: CGPoint(x: 20,y: 120), size: CGSize(width: 200, height: 200))
        
        view.addSubview(newsImageView)
        configure()
    }
    
    func configure() {
        //image
        if let url = URL(string: article.urlToImage ?? "") {
            // fetch the image
            URLSession.shared.dataTask(with: url) { [weak self]
                data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
}

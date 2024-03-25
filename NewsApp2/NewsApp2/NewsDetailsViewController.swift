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
        
        let title = UILabel(frame: CGRect(origin: CGPoint(x: 10,y: 360), size: CGSize(width: 370, height: 270)))
        title.numberOfLines = 175
        title.font = .systemFont(ofSize: 30, weight: .semibold)
        
        title.textColor = .black
        title.text = article.title
//        title.textAlignment = AnchorPoint()
                
        
        let description = UILabel(frame: CGRect(origin: CGPoint(x: 20,y: 450), size: CGSize(width: 350, height: 470)))
        description.numberOfLines = 5000
        description.font = .systemFont(ofSize: 20, weight: .light)
        description.textColor = .black
        description.text = article.content
//        label.textAlignment =
        
        let publishedDate = UILabel(frame: CGRect(origin: CGPoint(x: 20,y: 550), size: CGSize(width: 350, height: 470)))
        publishedDate.font = .systemFont(ofSize: 20, weight: .light)
        publishedDate.textColor = .black
        publishedDate.text = article.publishedAt
        
        let Author = UILabel(frame: CGRect(origin: CGPoint(x: 50,y: 360), size: CGSize(width: 350, height: 470)))
        Author.font = .systemFont(ofSize: 20, weight: .light)
        Author.textColor = .black
        Author.text = article.author
        
        let LinkUrl = UILabel(frame: CGRect(origin: CGPoint(x: 20,y: 440), size: CGSize(width: 350, height: 880)))
        LinkUrl.font = .systemFont(ofSize: 20, weight: .light)
        LinkUrl.textColor = .blue
//        LinkUrl.toggleUnderline(Any?.self)
        LinkUrl.text = article.url
        
        newsImageView.frame = CGRect(origin: CGPoint(x: 0,y: 80), size: CGSize(width: 428, height: 325))
        
        view.addSubview(newsImageView)
        configure()
        
        view.addSubview(title)
        
        view.addSubview(publishedDate)
        view.addSubview(Author)
        
        view.addSubview(description)
        
        view.addSubview(LinkUrl)


        
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
        imageView.contentScaleFactor = .leastNormalMagnitude
        return imageView
    }()
}

import UIKit

final class NewsCell: UITableViewCell {
    
    private let newsImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // Чтобы не путать картинки при переиспользовании
    private var currentURL: URL?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)

        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let padding: CGFloat = 8
        let imageSide: CGFloat = 60
        
        newsImageView.frame = CGRect(
            x: padding,
            y: padding,
            width: imageSide,
            height: imageSide
        )
        
        let textX = newsImageView.frame.maxX + padding
        let textWidth = contentView.bounds.width - textX - padding
        
        titleLabel.frame = CGRect(
            x: textX,
            y: padding,
            width: textWidth,
            height: 20
        )
        descriptionLabel.frame = CGRect(
            x: textX,
            y: titleLabel.frame.maxY + 4,
            width: textWidth,
            height: 35
        )
    }
    
    func configure(with article: ArticleModel?) {
        titleLabel.text = article?.title ?? "No title"
        descriptionLabel.text = article?.announce ?? "No description"
        
        if let url = article?.img?.url {
            loadImage(from: url)
        } else {
            newsImageView.image = nil
        }
    }
    
    private func loadImage(from url: URL) {
        currentURL = url
        newsImageView.image = nil
        
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                if self?.currentURL == url {
                    self?.newsImageView.image = image
                }
            }
        }
    }
}

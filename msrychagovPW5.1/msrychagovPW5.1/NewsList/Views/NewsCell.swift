import UIKit

final class NewsCell: UITableViewCell {
    
    // MARK: - Subviews
    private let newsImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Internal State
    private var currentURL: URL?
    
    // MARK: - UIConstants
    private enum UIConstants {
        // Отступы
        static let padding: Double = 8
        static let descriptionTopOffset: Double = 4
        
        // Размер картинки
        static let imageSide: Double = 60
        
        // Шрифт (можем вынести и имя шрифта, если нужно)
        static let titleFontSize: CGFloat = 16
        static let descriptionFontSize: CGFloat = 14
        
        // Количество строк
        static let titleNumberOfLines: Int = 2
        static let descriptionNumberOfLines: Int = 3
        
        static let placeholderTitle: String = "No title"
        static let placeholderDescription: String = "No description"
        
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraintsWithPin()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Subviews
    private func setupViews() {
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: UIConstants.titleFontSize)
        titleLabel.numberOfLines = UIConstants.titleNumberOfLines
        
        descriptionLabel.font = UIFont.systemFont(ofSize: UIConstants.descriptionFontSize)
        descriptionLabel.numberOfLines = UIConstants.descriptionNumberOfLines
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    // MARK: - Constraints via Pin
    private func setupConstraintsWithPin() {
        newsImageView.pinLeft(to: contentView, UIConstants.padding)
        newsImageView.pinTop(to: contentView, UIConstants.padding)
        newsImageView.setWidth(mode: .equal, UIConstants.imageSide)
        newsImageView.setHeight(mode: .equal, UIConstants.imageSide)
        
        // Заголовок
        titleLabel.pinLeft(to: newsImageView.trailingAnchor, UIConstants.padding)
        titleLabel.pinTop(to: contentView, UIConstants.padding)
        titleLabel.pinRight(to: contentView, UIConstants.padding)
        
        // Описание
        descriptionLabel.pinLeft(to: titleLabel.leadingAnchor)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, UIConstants.descriptionTopOffset)
        descriptionLabel.pinRight(to: titleLabel.trailingAnchor)
        descriptionLabel.pinBottom(to: contentView, UIConstants.padding)
    }
    
    // MARK: - Configure
    func configure(with article: ArticleModel?) {
        titleLabel.text = article?.title ?? UIConstants.placeholderTitle
        descriptionLabel.text = article?.announce ?? UIConstants.placeholderDescription
        
        newsImageView.image = nil
        
        if let url = article?.img?.url {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        currentURL = url
        
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

import UIKit

final class NewsListViewController: UIViewController, NewsListViewInput {
    
    var output: NewsListViewOutput?
    
    // MARK: - UIConstants
    private enum UIConstants {
        // Числовые константы
        static let estimatedRowHeight: CGFloat = 120
        
        // Идентификаторы
        static let cellIdentifier = "NewsCell"
        
        // Тексты
        static let navBarTitle = "News"
        static let shareActionTitle = "Share"
        static let errorAlertTitle = "Ошибка"
        static let errorAlertButton = "ОК"
        
        // Цвета
        static let shareActionColor: UIColor = .systemBlue
    }
    
    // MARK: - TableView
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(NewsCell.self, forCellReuseIdentifier: UIConstants.cellIdentifier)
        tv.dataSource = self
        tv.delegate = self
        
        // Устанавливаем оценочную высоту и автоматическую высоту строк
        tv.estimatedRowHeight = UIConstants.estimatedRowHeight
        tv.rowHeight = UITableView.automaticDimension
        
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = UIConstants.navBarTitle
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        output?.viewDidLoad()
    }

    // MARK: - NewsListViewInput
    func reloadData() {
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(
            title: UIConstants.errorAlertTitle,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: UIConstants.errorAlertButton, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output?.numberOfArticles() ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UIConstants.cellIdentifier,
            for: indexPath
        ) as? NewsCell else {
            return UITableViewCell()
        }
        
        let article = output?.article(at: indexPath.row)
        cell.configure(with: article)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        output?.didTapCell(at: indexPath.row)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let shareAction = UIContextualAction(
            style: .normal,
            title: UIConstants.shareActionTitle
        ) { [weak self] _, _, completion in
            self?.output?.didSwipeShare(at: indexPath.row) { url in
                guard let url = url else {
                    completion(false)
                    return
                }
                let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                self?.present(activityVC, animated: true)
                completion(true)
            }
        }
        
        shareAction.backgroundColor = UIConstants.shareActionColor
        
        return UISwipeActionsConfiguration(actions: [shareAction])
    }
}

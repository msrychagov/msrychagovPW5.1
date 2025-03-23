import UIKit

// MARK: View
protocol NewsListViewInput: AnyObject {
    func reloadData()
    func showError(_ message: String)
}

protocol NewsListViewOutput: AnyObject {
    func viewDidLoad()
    func didTapCell(at index: Int)
    func didSwipeShare(at index: Int, completion: @escaping (URL?) -> Void)
    func numberOfArticles() -> Int
    func article(at index: Int) -> ArticleModel?
}

// MARK: Interactor
protocol NewsListBusinessLogic: AnyObject {
    func loadArticles()
}

protocol NewsListInteractorOutput: AnyObject {
    func didLoadArticles(_ articles: [ArticleModel])
    func didFailLoading(with error: Error)
}

// MARK: Router
protocol NewsListRouterLogic: AnyObject {
    func openDetailScreen(url: URL)
}

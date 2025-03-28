import UIKit

final class NewsListRouter: NewsListRouterLogic {
    
    weak var viewController: UIViewController?

    static func build() -> UIViewController {
        let view = NewsListViewController()
        let interactor = NewsListInteractor()
        let presenter = NewsListPresenter()
        let router = NewsListRouter()
        
        view.output = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func openDetailScreen(url: URL) {
        let detailVC = ArticleDetailRouter.build(url: url)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}

import UIKit

final class ArticleDetailRouter {
    
    static func build(url: URL) -> UIViewController {
        let view = ArticleDetailViewController()
        let interactor = ArticleDetailInteractor()
        let presenter = ArticleDetailPresenter(articleURL: url)
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
}

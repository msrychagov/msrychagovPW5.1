import Foundation

protocol ArticleDetailBusinessLogic: AnyObject {
    func fetchSomethingIfNeeded()
}

protocol ArticleDetailInteractorOutput: AnyObject {
}

protocol ArticleDetailPresentationLogic: AnyObject {
    func viewDidLoad()
}

protocol ArticleDetailViewLogic: AnyObject {
    func loadWebPage(_ url: URL)
}

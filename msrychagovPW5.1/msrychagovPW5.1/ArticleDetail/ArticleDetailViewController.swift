import UIKit
import WebKit

final class ArticleDetailViewController: UIViewController, ArticleDetailViewLogic {
    
    var presenter: ArticleDetailPresentationLogic?
    
    private var webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        webView.frame = view.bounds
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        
        presenter?.viewDidLoad()
    }
    
    func loadWebPage(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

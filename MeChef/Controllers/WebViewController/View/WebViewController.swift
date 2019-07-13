import UIKit
import LeadKit
import WebKit

protocol WebViewControllerDelegate: class {
    func successWith(authCode: String)
    func errorWith(description: String?)
}

final class WebViewController: UIViewController {

    var viewModel: WebViewModel!
    weak var delegate: WebViewControllerDelegate?

    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        webConfiguration.allowsInlineMediaPlayback = false
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.isOpaque = false
        webView.navigationDelegate = self
        return webView
    }()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()

        webView.load(URLRequest(url: viewModel.url))
        view.addSubview(webView)
        webView.setToCenter()
    }

    override func configureNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        title = viewModel.pageTitle
    }

}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        let redirectUrl = webView.url?.absoluteString ?? ""
        if let questionRange = redirectUrl.range(of: "?") {
            let requestUrl = String(redirectUrl[..<questionRange.lowerBound])
            switch requestUrl {
            case StripeService.chefConnectionUrl:
                webView.stopLoading()
                if let codeRange = redirectUrl.range(of: "code=") {
                    let authCode = String(redirectUrl[codeRange.upperBound...])
                    completedWithSuccess(authCode: authCode)
                } else {
                    if let errorRange = redirectUrl.range(of: "error_description=") {
                        let errorDescription = String(redirectUrl[errorRange.upperBound...])
                        completedWithError(description: errorDescription)
                    } else {
                        completedWithError()
                    }
                }
            default:
                break
            }
        }
    }

    func completedWithSuccess(authCode: String) {
        delegate?.successWith(authCode: authCode)
        NavigationService.popNavigationTopController()
    }

    func completedWithError(description: String? = nil) {
        delegate?.errorWith(description: description)
        NavigationService.popNavigationTopController()
    }

}

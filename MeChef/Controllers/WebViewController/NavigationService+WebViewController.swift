import UIKit

extension NavigationService {

    static func webViewController(pageTitle: String, url: URL) -> WebViewController {
        let controller = WebViewController(nibName: WebViewController.xibName,
                                           bundle: nil)
        let viewModel = WebViewModel(pageTitle: pageTitle, url: url)

        controller.viewModel = viewModel
        return controller
    }

}

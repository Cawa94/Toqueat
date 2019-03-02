import UIKit
import RxSwift

class FirstViewController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.

        NetworkService.shared.getAllChefs()
            .subscribe(onSuccess: { dishes in
                debugPrint(dishes.toJSONString(prettyPrint: true))
            })
            .disposed(by: disposeBag)
    }

}

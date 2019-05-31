import Foundation
import SwiftDate

struct DriverDeliveringViewModel {

    let stuartJob: StuartJob?
    let driverPhone: String?
    let isChef: Bool // if isChef, show extimated time to chef house

}

extension DriverDeliveringViewModel {

    var stuartDriver: StuartDriver? {
        return stuartJob?.driver
    }

    var driverEta: StuartEta? {
        return stuartJob?.deliveries.first?.eta
    }

    func attributedExtimatedTime() -> NSAttributedString {
        let driverName = stuartDriver?.displayName ?? "Stuart driver"
        let dateArrivalString = isChef ? driverEta?.pickup : driverEta?.dropoff
        if let deliveryDate = DateInRegion.init(dateArrivalString ?? "") {
            let time = fabs((deliveryDate - DateInRegion())).toString(options: {
                $0.allowedUnits = [.minute]
                $0.unitsStyle = .full
            })
            return NSMutableAttributedString()
                .bold(driverName, size: 15.0)
                .normal(" \(String.orderDetailsDriverEta()) ", size: 15.0)
                .bold(time, size: 15.0)
        } else {
            return NSMutableAttributedString()
                .bold(driverName, size: 15.0)
                .normal(" \(String.orderDetailsDriverEtaUndefined())", size: 15.0)
        }
    }

}

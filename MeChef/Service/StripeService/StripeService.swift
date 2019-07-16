import Stripe

struct StripeService {

    // Sandbox
    static let publicKey = "pk_test_27giqgLSvi80jxgWeGwEzg6Y000sjrXr9y"
    static let secretKey = "sk_test_BiHsepXoSf1E0uLZcpJvqiLX00PcxLHLyP"
    static let clientId = "ca_F1vuvYuSwP0KpRWrX8lHZiTEKUajjT5B"
    
    // Production
    // static let publicKey = "pk_live_9x4PyIKcOJhfgJ1ZJoU7R2rn00E8zySxnE"
    // static let secretKey = "sk_live_hibS1v9lEUuj627wF4A1rDJG00446K0NYe"
    // static let clientId = "ca_F1vuH5SPL4vCv7g4vwzBLG387Aui4e1U"
    
    static let apiVersion = "2019-03-14"

    // Check chef connection response
    static let chefConnectionUrl = "https://toqueat.com/chef-connected"

    static var ephemeralKey: String?
    static var customerContext: STPCustomerContext?

    static func setCustomerContext() {
        customerContext = STPCustomerContext(keyProvider: NetworkService.shared)
    }

}

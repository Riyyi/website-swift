public struct ToastState: Sendable {

    enum Level: String {
        case success = "success"
        case error = "danger"
        case warning = "warning"
        case info = "info"
        case verbose = "secondary"
    }

    var message: String = ""
    var title: String = ""
    var level: Level = Level.verbose

}

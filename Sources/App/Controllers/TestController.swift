import Elementary
import ElementaryHTMX
import ElementaryHTMXSSE
import ElementaryHTMXWS
import Fluent
import Vapor
import VaporElementary

struct TestController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        routes.group("test") { test in
			test.get("toast", use: toast)
        }
    }

    @Sendable
    func toast(req: Request) async throws -> HTMLResponse {

        let state = try getState(request: req)
        state.toast = ToastState(message: "Wow!",
                                 title: "This is my title",
                                 level: ToastState.Level.success)

        throw Abort(.badRequest, headers: ["HX-Trigger": "toast"])

        // return HTMLResponse { }
    }

}

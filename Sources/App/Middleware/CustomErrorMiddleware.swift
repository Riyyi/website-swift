import Vapor

// Modified from Vapor.ErrorMiddleware

public final class CustomErrorMiddleware: Middleware {
    // Default response
    public struct ErrorResponse: Codable {
        var error: Bool
        var reason: String
    }

    public init(environment: Environment) {
        self.environment = environment
        self.errorMiddleware = ErrorMiddleware.`default`(environment: environment)
    }

    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {

        // Let ErrorMiddleware handle API endpoint errors
        if let acceptHeader = request.headers.first(name: "Accept"),
            acceptHeader == "application/json" {
            return errorMiddleware.respond(to: request, chainingTo: next)
        }

        return next.respond(to: request).flatMapErrorThrowing { error in
            try self.makeResponse(with: request, reason: error)
        }
    }

    // -------------------------------------

    private func makeResponse(with req: Request, reason error: Error) throws -> Response {
        let reason: String
        let status: HTTPResponseStatus
        var headers: HTTPHeaders
        let source: ErrorSource

        // Inspect the error type and extract what data we can.
        switch error {
        case let debugAbort as (DebuggableError & AbortError):
            (reason, status, headers, source) = (debugAbort.reason, debugAbort.status, debugAbort.headers, debugAbort.source ?? .capture())

        case let abort as AbortError:
            (reason, status, headers, source) = (abort.reason, abort.status, abort.headers, .capture())

        case let debugErr as DebuggableError:
            (reason, status, headers, source) = (debugErr.reason, .internalServerError, [:], debugErr.source ?? .capture())

        default:
            // In debug mode, provide the error description; otherwise hide it to avoid sensitive data disclosure.
            reason = environment.isRelease ? "Something went wrong." : String(describing: error)
            (status, headers, source) = (.internalServerError, [:], .capture())
        }

        // Report the error
        req.logger.report(error: error, file: source.file, function: source.function, line: source.line)

        headers.contentType = .html

        let statusCode = String(status.code)
        var body = Response.Body()

        // Display error in toast message for HTMX requests
        if let isHTMXHeader = req.headers.first(name: "HX-Request"), isHTMXHeader == "true" {
            let state = try getState(request: req)
            // Only set a new toast if the endpoint hasnt already
            if state.toast.message.isEmpty {
                state.toast = ToastState(message: reason,
                                         title: "Error \(statusCode)",
                                         level: ToastState.Level.error)
            }
            headers.add(name: "HX-Trigger", value: "toast")
        }
        // Render error to a page
        else {
            body = Response.Body(string: MainLayout(title: "Error \(statusCode))") {
                ErrorPage(status: statusCode, reason: reason)
            }.render())
        }


        // Create a Response with appropriate status
        return Response(status: status, headers: headers, body: body)
    }

    private let environment: Environment
    private let errorMiddleware: ErrorMiddleware
}

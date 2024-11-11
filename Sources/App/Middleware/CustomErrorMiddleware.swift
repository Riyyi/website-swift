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
    }

    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        next.respond(to: request).flatMapErrorThrowing { error in
            self.makeResponse(with: request, reason: error)
        }
    }

    // -------------------------------------

    private func makeResponse(with req: Request, reason error: Error) -> Response {
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

        let body = makeResponseBody(with: req, reason: reason, status: status, headers: &headers)

        // Create a Response with appropriate status
        return Response(status: status, headers: headers, body: body)
    }

    private func makeResponseBody(with req: Request, reason: String, status: HTTPResponseStatus,
                                  headers: inout HTTPHeaders) -> Response.Body {
        let body: Response.Body

        if let acceptHeader = req.headers.first(name: "Accept"),
           acceptHeader == "application/json" {
            // Attempt to serialize the error to JSON
            do {
                let encoder = try ContentConfiguration.global.requireEncoder(for: .json)
                var byteBuffer = req.byteBufferAllocator.buffer(capacity: 0)
                try encoder.encode(ErrorResponse(error: true, reason: reason), to: &byteBuffer, headers: &headers)

                body = .init(
                  buffer: byteBuffer,
                  byteBufferAllocator: req.byteBufferAllocator
                )
            } catch {
                body = .init(string: "Oops: \(String(describing: error))\nWhile encoding error: \(reason)",
                             byteBufferAllocator: req.byteBufferAllocator)
                headers.contentType = .plainText
            }
        }
        else {
            // Attempt to render the error to a page
            let statusCode = String(status.code)
            body = .init(string: MainLayout(title: "Error \(statusCode))") {
                ErrorPage(status: statusCode, reason: reason)
            }.render())
            headers.contentType = .html
        }

        return body
    }

    private let environment: Environment
}

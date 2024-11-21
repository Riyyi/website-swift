import Vapor

public func getState(request: Request) throws -> UserState {
    guard let state =  request.storage[UserStateKey.self] else {
        throw Abort(.internalServerError)
    }

    return state
}

public final class StateMiddleware: AsyncMiddleware {
    public func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {

        // This code is run *before* the route endpoint code

        var setCookie: Bool = true

        let uuid: UUID
        if let sessionID = request.cookies["SWIFTSESSID"]?.string,
           let sessionUUID = UUID(uuidString: sessionID) {
            setCookie = false

            uuid = sessionUUID

            if !request.application.manager.states.keys.contains(uuid.uuidString) {
                request.application.manager.states[uuid.uuidString] = UserState()
            }
        } else {
            uuid = UUID()

            // Register a new user state into the application storage
            // https://docs.vapor.codes/advanced/services/
            request.application.manager.states[uuid.uuidString] = UserState()
        }

        // Provide the user state to the request
        request.storage[UserStateKey.self] = request.application.manager.states[uuid.uuidString]

        let response = try await next.respond(to: request)

        // This code is run *after* the route endpoint code

        if setCookie {
            response.cookies["SWIFTSESSID"] = HTTPCookies.Value(
              string: uuid.uuidString,
              path: "/",
              isSecure: true,
              isHTTPOnly: true
            )
        }

        return response
    }
}

import Vapor

// -----------------------------------------

public final class UserState: @unchecked Sendable {
	var toast: ToastState = ToastState()
    var todos: TodosState = TodosState()
}

// -----------------------------------------

struct UserStateKey: StorageKey {
    typealias Value = UserState
}

struct UserStateManager: Sendable {
	var states: [String: UserState] = [:]
}

struct UserStateManagerKey : StorageKey {
	typealias Value = UserStateManager
}

extension Application {
    var manager: UserStateManager {
        get {
            self.storage[UserStateManagerKey.self]!
        }
        set {
            self.storage[UserStateManagerKey.self] = newValue
        }
    }
}

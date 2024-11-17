import Fluent
import Vapor

struct TodoDTO: Content {
    var id: UUID?
    var title: String?

    func toModel() -> Todo {
        let model = Todo()

        model.id = self.id
        if let title = self.title {
            model.title = title
        }
        return model
    }
}

extension TodoDTO: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add(
            "title", as: String.self, is: !.empty, required: true,
            customFailureDescription: "Title is required")
    }
}

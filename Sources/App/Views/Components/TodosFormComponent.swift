import Elementary
import Fluent

struct TodosFormComponent: HTML {

    var name: String
    var target: String
    var errors: [String: String] = [:]

    // -------------------------------------

    var content: some HTML {
        div(.id("cdiv_" + name)) {
            form(
                .id("\(name)-form"),
                .hx.post("/\(target)"), .hx.target("#cdiv_" + name), .hx.swap(.outerHTML)
            ) {
                div(.class("row")) {
                    div(.class("col-11")) {
                        input(
                            .class("form-control"), .type(.text), .id("\(name)-title"),
                            .name("title"), .placeholder("Title"))  // .required
                    }
                    div(.class("col-1")) {
                        button(.class("btn btn-success"), .type(.submit)) { "Add" }
                    }
                }
                if let error = errors["title"] {
                    div(.class("form-text text-danger px-2")) { "\(error)." }
                }
            }
        }
    }

}

import Elementary
import ElementaryHTMX

// Usage:
//
// let state = try getState(request: req)
// state.toast = ToastState(message: "", title: "", level: ToastState.Level.error)
// throw Abort(.badRequest, headers: ["HX-Trigger": "toast"])
//
// The header "HX-Trigger" will make the part refresh and show the toast message

struct ToastComponent: HTML {

    var state: ToastState = ToastState()

    // -------------------------------------

    var content: some HTML {
        div(
            .class("toast-container"), .id("cdiv_toast"),
            .hx.get("/toast"),
            .hx.trigger(HTMLAttributeValue.HTMX.EventTrigger(rawValue: "toast from:body")),
            .hx.swap(.outerHTML)
        ) {
            div(.class("toast"), .id("toast")) {
                div(.class("toast-header bg-\(state.level.rawValue) text-white")) {
                    strong(.class("me-auto")) { state.title }
                    button(
                        .class("btn-close btn-close-white"), .type(.button),
                        .data("bs-dismiss", value: "toast")
                    ) {}
                }
                div(.class("toast-body")) { state.message }
            }
            if !state.message.isEmpty {
                ScriptAfterLoad(initial: false) {
                    """
                    const element = document.getElementById("toast");
                    const toast = new bootstrap.Toast(element, { autohide: true, delay: 5000 });
                    toast.show();

                    element.addEventListener("hidden.bs.toast", function () {
                        element.remove();
                    });
                    """
                }
            }
        }
    }

}

import Elementary

struct NavMenu: HTML {
    var content: some HTML {
        nav(.class("navbar navbar-expand-lg navbar-light bg-light fixed-top")) {
            div(.class("container-fluid")) {
                a(.class("navbar-brand"), .href("#")) { "Logo" }
                button(
                    .class("navbar-toggler"), .type(.button),
                    .data("bs-toggle", value: "collapse"),
                    .data("bs-target", value: "#navbarNav")
                ) {
                    span(.class("navbar-toggler-icon")) {}
                }
                div(.class("collapse navbar-collapse"), .id("navbarNav")) {
                    ul(.class("navbar-nav me-auto mb-2 mb-lg-0")) {
                        li(.class("nav-item")) {
                            a(.class("nav-link active"), .href("/")) { "Home" }
                        }
                        li(.class("nav-item")) {
                            a(.class("nav-link active"), .href("/todos")) { "Todos" }
                        }
                        li(.class("nav-item")) {
                            a(.class("nav-link"), .href("#")) { "About" }
                        }
                        li(.class("nav-item")) {
                            a(.class("nav-link"), .href("#")) { "Services" }
                        }
                        li(.class("nav-item")) {
                            a(.class("nav-link"), .href("#")) { "Contact" }
                        }
                    }
                }
            }
        }
    }
}

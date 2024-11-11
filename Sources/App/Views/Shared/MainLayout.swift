import Elementary

extension MainLayout: Sendable where Body: Sendable {}
struct MainLayout<Body: HTML>: HTMLDocument {
    var title: String
    @HTMLBuilder var pageContent: Body  // This var name can't be changed!

    // https://www.srihash.org/
    var head: some HTML {
        meta(.charset(.utf8))
        meta(.name(.viewport), .content("width=device-width, initial-scale=1.0"))

        // ---------------------------------
        // CSS includes

        link(
            .rel(.stylesheet),
            .href("https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css"),
            .integrity("sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"),
            .crossorigin(.anonymous))
        link(.rel(.stylesheet), .href("/style.css"))

        style {
            """
            body {
                padding-top: 56px;
            }
            """
        }
    }

    var body: some HTML {
        // ---------------------------------
        // Header

        header {
            NavMenu()
        }

        // ---------------------------------
        // Body

        main {
            div(.class("cotainer mt-4")) {
                div(.class("content px-4 pb-4")) {
                    pageContent
                }
            }
        }

        // ---------------------------------
        // JS includes

        script(
            .src(
                "https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"),
            .integrity("sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"),
            .crossorigin(.anonymous)
        ) {}
        script(.src("/js/site.js")) {}
    }

}

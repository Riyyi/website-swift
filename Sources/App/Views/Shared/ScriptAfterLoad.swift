import Elementary

struct ScriptAfterLoad: HTML {

    var initial: Bool = false
    var js: String = ""

    init(initial: Bool = false, js: () -> String) {
        self.initial = initial
        self.js = js()
    }

    // -------------------------------------

    var content: some HTML {
        if initial {
            script {
                """
                document.addEventListener("DOMContentLoaded", function() {
                    \(js)
                });
                """
            }
        } else {
            script {
                """
                web.afterLoad(function () {
                    \(js)
                });
                """
            }
        }
    }

}

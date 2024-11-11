import Elementary

struct IndexPage: HTML {
    var content: some HTML {
        h1 { "Welcome to Our Website" }
        p {
            "This is a basic Bootstrap page with a sticky navigation bar and content in the middle."
        }
        p { "The navigation bar will stay at the top of the page as you scroll down." }
        p {
            """
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam tincidunt arcu
            sit amet leo rutrum luctus. Sed metus mi, consectetur vitae dui at, sodales
            dignissim odio. Curabitur a nisi eros. Suspendisse semper ac justo non gravida.
            Vestibulum accumsan interdum varius. Morbi at diam luctus, mattis mi nec, mollis
            libero. Pellentesque habitant morbi tristique senectus et netus et malesuada
            fames ac turpis egestas. Integer congue, nisl in tempus ultricies, ligula est
            laoreet elit, sed elementum erat dui ac nisl. Aenean pulvinar arcu eget urna
            venenatis, at dictum arcu ultrices. Etiam hendrerit, purus vitae sagittis
            lobortis, nisi sapien vestibulum arcu, ut mattis arcu elit ut arcu. Nulla vitae
            sem ac eros ullamcorper efficitur ut id arcu. Vestibulum euismod arcu eget
            aliquet tempor. Nullam nec consequat magna. Etiam posuere, ipsum id condimentum
            mollis, massa libero efficitur lectus, nec tempor mauris tellus ut ligula.
            Quisque viverra diam velit, quis ultricies nisl lacinia vitae.

            Aliquam libero nibh, luctus vel augue at, congue feugiat risus. Mauris volutpat
            eget eros ac congue. Duis venenatis, arcu vel sodales accumsan, diam mi posuere
            mi, vitae rutrum ex mauris nec libero. Sed eleifend nulla magna, eu lobortis
            mauris fringilla nec. In posuere dignissim eros, ut hendrerit quam lacinia eu.
            Praesent vestibulum arcu enim, hendrerit convallis risus facilisis eu. Nunc
            vitae mauris eu nulla laoreet rhoncus. Nullam ligula tellus, vulputate in
            viverra nec, eleifend eu nulla. Praesent suscipit rutrum imperdiet.

            Curabitur in lacus eu diam cursus viverra non eget turpis. Donec a ornare ipsum,
            sed egestas orci. Vivamus congue gravida elementum. Pellentesque vitae mauris
            magna. Phasellus blandit urna vitae auctor consectetur. Aenean iaculis eget arcu
            vitae ultricies. Nunc maximus, massa hendrerit faucibus fringilla, eros quam
            consequat enim, sit amet sodales erat quam eget massa.

            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum in venenatis
            urna. Vestibulum lectus arcu, scelerisque in ipsum vitae, feugiat cursus tortor.
            Maecenas aliquam nunc enim, id fringilla est mattis et. Vivamus vitae
            ullamcorper erat. Sed quis vehicula felis, quis bibendum nunc. Duis semper
            fermentum ante, id fermentum neque varius convallis. Donec dui leo, fringilla
            nec massa nec, fermentum molestie purus. Donec eget feugiat velit. Nulla
            facilisi. Cras maximus felis eu libero mollis consectetur. Nulla molestie vitae
            neque venenatis porta.

            Vestibulum nunc diam, mattis eu bibendum at, sagittis vitae nunc. Duis lacinia
            sodales enim, et elementum libero posuere et. Donec ut fringilla orci. Donec at
            aliquet ipsum, quis mattis risus. Donec malesuada enim in egestas blandit. Proin
            sagittis mauris magna, elementum faucibus metus tempus eu. Sed in sem ut tellus
            porta luctus et sed diam. Donec felis ante, euismod a est vitae, mollis
            condimentum nulla.
            """
        }
    }
}

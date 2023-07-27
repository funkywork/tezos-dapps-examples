(lang dune 3.8)

(name tezos-dapps-examples)
(version dev)
(generate_opam_files true)
(source (github funkywork/tezos-dapps-examples ))
(license MIT)
(authors "Funkywork")
(maintainers "Funkywork")

(package
  (name tezos-dapps-examples)
  (description "A collection of sample of Tezos dApps")
  (synopsis "A collection of samples of Tezos dApps built on top of Nightmare and Yourbones")
  (depends
    ;; Global deps
    (ocaml (>= 5.0.0))
    (dune (>= 3.0.0))

    ;; Nightmare deps
    (nightmare :pinned)
    (nightmare-dream :pinned)
    (nightmare-tyxml :pinned)

    ;; Nightmare Js deps
    (nightmare_js :pinned)
    (nightmare_js-vdom :pinned)

    ;; Yourbones deps
    (yourbones :pinned)
    (yourbones-ppx :pinned)
    (uourbones_js :pinned)
    (yourbones_js-beacon :pinned)

    ;; Dev setup
    (ocamlformat :with-dev-setup)
    (ocp-indent :with-dev-setup)
    (merlin :with-dev-setup)
    (utop :with-dev-setup)))

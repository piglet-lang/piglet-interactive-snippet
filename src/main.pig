(module main
  "<piglet-interactive-snippet> web component: a text box + a 'RUN' button to
  insert bits of Piglet code into blog posts etc."
  (:import
    piglet:dom
    piglet:css))

(def styles
  [[":host" {:--pis-bg-color "#f2fbf0"
             :--pis-border-color "#d4d1b6"}]
   [:.input-section {:position "relative"}]
   [:textarea {:width "100%"
               :min-height "6em"
               :border "1px solid var(--pis-border-color)"
               :border-radius "2px"
               :background-color "var(--pis-bg-color)"
               :padding "0.75em"
               :box-sizing "border-box"}]
   [:button {:position "absolute"
             :bottom "0.75em"
             :right "0.5em"}]
   [:.result {:font-family "monospace"
              :background-color "var(--pis-bg-color)"
              :padding "1em"
              :box-sizing "border-box"}]])

(def element-ui
  [:<>
   [:div.input-section
    [:textarea]
    [:button "RUN"]]
   [:pre.result]
   [:style (css:css styles)]])

(js:customElements.define
  "piglet-interactive-snippet"

  (class :extends js:HTMLElement
    (constructor []
      (super))

    (connectedCallback []
      (let [code   (.-innerHTML this)
            shadow (.attachShadow this #js {:mode "open"})
            dom    (dom:dom element-ui)]
        (set! (.-onclick (dom:query-one dom :button)) (.bind this.run this))
        (set! (.-value (dom:query-one dom :textarea)) code)
        (dom:append shadow dom)
        (when (not= "false" (dom:attr this :autorun))
          (.run this))))

    :get
    (code []
      (.-value (dom:query-one this.shadowRoot :textarea)))
    :get
    (result []
      (.-innerHTML (dom:query-one this.shadowRoot :.result)))
    :set
    (result [s]
      (set! (.-innerHTML (dom:query-one this.shadowRoot :.result)) s))

    (log [s]
      (set! (.-result this) (str (.-result this) s "\n")))

    (^:async run []
      (set! (.-result this) "")
      (let [self this
            rdr (string-reader (:code this))
            on-result (fn [r]
                        (.log self (str "=> " (print-str r))))]
        (while (not (.eof rdr))
          (let [f (.read rdr)]
            (prn f)
            (.then (binding [*console* self] (eval f)) on-result)))))))

(comment
  (dom:append
    js:window.document.body
    (dom:dom
      [:<>
       [:piglet-interactive-snippet
        "(println "hello world")
(fqn #'str)
(fqn *current-module*)
(keys *current-module*)"]
       ])))

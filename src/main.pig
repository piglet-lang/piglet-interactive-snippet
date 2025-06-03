(module main
  "<piglet-interactive-snippet> web component: a text box + a 'RUN' button to
  insert bits of Piglet code into blog posts etc."
  (:import piglet:dom))

(js:customElements.define
  "piglet-interactive-snippet"

  (class :extends js:HTMLElement
    (constructor []
      (super))

    (connectedCallback []
      (let [txt (.-innerText this)
            shadow (.attachShadow this #js {:mode "open"})
            dom (dom:dom
                  [:<>
                   [:textarea txt]
                   [:button {:on-click (.bind this.run this)} "RUN"]
                   [:div.result]])
            [txt-el btn-el out-el] (dom:children dom)]
        (set! (.-textarea this) txt-el)
        (set! (.-out this) out-el)
        (dom:append shadow dom)
        (when (not= "false" (dom:attr this :autorun))
          (.run this))))

    (run []
      (let [{:keys [textarea out]} this]
        (.then
          (.eval_string *compiler* (.-value textarea))
          (fn [val]
            (set! (.-innerText out) (print-str val)))
          (fn [err]
            (set! (.-innerText out) (print-str err))))))))

(dom:append
  js:window.document.body
  (dom:dom
    [:<>
     [:piglet-interactive-snippet
      "(fqn #'str)"]
     [:piglet-interactive-snippet {:autorun false}
      "(+ 1 1)"]]))

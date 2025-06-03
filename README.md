# `<piglet-interactive-snippet>`

Web Component written in [piglet](https://github.com/piglet-lang/piglet). Turns
whatever piglet code you put inside the component into a textarea, allowing you
to edit and run the code.

By default runs the code immediately, unless you set the "autorun" attribute to
false.

```html
<piglet-interactive-snippet>
  (qname #'str)
</piglet-interactive-snippet>
```

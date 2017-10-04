HTMLWidgets.widget({

  name: 'kronawidget',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance
    console.log(123)
    console.log("init htmlwidget");
    console.log(el);

    return {

      renderValue: function(x) {
        console.log("rendering htmlwidget");

        el.innerHTML = x.content;
        console.log(el)
        // TODO: code to render the widget, e.g.

        load();

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});

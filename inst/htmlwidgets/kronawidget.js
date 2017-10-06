HTMLWidgets.widget({

  name: 'kronawidget',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {
        el.innerHTML = x.content; // insert data
        load(); // load the Krona logic

      },

      resize: function(width, height) {

      }

    };
  }
});

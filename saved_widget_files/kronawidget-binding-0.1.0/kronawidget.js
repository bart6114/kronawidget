HTMLWidgets.widget({

  name: 'kronawidget',

  type: 'output',

  factory: function(el, width, height) {
    var windowHeight = window.innerHeight;
    document.body.style.height = "600px";

    return {


      renderValue: function(x) {
        el.innerHTML = x.content; // insert data
        load('#kronaContainer'); // load the Krona logic

      },

      resize: function(width, height) {

      }

    };
  }
});

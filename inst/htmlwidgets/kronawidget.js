HTMLWidgets.widget({

  name: 'kronawidget',

  type: 'output',

  factory: function(el, width, height) {

    var generateID = (function() {
      var globalIdCounter = 0;
        return function(baseStr) {
          return(baseStr + globalIdCounter++);
      };
    })();

    console.log("factory", height);


    return {


      renderValue: function(x) {
        el.innerHTML = undefined;

        var img = document.createElement('img');
        img.setAttribute('id', 'hiddenImage');
        img.setAttribute('src', 'http://krona.sourceforge.net/img/hidden.png');
        img.setAttribute('style', 'display:none;');


        var containerDiv = document.createElement('div');
        var containerDivId = generateID('kronacontainer');
        containerDiv.setAttribute('id', containerDivId);

        el.innerHTML = x.content; // insert data
        el.getElementsByTagName('krona')[0].setAttribute('style', 'display:none;');

        el.appendChild(img);
        el.appendChild(containerDiv);

        // load the Krona logic
        initKrona('#' + containerDivId, x.offsetAdjuster);


      },

      resize: function(width, height) {

      },

      initialize: function(el, width, height) {

      }


    };
  }
});

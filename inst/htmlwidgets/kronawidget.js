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

        var img = document.createElement('img');
        img.setAttribute('id', 'hiddenImage');
        img.setAttribute('src', 'http://krona.sourceforge.net/img/hidden.png');
        img.setAttribute('style', 'display:none;');



        var containerDiv = document.createElement('div');
        var containerDivId = generateID();
        containerDiv.setAttribute('id', containerDivId);
        console.log(999, containerDivId);


        //el.parentElement.setAttribute("style", "height: "+ height + ";");
        console.log(1, width, height);
        el.innerHTML = x.content; // insert data
        el.getElementsByTagName('krona')[0].setAttribute('style', 'display:none;');

        el.appendChild(img);
        el.appendChild(containerDiv);

        load('#' + containerDivId); // load the Krona logic
        //el.getElementsByTagName('canvas')[0].setAttribute("style", "height: "+ "700px" + ";");


      },

      resize: function(width, height) {
        console.log(2, width, height);

      },

      initialize: function(el, width, height) {
        console.log(555, height);
}


    };
  }
});

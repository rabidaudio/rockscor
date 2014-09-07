

var temlates = {
    band_info: '
    <h3>{{name}}</h3>
    <p>{{location}}</p>
    <p>
    {{#list tags}}<a href="{{url}}">{{url}}</a>{{/list}}
    </p>',



}



Handlebars.registerHelper('list', function(items, options) {
  var out = "<ul>";

  for(var i=0, l=items.length; i<l; i++) {
    out = out + "<li>" + options.fn(items[i]) + "</li>";
  }

  return out + "</ul>";
});




$(document).ready(function(){
    var band_info = Handlebars.compile(temlates.band_info);

    $.ajax("/band_info"+window.location.search).done(function(data){
        console.log(data);
        //todo update ui wuth data
    });

});



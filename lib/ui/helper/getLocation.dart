


class MyLocation {

    static double _latitude=0.0;
   static double _longitude=0.0;




  static String getMyLocation(double latitude, double longitude,{double latitude1=0.0, double longitude1=0.0} ) {

    _latitude=latitude;
    _longitude=longitude;

  ;

    String _RotationLocation(double lat,  double long){
    return
      """{latLng: 
                 {lat:${lat},lng:${long}}
              },   
           """;
  }
  String  _Mylocation(double lat   ,double long){
    return """map = L.map('map', {
                    layers: MQ.mapLayer(),
                    center: [${lat},${long}],
                    zoom: 15
                });
                """;
  }



   String html_String1 = """
<html>
  <head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/leaflet.css" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/leaflet.js"></script>
        <script src="https://www.mapquestapi.com/sdk/leaflet/v2.2/mq-map.js?key=at1qo4SU7uQ2n8fj5DVQAvgIU9ZGYBV8"></script>
        <script src="https://www.mapquestapi.com/sdk/leaflet/v2.2/mq-routing.js?key=at1qo4SU7uQ2n8fj5DVQAvgIU9ZGYBV8"></script>
    <script type="text/javascript">
      window.onload = function() {
        
         var map,dir;
         
         
                 ${_Mylocation(latitude, longitude)}
                 
                 
                 dir = MQ.routing.directions();
                 dir.route({
                    locations: [
                         ${_RotationLocation(latitude, longitude)}
                         {
                          latLng: {lat: $latitude1 , lng:$longitude1}
                         },
                     
                                     
                    ],
                }); 
                map.addLayer(MQ.routing.routeLayer({
                    directions: dir,
                    fitBounds: true
                }));
                
              
   
      }
    </script>
  </head>

  <body style="border: 0; margin: 0;">
    <div id="map" style="width:100vw;height:100vh"></div>
  </body>
</html> 

  """
  ;

   String html_String2 = """
  <html>
  <head>
    <script src="https://api.mqcdn.com/sdk/mapquest-js/v1.3.2/mapquest.js"></script>
    <link type="text/css" rel="stylesheet" href="https://api.mqcdn.com/sdk/mapquest-js/v1.3.2/mapquest.css"/>
    <script type="text/javascript">
      window.onload = function() {
        L.mapquest.key = '4bPZ0xh9wTGej0BDXryvjvO6OgUcP8WA';
        var map = L.mapquest.map('map', {
          center: [${_latitude},${_longitude} ],
          layers: L.mapquest.tileLayer('map'),
          zoom: 12
        });
        var marker = L.marker([${_latitude},${_longitude} ]).addTo(map);
        
        map.addControl(L.mapquest.control());
      }
    </script>
  </head>
  <body style="border: 0; margin: 0;">
    <div id="map" style="width: 100%; height: 100vh;"></div>
  </body>
</html>
  
  """;

    return latitude1==0?html_String2:html_String1;
  }
}
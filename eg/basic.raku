#!raku

use Map::DeckGL;
use JSON::Fast;

my $deck = Map::DeckGL.new:
 initialViewState => {
    longitude => -74.0060,
    latitude => 40.7128,
    zoom => 17,
    pitch => 60,
    bearing => 0
  };

my $geojson = q:to/GEOJSON/;
{
  "type": "Feature",
  "properties": {
    "valuePerSqm": 100
  },
  "geometry": {
    "type": "Polygon",
    "coordinates": [
      [
        [-74.0060, 40.7128],
        [-74.0060, 40.7129],
        [-74.0061, 40.7129],
        [-74.0061, 40.7128],
        [-74.0060, 40.7128]
      ]
    ]
  }
}
GEOJSON

my $vc = Map::DeckGL::GeoJsonLayer.new:
      id =>  'geojson-layer',
      data => from-json($geojson),
      stroked =>  True,
      filled =>  True,
      extruded =>  True,
      wireframe =>  True,
      lineWidthMinPixels =>  2,
      getLineColor =>  [0, 100, 100],
      getFillColor =>  [200, 160, 0, 180],
      getLineWidth =>  10,
      getElevation =>  'f' => 'Math.sqrt(f.properties.valuePerSqm) * 2'
;

$deck.add-layer($vc);

"out.html".IO.spurt: $deck.render;

say "wrote out.html";


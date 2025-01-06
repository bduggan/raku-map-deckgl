#!raku

use Map::DeckGL;
use JSON::Fast;

my $deck = Map::DeckGL.new;

# bermuda triangle
my $geojson = q:to/GEOJSON/;
{
  "type": "Feature",
  "geometry": {
    "type": "Polygon",
    "coordinates": [
      [
        [-64.78, 32.3],
        [-80.19, 25.76],
        [-66.09, 18.43],
        [-64.78, 32.3]
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
      getLineWidth =>  10
;

$deck.add-layer($vc);

"out.html".IO.spurt: $deck.render;

say "wrote out.html";


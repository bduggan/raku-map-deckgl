#!raku

use Map::DeckGL;

my $deck = Map::DeckGL.new;
my $geojson =
  %( :type<Feature>, :geometry(
    %( :type<LineString>, :coordinates(
      [
        [-74.0060, 40.7128],
        [-73.9831, 40.7589],
        [-73.9825, 40.7227],
        [-74.0060, 40.7128]
      ]
    ))
  ));

my $vc = Map::DeckGL::GeoJsonLayer.new: data => $geojson;

$deck.add-layer($vc);

"out.html".IO.spurt: $deck.render;

say "wrote out.html";


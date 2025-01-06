#!raku

use Map::DeckGL;
use JSON::Fast;

my $deck = Map::DeckGL.new;

$deck.add-geojson:
  %( :type<Feature>, :geometry(
    %( :type<LineString>, :coordinates(
      [
        [-74.0060, 40.7128],
        [-73.9831, 40.7589],
        [-73.9825, 40.7227],
        [-74.0060, 40.7128]
      ]
    ))
  )),
  getLineColor => (100, 0, 0);

$deck.add-icon: lat => 40.7128, lon => -74.0060;

"out.html".IO.spurt: $deck.render;
say "wrote out.html";


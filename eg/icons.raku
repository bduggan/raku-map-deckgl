#!raku

use Map::DeckGL;
use JSON::Fast;

# center in SF
my $deck = Map::DeckGL.new(
  initialViewState => {
    longitude => -74.0060, latitude => 40.7128,
    zoom => 12,
    pitch => 50,
  }
);

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

my $icons = Map::DeckGL::IconLayer.new(
  data => 'https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/bart-stations.json',
  getColor => d => '[Math.sqrt(d.exits), 140, 0]',
  getIcon => d => "'marker'",
  getPosition => d => 'd.coordinates',
  getSize => 40,
  iconAtlas => 'https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/icon-atlas.png',
  iconMapping => 'https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/icon-atlas.json',
  pickable => True
);

$deck.add-layer: $icons;

my $icon = Map::DeckGL::IconLayer.new( getPosition => [ -74.0060, 40.7128 ],);
$deck.add-layer: $icon;

my $text = Map::DeckGL::TextLayer.new:
  getPosition => [ -74.0060, 40.7128 ],
  getText => f => "'Hello, World!'"
;
$deck.add-layer: $text;

"out.html".IO.spurt: $deck.render;

say "wrote out.html";


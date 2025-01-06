unit class Map::DeckGL;

use Map::DeckGL::Layers;
use JSON::Fast;

has @.layers;

# options: https://deck.gl/docs/api-reference/carto/basemap
has $.mapStyle = 'https://basemaps.cartocdn.com/gl/positron-nolabels-gl-style/style.json';

# override the calculated view state
# { longitude, latitude, zoom, pitch, bearing }
has %.initialViewState; # pitch => 40;

# { width, height, padding, minExtent, maxZoom, padding, offset }
has %.fit-bounds-opts = { padding => 100 };

has $.page-style = q:to/CSS/;
  #deckgl { height: 95vh; width: 95vw; }
  #deckwrapper { border: 1px solid black; }
  CSS

method add-geojson(Hash $geojson, *%opts) {
  my $new = Map::DeckGL::GeoJsonLayer.new: data => $geojson, |%opts;
  self.add-layer($new);
  $new;
}

multi method add-icon(:$lat!, :$lon!, *%opts) {
  my $new = Map::DeckGL::IconLayer.new: getPosition => [$lon, $lat], |%opts;
  self.add-layer($new);
  $new;
}

multi method add-icon($lat, $lon, *%opts) {
  my $new = Map::DeckGL::IconLayer.new: getPosition => [$lon, $lat], |%opts;
  self.add-layer($new);
  $new;
}

multi method add-text($lat!, $lon!, Str $text!, *%opts) {
  my $new = Map::DeckGL::TextLayer.new: getPosition => [$lon, $lat], getText => f => qq['$text'], |%opts;
  self.add-layer($new);
  $new;
}

method add-layer($layer) {
  @!layers.push($layer);
}

method render-head {
  q:to/HTML/;
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <script src="https://unpkg.com/deck.gl@latest/dist.min.js"></script>
  <script src="https://unpkg.com/turf@3.0.14/turf.min.js"></script>
  <script src="https://unpkg.com/maplibre-gl@3.0.0/dist/maplibre-gl.js"></script>
  <link href="https://unpkg.com/maplibre-gl@3.0.0/dist/maplibre-gl.css" rel="stylesheet" />
  HTML
}

method render {
  my $head = self.render-head;
  my $layers-js = "let bounds = [180, 90, -180, -90];\n";
  for @.layers -> $layer {
    $layers-js ~= $layer.render;
    if $layer.?has-position {
      my ($lon, $lat) = $layer.position;
      $layers-js ~= qq:to/JS/;
      bounds = dgl_extend(bounds, [$lon, $lat, $lon, $lat]);
      JS
    }
    next unless $layer.has-bounds;
    $layers-js ~= qq:to/JS/;
    bounds = dgl_extend(bounds, turf.bbox( {$layer.name }.props.data));
    JS
  }

  $layers-js ~= qq:to/JS/;
  let viewport = new WebMercatorViewport(\{
      width: window.innerWidth,
      height: window.innerHeight
  });
  let \{longitude, latitude, zoom} = viewport.fitBounds([
    [bounds[0], bounds[1]], [bounds[2], bounds[3]]
  ], { to-json %!fit-bounds-opts });
  let initialViewState = \{longitude, latitude, zoom};
  let overrides = { to-json %!initialViewState };
  initialViewState = \{ ...initialViewState, ...overrides };
  JS

  my $layer-names = @.layers.map(*.name).join(", ");

  return Q:s:to/HTML/;
  <!DOCTYPE html>
  <html>
    <head>$head </head>
  <body>
  <style>
  $.page-style
  </style>

  <div id="deckwrapper" style="position: relative;">
  <div id="deckgl"></div>

  <script>
  const dgl_extend = ([minx, miny, maxx, maxy], [minx2, miny2, maxx2, maxy2]) => {
    return [Math.min(minx, minx2), Math.min(miny, miny2),
            Math.max(maxx, maxx2), Math.max(maxy, maxy2)]
  }
  const {DeckGL,
        WebMercatorViewport,
        PolygonLayer,
        GeoJsonLayer,
        IconLayer, TextLayer
      } = deck;

  $layers-js

  new DeckGL({
      mapStyle: '$.mapStyle',
      container: document.getElementById('deckwrapper'),
      initialViewState,
      controller: true,
      layers: [
        $layer-names
      ]
    });
  </script>
  </body></html>
  HTML
}

=begin pod

=head1 NAME

Map::DeckGL - Generate maps using deck.gl

=head1 SYNOPSIS

Put some text on a map:

=begin code

my $deck = Map::DeckGL.new: initialViewState => zoom => 10;
$deck.add-text: 40.7128, -74.0060, "Hello, World!";

# brooklyn
$deck.add-text: 40.6782, -73.9442, "Brooklyn",
   color => [255, 0, 0], size => 10, backgroundColor => [0, 128, 0],
   sizeScale => 0.4, backgroundPadding => [10, 5, 10, 5],
   getBorderColor => [0, 0, 0], getBorderWidth => 2;
# manhattan
$deck.add-text: 40.7831, -73.9712, "Manhattan",
   color => [0, 0, 255], size => 10, backgroundColor => [255, 255, 0],
   sizeScale => 0.4, backgroundPadding => [10, 5, 10, 5],
   getBorderColor => [0, 0, 0], getBorderWidth => 2;
# queens
$deck.add-text: 40.7282, -73.7949, "Queens",
   color => [0, 255, 0], size => 10, backgroundColor => [255, 0, 255],
   sizeScale => 0.4, backgroundPadding => [10, 5, 10, 5],
   getBorderColor => [0, 0, 0], getBorderWidth => 2;
# bronx
$deck.add-text: 40.8448, -73.8648, "Bronx",
   color => [255, 255, 0], size => 10, backgroundColor => [0, 0, 255],
   sizeScale => 0.4, backgroundPadding => [10, 5, 10, 5],
   getBorderColor => [0, 0, 0], getBorderWidth => 2,
   getColor => [255, 255, 255];
# staten island
$deck.add-text: 40.5795, -74.1502, "Staten Island",
   color => [255, 0, 255], size => 10, backgroundColor => [0, 255, 0],
   sizeScale => 0.4, backgroundPadding => [10, 5, 10, 5],
   getBorderColor => [0, 0, 0], getBorderWidth => 2;
"out.html".IO.spurt: $deck.render;
say "wrote out.html";

=end code

![img](https://github.com/user-attachments/assets/d38359ba-8b60-4467-9571-224a3bd83188)

Put some some icons and geojson on a map:

=begin code

use Map::DeckGL;

my $map = Map::DeckGL.new;

my %geojson =
  type => 'FeatureCollection',
  features => [
    {
      type => 'Feature',
      geometry => {
        type => 'Polygon',
        coordinates => [
          [
            [-73.986454, 40.757722],
            [-73.986454, 40.758146],
            [-73.986129, 40.758146],
            [-73.986129, 40.757722],
            [-73.986454, 40.757722],
          ],
        ],
      },
    },
  ];

$map.add-geojson: %geojson,
  getFillColor => [255,0,0,128],
  getLineColor => [0,255,0,255];

$map.add-icon: 40.757722, -73.986454;
$map.add-text: 40.757722, -73.986454, 'times square';

spurt 'out.html', $map.render;

=end code

=head1 DESCRIPTION

This module provides an interface to generate HTML and Javascript
to render a map using the deck.gl javascript library.

After creating a C<Map::DeckGL> object, you can add layers to it
using C<add-geojson>, C<add-icon>, and C<add-text> methods.  This
add respectively, a GeoJsonLayer, an IconLayer, and a TextLayer.

The C<render> method will return the HTML and Javascript to render
the map.

Alternatively, layers can be generate direcly by using classes which
correspond to the DeckGL classes, and added via the C<add-layer> method.

=head1 METHODS

=head2 method add-geojson

=begin code

$map.add-geojson: %geojson, getFillColor => [255,0,0,128], getLineColor => [0,255,0,255];

=end code

Add a GeoJsonLayer to the map.  The first argument is a hash representing
the GeoJson data.  The remaining arguments are options to the GeoJsonLayer
constructor.  They correspond to the properties of the javascript object
which can be found in the deck.gl documentation: https://deck.gl/docs/api-reference/layers/geojson-layer

=head2 method add-icon

=begin code

$map.add-icon: 40.757722, -73.986454;
$map.add-icon: lat => 40.757722, lon => -73.986454;
$map.add-icon: lat => 40.757722, lon => -73.986454, iconAtlas => 'https://example.com/icon-atlas.png';

=end code

Add an IconLayer to the map.  The first two arguments are the latitude and longitude
of the icon.  The remaining arguments are options to the IconLayer constructor.
They correspond to the properties of the javascript object which can be found in
the deck.gl documentation: https://deck.gl/docs/api-reference/layers/icon-layer

=head2 method add-text

=begin code

$map.add-text: 40.757722, -73.986454, 'times square';
$map.add-text: lat => 40.757722, lon => -73.986454, text => 'times square';
$deck.add-text: 40.6782, -73.9442, "Brooklyn",
   color => [255, 0, 0], size => 10, backgroundColor => [0, 128, 0],
   sizeScale => 0.4, backgroundPadding => [10, 5, 10, 5],
   getBorderColor => [0, 0, 0], getBorderWidth => 2;

=end code

Add a TextLayer to the map.  The first two arguments are the latitude and longitude
of the text.  The remaining arguments are options to the TextLayer constructor.
They correspond to the properties of the javascript object which can be found in
the deck.gl documentation: https://deck.gl/docs/api-reference/layers/text-layer

=head2 method add-layer

=begin code

my $layer = Map::DeckGL::IconLayer.new: getPosition => [40.757722, -73.986454];
$map.add-layer($layer);

=end code

Add a layer to the map.  The argument should be an object of a class which corresponds
to a deck.gl layer.

=head2 method render

=begin code

spurt 'out.html', $map.render;

=end code

Return the HTML and Javascript to render the map.

=head1 ATTRIBUTES

=head2 mapStyle

Defaults to 'https://basemaps.cartocdn.com/gl/positron-nolabels-gl-style/style.json'

=head2 initialViewState

Override the calculated view state.  This is a hash with keys C<longitude>, C<latitude>,
C<zoom>, C<pitch>, and C<bearing>.  If this is omitted, the bounds are calculated from
the layers.  Any options here will override the calculated values.

=head2 fit-bounds-opts

=begin code

my $map = Map::DeckGL.new(fit-bounds-opts => { padding => 100 });

=end code

Options to pass to the C<fitBounds> method.  See the deck.gl documentation for details.

=head1 SEE ALSO

The deck.gl documentation: L<https://deck.gl>.

Also please check out the examples in the eg/ directory of this distribution,
as well as C<Map::DeckGL::Layers> for a comprehensive list of available layers
and their attributes.

=head1 AUTHOR

Brian Duggan

=end pod


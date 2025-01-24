[![Actions Status](https://github.com/bduggan/raku-map-deckgl/actions/workflows/linux.yml/badge.svg)](https://github.com/bduggan/raku-map-deckgl/actions/workflows/linux.yml)
[![Actions Status](https://github.com/bduggan/raku-map-deckgl/actions/workflows/macos.yml/badge.svg)](https://github.com/bduggan/raku-map-deckgl/actions/workflows/macos.yml)

NAME
====

Map::DeckGL - Generate maps using deck.gl

SYNOPSIS
========

Put some text on a map:

    use Map::DeckGL;

    my $deck = Map::DeckGL.new: initialViewState => zoom => 10;

    $deck.add-text: 40.7128, -74.0060, "Hello, World!";

    my @boroughs = [
        40.6782, -73.9442, 'Brooklyn', [255, 0, 0],
        40.7831, -73.9712, 'Manhattan', [100, 200, 155],
        40.7282, -73.7949, 'Queens', [0, 255, 0],
        40.8448, -73.8648, 'Bronx', [255, 255, 0],
        40.5795, -74.1502, 'Staten Island', [255, 0, 255],
    ];

    for @boroughs -> $lat, $lng, $name, $color {
        $deck.add-text: $lat, $lng, $name,
            color => $color,
            size => 10,
            backgroundColor => $color,
            sizeScale => 0.4,
            backgroundPadding => [10, 5, 10, 5],
            getBorderColor => [0, 0, 0],
            getBorderWidth => 2;
    }

    $deck.show;

![img](https://github.com/user-attachments/assets/76a771cd-2337-4858-bfc0-0dca80a0d783)

Put some some icons and geojson on a map:

    use Map::DeckGL;

    my $map = Map::DeckGL.new: initialViewState => %( :pitch(75), :zoom(17) );


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

    $map.add-geojson:	%geojson,
      getFillColor => [19, 126, 109, 255],
      getLineColor => [126, 19, 109, 255];

    $map.add-icon: 40.757722, -73.986454, getSize => f => 100;
    $map.add-text: 40.757722, -73.986454, 'times square',
      backgroundColor => [255, 255, 255, 100],
      getBorderColor => [0, 0, 0],
      getBorderWidth => 2;

    $map.show;

![img](https://github.com/user-attachments/assets/cf7e5dfd-288e-4865-9ee6-d3dcdea62a9c)

DESCRIPTION
===========

This module provides an interface to generate HTML and Javascript to render a map using the deck.gl javascript library.

After creating a `Map::DeckGL` object, you can add layers to it using `add-geojson`, `add-icon`, and `add-text` methods. This adds respectively, a GeoJsonLayer, an IconLayer, and a TextLayer.

The `render` method will return the HTML and Javascript to render the map.

Alternatively, layers can be generated directly by using classes which correspond to the DeckGL classes, and added via the `add-layer` method.

EXPORTS
=======

If an argument is given to the module, a new `Map::DeckGL` object is created and returned with that name. e.g.

    use Map::DeckGL 'deck';
    deck.add-text: 40.7128, -74.0060, "Hello, World!

is equivalent to

    use Map::DeckGL;
    my $deck = Map::DeckGL.new;
    $deck.add-text: 40.7128, -74.0060, "Hello, World!

METHODS
=======

method add-geojson
------------------

    $map.add-geojson: %geojson, getFillColor => [255,0,0,128], getLineColor => [0,255,0,255];

Add a GeoJsonLayer to the map. The first argument is a hash representing the GeoJson data. The remaining arguments are options to the GeoJsonLayer constructor. They correspond to the properties of the javascript object which can be found in the deck.gl documentation: https://deck.gl/docs/api-reference/layers/geojson-layer

method add-icon
---------------

    $map.add-icon: 40.757722, -73.986454;
    $map.add-icon: lat => 40.757722, lon => -73.986454;
    $map.add-icon: lat => 40.757722, lon => -73.986454, iconAtlas => 'https://example.com/icon-atlas.png';

Add an IconLayer to the map. The first two arguments are the latitude and longitude of the icon. The remaining arguments are options to the IconLayer constructor. They correspond to the properties of the javascript object which can be found in the deck.gl documentation: https://deck.gl/docs/api-reference/layers/icon-layer

method add-text
---------------

    $map.add-text: 40.757722, -73.986454, 'times square';
    $map.add-text: lat => 40.757722, lon => -73.986454, text => 'times square';
    $deck.add-text: 40.6782, -73.9442, "Brooklyn",
       color => [255, 0, 0], size => 10, backgroundColor => [0, 128, 0],
       sizeScale => 0.4, backgroundPadding => [10, 5, 10, 5],
       getBorderColor => [0, 0, 0], getBorderWidth => 2;

Add a TextLayer to the map. The first two arguments are the latitude and longitude of the text. The remaining arguments are options to the TextLayer constructor. They correspond to the properties of the javascript object which can be found in the deck.gl documentation: https://deck.gl/docs/api-reference/layers/text-layer

method add-layer
----------------

    my $layer = Map::DeckGL::IconLayer.new: getPosition => [40.757722, -73.986454];
    $map.add-layer($layer);

Add a layer to the map. The argument should be an object of a class which corresponds to a deck.gl layer.

method render
-------------

    spurt 'out.html', $map.render;

Return the HTML and Javascript to render the map.

method write
------------

    $map.write;

Write the HTML and Javascript to a file. The default filename is 'map-deck-gl-tmp.html'. Returns true if the file was created, false if it already existed.

method show
-----------

    $map.show;

Write the HTML and Javascript to a file, and open it in a browser.

ATTRIBUTES
==========

output-path
-----------

Where to write the file when calling `write`. Defaults to 'map-deck-gl-tmp.html'.

mapStyle
--------

Defaults to 'https://basemaps.cartocdn.com/gl/positron-nolabels-gl-style/style.json'

initialViewState
----------------

Override the calculated view state. This is a hash with keys `longitude`, `latitude`, `zoom`, `pitch`, and `bearing`. If this is omitted, the bounds are calculated from the layers. Any options here will override the calculated values.

fit-bounds-opts
---------------

    my $map = Map::DeckGL.new(fit-bounds-opts => { padding => 100 });

Options to pass to the `fitBounds` method. See the deck.gl documentation for details.

SEE ALSO
========

The deck.gl documentation: [https://deck.gl](https://deck.gl).

Also please check out the examples in the eg/ directory of this distribution, as well as `Map::DeckGL::Layers` for a comprehensive list of available layers and their attributes.

AUTHOR
======

Brian Duggan


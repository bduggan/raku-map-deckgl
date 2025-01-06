[![Actions Status](https://github.com/bduggan/raku-map-deckgl/actions/workflows/linux.yml/badge.svg)](https://github.com/bduggan/raku-map-deckgl/actions/workflows/linux.yml)
[![Actions Status](https://github.com/bduggan/raku-map-deckgl/actions/workflows/macos.yml/badge.svg)](https://github.com/bduggan/raku-map-deckgl/actions/workflows/macos.yml)

NAME
====

Map::DeckGL - Generate maps using deck.gl

SYNOPSIS
========

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

![img](https://github.com/user-attachments/assets/d38359ba-8b60-4467-9571-224a3bd83188)

DESCRIPTION
===========

This module provides an interface to generate HTML and Javascript to render a map using the deck.gl javascript library.

After creating a `Map::DeckGL` object, you can add layers to it using `add-geojson`, `add-icon`, and `add-text` methods. This add respectively, a GeoJsonLayer, an IconLayer, and a TextLayer.

The `render` method will return the HTML and Javascript to render the map.

Alternatively, layers can be generate direcly by using classes which correspond to the DeckGL classes, and added via the `add-layer` method.

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

ATTRIBUTES
==========

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


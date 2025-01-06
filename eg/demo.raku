#!raku

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

spurt 'out.html', $map.render;




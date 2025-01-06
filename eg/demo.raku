#!raku

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

$map.add-geojson:	%geojson,
  getFillColor => [255,0,0,128],
  getLineColor => [0,255,0,255];

$map.add-icon: 40.757722, -73.986454;
$map.add-text: 40.757722, -73.986454, 'times square';

spurt 'out.html', $map.render;




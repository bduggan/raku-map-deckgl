#!raku

use Map::DeckGL;

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


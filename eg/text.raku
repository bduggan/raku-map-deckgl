#!raku

use Map::DeckGL '$deck';

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


#!raku

use Map::DeckGL::Utils;
class Map::DeckGL::BaseLayer {
  has Str $.id;
  has $.data;
  has Bool $.visible;
  has $.opacity;
  has $.onError;
  has Bool $.pickable;
  has $.onHover;
  has $.onClick;
  has $.onDragStart;
  has $.onDrag;
  has $.onDragEnd;
  has $.highlightColor;
  has $.highlightedObjectIndex;
  has Bool $.autoHighlight;
  has $.coordinateSystem;
  has $.coordinateOrigin;
  has $.wrapLongitude;
  has $.modelMatrix;
  has $.dataComparator;
  has $.dataTransform;
  has $.positionFormat;
  has $.colorFormat;
  has $.numInstances;
  has $.updateTriggers;
  has $.fetch;
  has $.onDataLoad;
  # render properties
  has $.getPolygonOffset;
  has $.transitions;

  method has-bounds { True }
}

my $i = 0;
# see https://deck.gl/docs/api-reference/layers/geojson-layer
# https://github.com/visgl/deck.gl/blob/master/modules/layers/src/geojson-layer/geojson-layer.ts

class Map::DeckGL::GeoJsonLayer is Map::DeckGL::BaseLayer does DeckObj is export {
  has $.name = 'geojson_' ~ $i++;
  has Str $.pointType;
  has Bool $.filled;
  has $.getFillColor = [0, 100, 255, 150];

  has Bool $.stroked;
  has $.getLineColor = [0, 100, 200, 255];
  has $.getLineWidth;
  has $.lineWidthUnits;
  has $.lineWidthScale;
  has Int $.lineWidthMinPixels = 2;
  has Bool $.lineJointRounded;
  has Bool $.lineMiterLimit;
  has $.lineCapRounded;
  has $.lineBillboard;

  has Bool $.extruded;
  has Bool $.wireframe;
  has $.getElevation;
  has Numeric $.elevationScale;
  has $.material;

  #  export type _GeoJsonLayerPointCircleProps<FeaturePropertiesT> = {
  has $.getPointRadius;
  has $.pointRadiusUnits;
  has $.pointRadiusScale;
  has $.pointRadiusMinPixels;
  has $.pointRadiusMaxPixels;
  has $.pointAntiAliasing;
  has $.pointBillboard;

  # /** GeoJsonLayer properties forwarded to `IconLayer` if `pointType` is `'icon'` */
  has $.iconAtlas;
  has $.iconMapping;
  has $.getIcon;
  has $.getIconSize;
  has $.getIconColor;
  has $.getIconAngle;
  has $.getIconPixelOffset;
  has $.iconSizeUnits;
  has $.iconSizeScale;
  has $.iconSizeMinPixels;
  has $.iconSizeMaxPixels;
  has $.iconBillboard;
  has $.iconAlphaCutoff;

  # /** GeoJsonLayer properties forwarded to `TextLayer` if `pointType` is `'text'` */
  has $.getText;
  has $.getTextColor;
  has $.getTextAngle;
  has $.getTextSize;
  has $.getTextAnchor;
  has $.getTextAlignmentBaseline;
  has $.getTextPixelOffset;
  has $.getTextBackgroundColor;
  has $.getTextBorderColor;
  has $.getTextBorderWidth;
  has $.textSizeUnits;
  has $.textSizeScale;
  has $.textSizeMinPixels;
  has $.textSizeMaxPixels;
  has $.textCharacterSet;
  has $.textFontFamily;
  has $.textFontWeight;
  has $.textLineHeight;
  has $.textMaxWidth;
  has $.textWordBreak;
  has $.textBackground;
  has $.textBackgroundPadding;
  has $.textOutlineColor;
  has $.textOutlineWidth;
  has $.textBillboard;
  has $.textFontSettings;

  method render {
    my $options = self.construct-option-string(exclude => set <name>);
    return qq:to/JS/;
      let $.name = new GeoJsonLayer($options);
    JS
  }
}

class Map::DeckGL::IconLayer is Map::DeckGL::BaseLayer does DeckObj is export {
  also does Positionable;
  has $.name = 'icon_' ~ $i++;
  has $.data = [ { id => 0, name => 'raku-deck-gl-placeholder' }, ]; # required for some layers
  has $.iconAtlas = 'https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/icon-atlas.png',
  has $.iconMapping = 'https://raw.githubusercontent.com/visgl/deck.gl-data/master/website/icon-atlas.json',
  has $.sizeScale;
  has $.sizeUnits;
  has $.sizeMinPixels;
  has $.sizeMaxPixels;
  has $.billboard;
  has $.alphaCutoff;
  has $.loadOptions;
  has $.textureParameters;
  # Data Accessors
  has $.getIcon = d => "'marker'",
  has $.getPosition;
  has $.getSize = 40;
  has $.getColor = [100, 140, 0];
  has $.getAngle;
  has $.getPixelOffset;
  has $.onIconError;

  method has-bounds { False }

  method render {
    my $options = self.construct-option-string(exclude => set <name>);
    return qq:to/JS/;
      let $.name = new IconLayer($options);
    JS
  }

}

# see https://deck.gl/docs/api-reference/layers/text-layer
# or https://github.com/visgl/deck.gl/blob/master/modules/layers/src/text-layer/text-layer.ts
class Map::DeckGL::TextLayer is Map::DeckGL::BaseLayer does DeckObj is export {
  also does Positionable;
  has $.name = 'text_' ~ $i++;
  has $.data = [ { id => 0, name => "raku-deck-gl-placeholder" }, ];
  has Bool $.billboard;
  has $.sizeScale;
  has $.sizeUnits;
  has $.sizeMinPixels;
  has $.sizeMaxPixels;
  has Bool $.background;
  has $.getBackgroundColor;
  has $.getBorderColor;
  has $.getBorderWidth;
  has $.backgroundPadding;
  has $.characterSet;
  has $.fontFamily;
  has $.fontWeight;
  has $.lineHeight;
  has $.outlineWidth;
  has $.outlineColor;
  has $.fontSettings;
  has $.wordBreak;
  has $.maxWidth;
  has $.getText;
  has $.getPosition;
  has $.getColor;
  has $.getSize;
  has $.getAngle;
  has $.getTextAnchor;
  has $.getAlignmentBaseline;
  has $.getPixelOffset;
  has $.backgroundColor;

  method has-bounds { False }

  method render {
    my $options = self.construct-option-string(exclude => set <name>);
    return qq:to/JS/;
      let $.name = new TextLayer($options);
    JS
  }

}

#!raku

use JSON::Fast;

sub escape-val(Str $val) {
  $val.subst(:g,  / "'" /, "\\'").subst(:g, "\n", "\\n");
}

sub option-string(%options) {
  '{' ~
  %options.map({ .key ~ ': ' ~ quote-value(.value) }).join(', ')
  ~ '}';
}

sub quote-value($value) is export {
  given $value {
    when Str { "'" ~ escape-val($value) ~ "'" }
    when Bool { $value ?? 'true' !! 'false' }
    when Hash { to-json($value, :!pretty) }
    when Numeric { $value }
    when .^name ~~ /Leaflet/ { $value.Str }
    when Array|List { '[' ~ $value.map({ quote-value($_) }).join(', ') ~ ']' }
    when Pair { # javascript point block
      $value.key ~ ' => ' ~ $value.value
    }
    default {
      warn "Unknown value type: { $value.^name }";
      $value.Str
    }
  }
}


role DeckObj is export {
  method construct-options(Set :$exclude) {
    my %values;
    for self.^attributes.list -> $attr {
      my $value = $attr.get_value(self);
      next unless defined($value);
      # remove sigil
      my $key = $attr.name.subst( / <-[a..zA..Z0..9-]>+ /, '', :g );
      next if $key eq 'name';
      next if $exclude && $key (elem) $exclude;
      %values{ $key } = $value;
    }
    return %values;
  }

  method construct-option-string(Set :$exclude) {
    my %values = self.construct-options(:$exclude);
    return option-string(%values);
  }

  method Str { $.name }
}

role Positionable is export {
  method getPosition { ... }
  method has-position {
    return False without $.getPosition;
    return True if $.getPosition ~~ Array;
    return True if $.getPosition ~~ Pair && $.getPosition.value ~~ Array;
    return False;
  }
  method position {
    return $.getPosition if $.getPosition ~~ Array;
    return $.getPosition.value if $.getPosition ~~ Pair && $.getPosition.value ~~ Array;
    return ();
  }
}


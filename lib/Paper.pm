package Paper;
use warnings;
use strict;
use XML::LibXML;

use base 'Exporter';
our @EXPORT = qw();
our @EXPORT_OK = qw(elt append CLIP_PATH RECT LINE CIRCLE STYLE SVG G
                    $NON_REPRO_BLUE $RED $PAPER_STYLES);
our %EXPORT_TAGS = (all => [@EXPORT_OK]);

our $NON_REPRO_BLUE = "#95c9d7";
our $RED = "#ff9e9e";

our $doc;

sub elt {
    my ($tagName, @args) = @_;
    my $elt = $doc->createElement($tagName);
    while (scalar @args) {
        my $arg = shift(@args);
        if (eval { $arg->isa('XML::LibXML::Element') }) {
            $elt->appendChild($arg);
        } elsif (ref $arg eq 'ARRAY') {
            append($elt, @$arg);
        } elsif (ref $arg eq 'HASH') {
            append($elt, $arg);
        } elsif (ref $arg eq 'SCALAR') {
            append($elt, $$arg);
        } elsif (ref $arg eq '') {
            if (!scalar @args) {
                append($elt, $arg);
                last;
            }
            my $value = shift(@args);
            $elt->setAttribute($arg, $value);
        }
    }
    return $elt;
}

sub append {
    my ($elt, @content) = @_;
    foreach my $content (@content) {
        if (eval { $content->isa('XML::LibXML::Element') }) {
            $elt->appendChild($content);
        } elsif (ref $content eq '') { # these are filtered out but array references may have them.
            $elt->appendTextNode($content);
        } elsif (ref $content eq 'SCALAR') {
            $elt->appendTextNode($$content);
        } elsif (ref $content eq 'ARRAY') {
            foreach my $child (@$content) {
                append($elt, $child);
            }
        } elsif (ref $content eq 'HASH') {
            foreach my $key (keys %$content) {
                $elt->setAttribute($key, $content->{$key});
            }
        }
    }
}

sub CLIP_PATH {
    return elt('clipPath', @_);
}
sub RECT {
    return elt('rect', @_);
}
sub LINE {
    return elt('line', @_);
}
sub CIRCLE {
    return elt('circle', @_);
}
sub STYLE {
    return elt('style', @_);
}
sub SVG {
    return elt('svg', version => '1.1', xmlns => 'http://www.w3.org/2000/svg', @_);
}
sub G {
    return elt('g', @_);
}

our $PAPER_STYLES = <<"END";
/* START_CSS */

line, rect, circle {
    fill: none;
    stroke-width: 0;
    stroke-linecap: round;
    stroke-linejoin: round;
}
.feint {
    stroke-width: 0.16px;
}
.minor {
    stroke-width: 0.32px;
}
.major {
    stroke-width: 0.64px;
}
.stroke-non-repro-blue {
    stroke: $NON_REPRO_BLUE;
}
.fill-non-repro-blue {
    fill: $NON_REPRO_BLUE;
}
.stroke-red {
    stroke: $RED;
}
.fill-red {
    fill: $RED;
}

/* END_CSS */
END

1;

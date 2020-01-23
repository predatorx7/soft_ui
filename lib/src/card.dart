import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'
    show CardTheme, Material, MaterialType, Theme, Colors;

/// A Neumorphic design material card.
///
/// A card is a sheet of [Material] used to represent some related information,
/// for example an album, a geographical location, a meal, contact details, etc.
class Card extends StatelessWidget {
  /// Creates a Neumorphic design card.
  ///
  /// Compatible with Material Card.
  ///
  /// The [elevation] must be null or non-negative. The [borderOnForeground]
  /// must not be null.
  const Card({
    Key key,
    this.color, //= nSurfaceColor,
    this.elevation,
    this.shape,
    this.surface = SurfaceShape.concave,
    this.lightSource,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.child,
    this.allowGradient = true,
    this.semanticContainer = true,
  })  : assert(elevation == null || elevation >= 0.0),
        assert(borderOnForeground != null),
        super(key: key);

  /// The card's background color.
  ///
  /// Defines the card's [Material.color].
  ///
  /// If this property is null then [ThemeData.cardTheme.color] is used,
  /// if that's null then [ThemeData.cardColor] is used.
  final Color color;

  /// Applies gradient effect when true.
  /// Default is true.
  final bool allowGradient;

  /// The z-coordinate at which to place this card. This controls the size of
  /// the shadow below the card.
  ///
  /// Defines the card's [Material.elevation].
  ///
  /// If this property is null then [ThemeData.cardTheme.elevation] is used,
  /// if that's null, the default value is 1.0.
  final double elevation;

  /// The shape of the card's [Material].
  ///
  /// Defines the card's [Material.shape].
  ///
  /// If this property is null then [ThemeData.cardTheme.shape] is used.
  /// If that's null then the shape will be a [RoundedRectangleBorder] with a
  /// circular corner radius of 4.0.
  final ShapeBorder shape;

  /// The surface shape type of the card's surface.
  ///
  /// Defines the card's [SurfaceShape].
  ///
  /// If this property is null then [SurfaceShape.concave] is used.
  final SurfaceShape surface;

  /// Point to emulate light from.
  ///
  /// Defines the card's [LightSource].
  ///
  /// If this property is on default then [LightSource.topLefft] is used.
  final LightSource lightSource;

  /// Whether to paint the [shape] border in front of the [child].
  ///
  /// The default value is true.
  /// If false, the border will be painted behind the [child].
  final bool borderOnForeground;

  /// {@macro flutter.widgets.Clip}
  ///
  /// If this property is null then [ThemeData.cardTheme.clipBehavior] is used.
  /// If that's null then the behavior will be [Clip.none].
  final Clip clipBehavior;

  /// The empty space that surrounds the card.
  ///
  /// Defines the card's outer [Container.margin].
  ///
  /// If this property is null then [ThemeData.cardTheme.margin] is used,
  /// if that's null, the default margin is 4.0 logical pixels on all sides:
  /// `EdgeInsets.all(4.0)`.
  final EdgeInsetsGeometry margin;

  /// Whether this widget represents a single semantic container, or if false
  /// a collection of individual semantic nodes.
  ///
  /// Defaults to true.
  ///
  /// Setting this flag to true will attempt to merge all child semantics into
  /// this node. Setting this flag to false will force all child semantic nodes
  /// to be explicit.
  ///
  /// This flag should be false if the card contains multiple different types
  /// of content.
  final bool semanticContainer;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  static const double _defaultElevation = 1.0;

  @override
  Widget build(BuildContext context) {
    final CardTheme cardTheme = CardTheme.of(context);
    final Color nColor = color ?? Theme.of(context).cardColor;
    final double blurRadius = 12;
    final double blurOffset = blurRadius / 2;
    Color lightShade = Color.lerp(nColor, nLightColor, 0.6);
    Color darkShade = Color.lerp(nColor, nDarkColor, 0.3);
    Color lightGradient = Color.lerp(nColor, nLightColor, 0.1);
    Color darkGradient = Color.lerp(nColor, nDarkColor, 0.5);
    bool isLightOnTop = (lightSource == LightSource.topLeft ||
        lightSource == LightSource.topRight);
    bool isConcave = (surface != SurfaceShape.convex);
    Color topShade, bottomShade, topGradient = nColor, bottomGradient = nColor;
    if (isLightOnTop) {
      topShade = lightShade;
      bottomShade = darkShade;
      if (allowGradient) {
        topGradient = isConcave ? lightGradient : darkGradient;
        bottomGradient = isConcave ? darkGradient : lightGradient;
      }
    } else {
      topShade = darkShade;
      bottomShade = lightShade;
      if (allowGradient) {
        topGradient = isConcave ? darkGradient : lightGradient;
        bottomGradient = isConcave ? lightGradient : darkGradient;
      }
    }

    return Semantics(
      container: semanticContainer,
      child: Container(
        margin: margin ?? cardTheme.margin ?? const EdgeInsets.all(4.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          border: Border.all(
            width: 0.1,
            color: nColor.withAlpha(51),
          ),
          boxShadow: [
            BoxShadow(
              color: topShade,
              blurRadius: blurRadius, // has the effect of softening the shadow
              // spreadRadius: -12.0, // has the effect of extending the shadow
              offset: Offset(
                -blurOffset, // horizontal, move right -6
                -blurOffset, // vertical, move down -6
              ),
            ),
            BoxShadow(
              color: bottomShade,
              blurRadius: blurRadius, // has the effect of softening the shadow
              // spreadRadius: -12.0, // has the effect of extending the shadow
              offset: Offset(
                blurOffset, // horizontal, move right -6
                blurOffset, // vertical, move down -6
              ),
            )
          ],
          gradient: allowGradient
              ? LinearGradient(
                  colors: [
                      topGradient,
                      nColor,
                      bottomGradient,
                    ],
                  stops: [
                      0.0,
                      0.5,
                      1.0
                    ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.repeated)
              : null,
        ),
        child: Semantics(
          explicitChildNodes: !semanticContainer,
          child: child,
        ),
      ),
    );
  }
}

enum LightSource { topLeft, topRight, bottomLeft, bottomRight }

enum SurfaceShape { convex, concave }

const Color nLightColor = Color(0xffffffff);

const Color nDarkColor = Color(0xffd1cdc7);

const Color nSurfaceColor = Color(0xffefeeee);

# fanogrid

Choosing a grid size for aggregating GPS points fixes the spatial resolution of
every analysis that follows. Selectors based on minimising the mean integrated
squared error assume that points fall independently. GPS points from human
mobility do not: people travel with family, friends and colleagues, so points
arrive in groups a few metres across. A selector that assumes independence reads
that clustering as structure in the underlying population density and asks for a
finer grid than the data support.

This package estimates the Fano factor from the inhomogeneous K-function and
uses it to correct the cost function. Grid size and Fano factor are estimated
together, by alternating updates from the Poisson starting point.

The package accompanies:

> Aoki, T., Koyama, S. and Fujiwara, N.
> How fine a grid do GPS data support for urban populations when people move
> together?

## Status

The API is in place but the estimators are not implemented yet. Every exported
function currently stops with `not implemented`.

## Installation

```r
# install.packages("pak")
pak::pak("TakaakiAokiWork/fanogrid")
```

## Usage

```r
library(fanogrid)

# synthetic_gps: 10,070 clustered points over a 9.9 km by 10.0 km area of Tokyo,
# with a population density that is piecewise constant on the 250-meter census
# grid, so the scale to recover is known.
fit <- fanogrid(synthetic_gps, target_area)
fit$delta   # selected cell side, in metres
fit$fano    # Fano factor it was selected under
fit$trace   # one row per round of the alternation
```

The two halves can also be called on their own. `select_grid(points, window,
fano = 1)` is the two-dimensional form of the Shimazaki-Shinomoto selector, and
`estimate_fano(points, window, nx, ny)` returns the Fano factor on a given grid.

See `vignette("fanogrid")` for a walk through one synthetic sample.

## License

GPL (>= 3). See [LICENSE.md](LICENSE.md).

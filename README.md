# fanogrid

Choosing a grid size for aggregating GPS points fixes the spatial resolution of every analysis that follows.
Selectors based on minimising the mean integrated squared error assume that points fall independently.
However, GPS points from human mobility are not independent: people travel together, so points arrive in groups a few metres across.
A selector that assumes independence reads that clustering as structure in the underlying population density and asks for a finer grid than the data support.

This package estimates the Fano factor from the inhomogeneous K-function and uses it to correct the cost function.
Grid size and Fano factor are estimated together, by alternating updates from the Poisson starting point.

The package accompanies Aoki, Koyama and Fujiwara (arXiv:xxxx.xxxxx).

## Installation

```r
# install.packages("pak")
pak::pak("TakaakiAokiWork/fanogrid")
```

## Usage

```r
library(fanogrid)

# the synthetic sample shipped with the package: 175,470 clustered points over
# an area of about 10 km by 10 km in Tokyo, with a density that is piecewise
# constant on the 250 m census grid, whose cells are 283 m by 231 m, so the
# scale to recover is the shorter side, 231 m
gps <- read.csv(system.file("extdata", "synthetic_gps.csv.xz",
                            package = "fanogrid"))
window <- c(xmin = -21403, xmax = -11488, ymin = -34895, ymax = -24936)

fit <- fanogrid(gps, window)
fit$delta   # 231.1: selected cell side, in metres
fit$fano    # 2.08: Fano factor measured on that grid
fit$trace   # one row per round of the alternation

# assuming independence asks for a grid three times finer
select_grid(gps, window, fano = 1)$delta   # 81.5
```

The two estimators can also be called on their own.
`select_grid(points, window, fano = 1)` reduces to one of the existing selectors, the two-dimensional form of the unbiased risk estimator of Shimazaki and Shinomoto (2007), and `estimate_fano(points, window, nx, ny)` returns the Fano factor on a given grid.

`vignette("fanogrid")` works through a synthetic sample whose clustering and underlying scale are known.
On that sample the Poisson selector asks for cells of 81 m while `fanogrid()` settles at 231 m, which is the scale the density varies on.

## References

Aoki, T., Koyama, S. and Fujiwara, N.
How fine a grid do GPS data support for urban populations when people move together?
arXiv:xxxx.xxxxx

Shimazaki, H. and Shinomoto, S. (2007)
A method for selecting the bin size of a time histogram.
*Neural Computation* **19**(6), 1503-1527.
<https://doi.org/10.1162/neco.2007.19.6.1503>

## License

GPL (>= 3). See [LICENSE.md](LICENSE.md).

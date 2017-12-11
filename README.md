kronawidget
===========

Installation
------------

Install the package using `devtools`. This requires you to have the
`devtools` package installed.

    devtools::install_github('dataroots/kronawidget')

Example dataset
---------------

An example dataset for testing purposes is included in the package. You
can load this dataset as follows.

    # load test dataset
    data(testdata, package = 'kronawidget')

    # get a peek
    head(testdata)

    ##   id area country river.basin.district first.stressor second.stressor
    ## 1  1   16      FR        Adour-Garonne      stressor1       stressor2
    ## 2  2   60      FR        Adour-Garonne    no stressor     no stressor
    ## 3  3   74      FR        Adour-Garonne      stressor1       stressor2
    ## 4  4   26      FR        Adour-Garonne      stressor3       stressor4
    ## 5  5   47      FR        Adour-Garonne      stressor1       stressor3
    ## 6  6   34      FR        Adour-Garonne      stressor4     no stressor
    ##   third.stressor
    ## 1    no stressor
    ## 2    no stressor
    ## 3    no stressor
    ## 4    no stressor
    ## 5      stressor4
    ## 6    no stressor

Constructing a krona data object
--------------------------------

The KRONA library uses an XML data representation. In order to use a
`data.frame` as input, one first needs to convert it to a KRONA
compatible shape using `df_to_krona`. Have a look at `?df_to_krona` to
better understand the arguments to be passed to the function.

    library(kronawidget)

    testdata_doc<-
      df_to_krona(df = testdata,
                  name = "testdata",
                  magnitude = "area",
                  "country", "river.basin.district", "first.stressor", "second.stressor")

As the `df_to_krona` function is quite heavy from a computational point
of view, there is also a `df_to_krona_cached` function available, which
wraps the `df_to_krona` into a memoization layer (using the `memoise`
package).

Stand-alone use
---------------

The stand-alone use of the visualization is rather straightforward:

    kronawidget(testdata_doc)

Shiny app integration
---------------------

In order to use the KRONA visualization inside of a Shiny app the
following functions are available:

-   `renderKronawidget` (check `?renderKronawidget`): used in order to
    actually generate a KRONA graph in the server-side of your app. You
    can e.g. use the example defined under ‘stand-alone usage’ and
    encapsulate it in the `renderKronaWdiget`.
-   `kronawidgetOutput` (check `?kronawidgetOutput`): which renders the
    output in the UI part of your app

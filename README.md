# Phuse2020
R Shiny programs for the Phuse 2020 presentation by John Hendrickx

This site contains two examples on how to create thumnail images in R Shiny that can be expanded by clicking. The basic procedure is:

* In “ui.R”
  * Define a web page with two tabs, one for the “Thumbnail plots”, one for the “Expanded version”
  * Let the thumbnails plots be (double-)clickable
* In “server.R”:
  * Create the thumbnail plot
  * Use information from a mouse-click to derive the data subset for the enlarged plot
  * Switch to the “Expanded version” tab and display the selected data as a single chart

The example in subfolder "Example 1" shows how to use a lattice plot to create expandable thumbnails. Example 2 uses grid.arrage from the gridExtra package. This is a more general situation since it doesn't require two classicication variables as the lattice plot does. 

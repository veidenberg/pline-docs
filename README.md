# Source files for Pline [documentation website](http://wasabiapp.org/pline/)

Uses Vuepress static site generator and reactive Vue components.

## Installation

1. Install [Vuepress](https://vuepress.vuejs.org)
2. Place this repo to `~/Desktop/Pline/docs`
3. Run `.vuepress/public/archive.sh`
    + this creates zip files to `~/Downloads/Pline_zip`

Default directories can be changed by editing the symlinks in `.vuepress/public`

## Development

1. Edit the source files: markup/HTML in `*.md` files and Vue components in `.vuepress/components`.  
2. Run `vuepress dev` in the root directory to preview the site.

## Deployment

1. Run `vuepress build`
2. Place the resulting files from `.vuepress/dist` to a web server.

# backoffice_skeleton

# node.js v 14.14.0
# npm v 6.14.8

This backoffice skeleton is/was made with the intention of speed up the development of (surprise, surprise :) backoffices made of node.js backends and react.js frontends.

To archieve small size, high performance and portability, the react.js frontend, insteady of fancy packages and theyr fancier ways to configure themes, uses just html, sass, and font awesone icons, and the theme is in /frontend/theme/index.scss file.

This backoffice frontend have a superior appbar, a lateral, foldable menubar and then some crud examples:

* single tables with few columns with direct edition;
* single tables with forms to insert/edit/confirm delections
* master/details tables
* detail/masters tables

The backoffice backend intermediates the frontend and a mariadb/mysql database.

# to install node.js version 14.xx.yy in ubuntu 20.04
# curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

bacro
=====

A multiplayer web game of bacronyms.

## Setup(ish)

Ensure you have ruby, node/npm and suitable global versions of `grunt`, `grunt-cli`, `bower`, `coffeescript`, `compass`, `bourbon` and `neat`.

    $ git clone ...
    $ npm install
    $ bower install
    $ bourbon install --path=scss/bourbon
    $ cd scss && neat install && cd ..
    $ grunt copy:pure
    $ grunt server


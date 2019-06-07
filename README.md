# An IPFS interface for Pharo

![screenshot](./screenshot.png)

**Important note:** This is work in progress, written so far mainly to let me play with IPFS. Everything might change at any time. Don't rely on this package for mission-critical software! Moreover, many things are still missing, in particular support for IPNS and the file system layer. But for experimenting with [IPLD](http://ipld.io/) it's just fine!

## Installation

To use this package, your computer must run a local IPFS node. On a personal machine, [IPFS Desktop](https://github.com/ipfs-shipyard/ipfs-desktop) is the most convenient way to do so. Alternatively, or for running on a server, use the [command-line version](https://docs.ipfs.io/guides/guides/install/).

To install in Pharo 7, execute the following lines in a playground:

```
Metacello new
    baseline: 'IPFS';
    repository: 'github://khinsen/ipfs-pharo/src';
    load.
```

To install the support for [GToolkit](http://gtoolkit.com) as well, replace by:

```
EpMonitor current disable.
[ 
Metacello new
    baseline: 'IPFS';
    repository: 'github://khinsen/ipfs-pharo/src';
    onConflictUseLoaded;
    load: 'All'.
] ensure: [ EpMonitor current enable ].
```

The GToolkit add-on is strongly recommended, as it contains everything you need to explore IPFS: inspector views for everything, and a tutorial accessible from the World menu. But be aware that GToolkit is rather big, so be prepared for a lengthy installation.

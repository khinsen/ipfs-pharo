# An IPFS interface for Pharo

![screenshot](./screenshot.png)

**Important note:** This is work in progress, written so far mainly to let me play with IPFS. Everything might change at any time. Don't rely on this package for mission-critical software! Moreover, many things are still missing, in particular support for IPNS and the file system layer. But for experimenting with [IPLD](http://ipld.io/) it's just fine!

## Installation

To use this package, your computer must run a local IPFS node. On a personal machine, [IPFS Desktop](https://github.com/ipfs-shipyard/ipfs-desktop) is the most convenient way to do so. Alternatively, or for running on a server, use the [command-line version](https://docs.ipfs.io/guides/guides/install/).

### Pharo 8 without GToolkit support

Execute the following lines in a playground:

```
Metacello new
    baseline: 'IPFS';
    repository: 'github://khinsen/ipfs-pharo/src';
    load.
```

### Pharo 8 with GToolkit support

The GToolkit add-on is strongly recommended, as it contains everything you need to explore IPFS: inspector views for everything, and a tutorial accessible from the World menu. There are two ways to install IPFS with GToolkit support, involving different trade-offs:

1. In a plain Pharo 8 image, execute the following lines in a playground:

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

This will first install GToolkit, and then the IPFS package. Since GToolkit is rather big, be prepared for a lengthy installation. Note also that GToolkit installed on top of a standard Pharo 8 image cannot use its native windows, so you will see GToolkit inside Morphic. For native windows (nicer and faster), choose method 2 below.

2. In a pre-built GToolkit installation (from [this site](https://gtoolkit.com/install/)), execute the following lines in a playground:

```
Metacello new
    baseline: 'IPFSForGToolkit';
    repository: 'github://khinsen/ipfs-pharo/src';
	 onConflictUseLoaded;
    load.
```


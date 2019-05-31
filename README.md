# ipfs-pharo

An IPFS interface for Pharo

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
Metacello new
    baseline: 'IPFS';
    repository: 'github://khinsen/ipfs-pharo/src';
    load: 'All'.
```

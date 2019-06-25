"
!A practical introduction to IPFS

IPFS (Inter-Planetary File System) is a distributed content-addressable store for arbitrary data. Let's see what that means in practice.

!!IPFS at the block level

At its most fundamental layer, IPFS organizes data in ''blocks''. A block is simply a sequence of bytes, conveniently represented in Pharo as a ${class:name=ByteArray}$. Assuming you have an IPFS daemon running on your computer (""ipfs daemon"" if you use the *reference implementation go-ipfs>https://docs.ipfs.io/guides/guides/install/*), you can create an IPFS block like this:
${example:name=IpfsExamples>>#rawBlockCid|expanded=}$

What you get back in return is a ''content identifier'' or CID. Using the CID you can retrieve the block back from IPFS:
${example:name=IpfsExamples>>#loadRawBlock|expanded=}$

The defining feature of content-addressable storage is that the CID is not a name chosen by someone, nor a randomly generated string. It is computed from the data itself via a ''hash function''. If you have inspected the result of the first example, you may have noticed the ""hash function"" with value ""sha2-256"". That's the default hash function that IPFS uses today. But IPFS also stores the hash function name (encoded) as part of the CID so that other hash functions can be used. One reason is the possibility to use CIDs for data in other formats (e.g. git commits). Another reason is future-proofing: if sha2 ever becomes too easy to crack, IPFS can switch to a different hash function. For the same reason, the CID contains the length of the hash. It is in fact encoded ''before'' the hash itself so that programs know how long the CID actually is!

Identifying data by a hash derived from its contents has two major advantages. First, it makes it easy to verify that the data you obtain by following the reference is correct. The reference is the hash, so once you have download the data, you can recompute the hash and compare. With named references, error or malevolent manipulation can lead to the receiver getting different data than the sender intended. Second, a piece of data always has the same hash, no matter when and where it is handled. If you file the data under its hash, you will never have two copies of the same data. That's why IPFS can claim ""automatic deduplication"".

There is one more piece of information in the CID that we will exploit shortly: the ''codec''. It defines how the bytes in the block are to be interpreted. In the example, the codec is ''raw'', meaning that there is no encoding. As far as IPFS is concerned, it's just bytes.

But how do we know that our byte array has really been stored in IPFS? One way to check is to inspect it in your Web browser:
${example:name=IpfsExamples>>#openRawBlockInLocalWebExplorer|expanded=}$

Of course this only shows that the data is accessible outside of Pharo. Your Web browser still retrieves it from the same local IPFS server that Pharo also connects to. Your data ''should'' be accessible from all over the world, right? To check that this is true, you have to access it from another computer. You can do that via a public Web-based explorer:
${example:name=IpfsExamples>>#urlForExploringRawBlockInRemoteWebExplorer|expanded=}$

Paste the URL you get from the this code into a Web browser that runs ''on another computer'' - a phone or tablet will do. If you use a browser on the same computer that runs your IPFS server, the JavaScript code for the explorer will detect that server and use it, so you have proved nothing.

!!Pinning

Any data to store in IPFS exists initially only on your computer. When some other computer looks for it by its CID, it asks other IPFS peers it happens to know if they have the data, and if not, if they can get it from someone else. Ultimately it's your computer that will be contacted, and send the data to whoever requested it. The IPFS peers involved in the transaction may or may not store a copy, and keep it for however long they like, but you cannot rely on anything. When your computer goes offline, the data stored on it disappears from IPFS. That doesn't sound good.

It's actually worse than that. Even your friendly local IPFS server doesn't keep all your data forever. When it runs out of storage, or when it is asked to do a garbage collection, it will happily throw it away. Except if you have told it that that particular piece of data is important and that you want to keep it until further notice. This process is called ''pinning''. Let's see it in action.

First, we need a handle on the local IPFS Peer on our computer:
${example:name=IpfsExamples>>#localIpfsPeer|expanded=}$

We can then ask it for lots of interesting information. For example, the list of all CIDs whose data it has in local storage:
${example:name=IpfsExamples>>#allCidsOnlocalIpfsPeer|expanded=}$

We can thus verify that a piece of data we have stored is actually present in the storage of our local IPFS peer:
${example:name=IpfsExamples>>#storeDataAndCheckItsPresenceOnLocalPeer|expanded=}$

Next, we can do a garbage collection and check that our data has disappeared:
${example:name=IpfsExamples>>#storeDataAndCheckItsAbsenceAfterGarbageCollection|expanded=}$

This confirms that unpinned data is rather volatile. Let's pin it and check that it survives garbage collection:
${example:name=IpfsExamples>>#storeDataPinAndCheckItsPresenceAfterGarbageCollection|expanded=}$

As a final test, let's pin and then unpin the data, and make sure that it is gone after garbage collection:
${example:name=IpfsExamples>>#storeDataPinUnpinAndCheckItsAbsenceAfterGarbageCollection|expanded=}$

There remains a practical question: what if your local IPFS peer is not online permanently, but you want to make some data available at any time? The answer is that you need to pin it on some other IPFS peer, one that ''is'' always available. No need to send it over first - it will retrieve the data by itself when you ask it to pin a CID. Note however that pinning data has a cost in terms of resources (storage, bandwidth, and a bit of CPU time). Just like storing data on a traditional Web server, in fact. There are a few commercial IPFS pinning services (a Web search will find them easily) that you can turn to.

So far for part 1 of the tutorial. Part 2 is just one click away. It will be loaded via IPFS, so opening it might take a while. Ready? Then ${ipfs:path=/ipns/QmUmdPx5oXB1rNya1RATN5abWJhpzhmJgk5v8W9fUDZqa3/part2|name=click here}$.

"
Class {
	#name : #IpfsTutorial,
	#superclass : #Object,
	#category : #'IPFS-GToolkit'
}

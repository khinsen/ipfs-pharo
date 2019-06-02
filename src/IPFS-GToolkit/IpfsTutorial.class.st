"
!An introduction to IPFS

IPFS is a distributes content-addressable store for arbitrary data. Let's see how this works in practice.

!!IPFS at the block level

At its most fundamental layer, IPFS organizes data in ''blocks''. A block is simply a sequence of bytes, conveniently represented in Pharo as a ${class:name=ByteArray}$. Assuming you have an IPFS daemon running on your computer (""ipfs daemon"" if you use the *reference implementation>https://docs.ipfs.io/guides/guides/install/*), you can create an IPFS block like this:
${example:name=IpfsExamples>>#rawBlockCid|expanded=}$

What you get back in return is a ''content identifier'' or CID. Using the CID you can retrieve the block back from IPFS:
${example:name=IpfsExamples>>#loadRawBlock|expanded=}$

The defining feature of content-addressable storage is that the CID is not assigned by some authority, or chosen at random, but computed from the data itself via a ''hash function''. If you have inspected the result of the first example, you may have noticed the ""hash function"" with value ""sha2-256"". That's the default hash function that IPFS uses today. But IPFS also stores the hash function name (encoded) as part of the CID so that other hash functions can be used as well. One reason is  the possibility to use CIDs for data in other formats (e.g. git commits). Another reason is future-proofing: if sha2 ever becomes easy to crack, IPFS can switch to a different hash function. For the same reason, the CID contains the length of the hash. It is in fact encoded ''before'' the hash itself so that programs now how long the CID actually is!

There is one more piece of information in the CID that we will exploit shortly: the ''codec''. It defines how the bytes in the block are to be interpreted. In the example, the codec is ''raw'', meaning that there is no encoding. As far as IPFS is concerned, it's just bytes.

But how do we know that our byte array has really been stored in IPFS? One way to check is to inspect it in your Web browser:
${example:name=IpfsExamples>>#openRawBlockInLocalWebExplorer|expanded=}$

But this only shows that the data is accessible outside of Pharo. Your Web browser still retrieves it from the same local IPFS server that Pharo also connects to. Your data ''should'' be accessible from all over the world, right? You can check by installing IPFS on another computer, and opening the same URL there. It could take some time for that other machine to obtain the data (which it ends up requesting from your computer, so don't turn it off!), but the results shown should be the same.

Unfortunately, you cannot simply retrieve the data via a public IPFS gateway (such as *http://ipfs.io/*), because these gateways operate at the file level, not the raw block level.





















































"
Class {
	#name : #IpfsTutorial,
	#superclass : #Object,
	#category : #'IPFS-GToolkit'
}

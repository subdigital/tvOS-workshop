/*
Copyright (C) 2016 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This function handles presenting the Slideshow API example.
*/

function SlideshowController(documentLoader, imageURLsString) {
	const imageURLs = imageURLsString.split(/\s+/).map(documentLoader.prepareURL);
	Slideshow.start(imageURLs, { showSettings: false });
}

// Prevent the DocumentController to display loadingTemplate
SlideshowController.preventLoadingDocument = true;

registerAttributeName("slideshowImageURLs", SlideshowController);

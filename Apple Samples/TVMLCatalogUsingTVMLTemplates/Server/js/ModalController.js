/*
Copyright (C) 2016 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This class handles presenting the Alert template examples.
*/

class ModalController extends DocumentController {

	handleDocument(document) {
		navigationDocument.presentModal(document);
	}

	handleEvent(event) {
    	navigationDocument.dismissModal();
	}

}

// Prevent parent DocumentController from displaying the loadingTemplate
ModalController.preventLoadingDocument = true;

registerAttributeName('modalDocumentURL', ModalController);

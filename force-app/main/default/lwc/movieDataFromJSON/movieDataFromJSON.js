import { LightningElement, api, wire, track } from 'lwc';
import processMovieData from '@salesforce/apex/ParsingMovieInJson.ParseMovie';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MovieDataUploader extends LightningElement {
    @api docId;

    handleUploadFinished(event) {
        const uploadedFile = event.detail.files[0];
        this.docId = uploadedFile.contentVersionId;

        processMovieData({ documentId: this.docId })
            .then(result => {
                const toastEvent = new ShowToastEvent({
                    title: 'Success',
                    message: `Records loaded: ${result.recordsLoaded}`,
                    variant: 'success',
                });
                this.dispatchEvent(toastEvent);
            })
            .catch(error => {
                console.error(error); // Log the error to the console for debugging
                const errorMessage = error.body.message || 'Unknown error occurred';
                const toastEvent = new ShowToastEvent({
                    title: 'Error',
                    message: `An error occurred: ${errorMessage}`,
                    variant: 'error',
                });
                this.dispatchEvent(toastEvent);
            });
    }
}
import { LightningElement, api, wire } from 'lwc';
import getMovieByTitle from '@salesforce/apex/tmdb.getMovieByTitle';
import getMoviesPosterURL from '@salesforce/apex/ApexController.getMoviesPosterURL';
import modifyMovie from '@salesforce/apex/tmdb.getModifyMovie';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class movieAutoFillFromTMDB extends LightningElement {
    @api recordId;
    @wire(getMoviesPosterURL, { movieId: '$recordId' }) currentMovie;
    @wire(getMovieByTitle, {title : '$currentMovie.data.Title__c'}) result;
    
    
    handleMovieButtonClick(event) {
        const movieId = event.target.getAttribute('data-id');
        window.console.log('TMDBID: ',this.currentMovie.data.tmdbId__c);
        if (this.currentMovie.data.tmdbId__c != null) {
            this.showToast('ERROR', 'Data is already copied from Movie DB', 'info');
        } else {
            modifyMovie({ tmdbid: movieId, currentMovieId: this.recordId })
                .then(result => {
                    window.console.log('Method executed successfully', result);
                })
                .catch(error => {
                    window.console.error('Error executing method', error);
                });
                location.reload();
        }
    }

    // Define a method to show toast messages
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
    renderedCallback(){
        window.console.log(this.result);
        window.console.log(this.movie);
    }

}
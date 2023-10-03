import { LightningElement, api, wire } from 'lwc';
import getMoviesPosterURL from '@salesforce/apex/ApexController.getMoviesPosterURL';

export default class MovieList extends LightningElement {
    @api recordId;
    @wire(getMoviesPosterURL, { movieId: '$recordId' }) movie;

    connectedCallback() {
        console.log('Record ID:', this.recordId);
        console.log('Movie Data:', this.movie);
    }
}
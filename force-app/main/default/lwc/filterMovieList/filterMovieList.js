import { LightningElement, wire } from 'lwc';
import processGenrePicklistValues from '@salesforce/apex/ApexController.processGenrePicklistValues';
// import displayedMoviesByGenre from '@salesforce/apex/ApexController.displayedMoviesByGenre';

export default class FilterMovieList extends LightningElement {
    @wire(processGenrePicklistValues) genres;
    selectedValue ='huba buba';
    handlePicklistChange(event) {
        const selectedValue = event.target.value;
        window.console.log('Selected Value:', selectedValue);
        // displayedMoviesByGenre(selectedValue);
    }

    connectedCallback(){
        window.console.log(this.genres.data);
    }
}
import { LightningElement, api, wire } from 'lwc';
import displayedMovies from '@salesforce/apex/ApexController.displayedMovies';
import processGenrePicklistValues from '@salesforce/apex/ApexController.processGenrePicklistValues';


export default class movieList extends LightningElement {
    selectedGenre = '';
    @wire(displayedMovies, {genre: '$selectedGenre'}) moviesToDisplay;
    @wire(processGenrePicklistValues) genres;

    handlePicklistChange(event) {
        const selectedValue = event.target.value;
        this.selectedGenre = selectedValue;
        

    }
    connectedCallback() {
            window.console.log('THE ARRAY:', this.moviesToDisplay.data);
            // window.console.log('SELECTED VALUES PASSED TO MOVIELIST CLASSSSSS', this.selectedValue);    
    }
    }
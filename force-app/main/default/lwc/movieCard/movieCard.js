import { LightningElement, api } from 'lwc';

export default class movieCard extends LightningElement {
    @api movie;
    @api movieId;

    connectedCallback() {
        console.log('Record ID:', this.recordId);
        console.log('Movie Data:', this.movie);
    }

    goToDetails() {
        const targetPageUrl = `https://ideaportriga8-dev-ed.develop.lightning.force.com/lightning/r/Movie__c/${this.movie.Id}/view`;
        window.location.href = targetPageUrl;
    }
    renderedCallback() {
        const button = this.template.querySelector('.details-button');
        button.addEventListener("click", this.goToDetails.bind(this));
    }

}
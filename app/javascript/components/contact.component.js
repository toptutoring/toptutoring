import React from 'react';
import phoneIcon from '../../assets/images/phone-white.png';

export class Contact extends React.Component {
    constructor() {
        super();
    }

    validateForm() {
        this.props.updateForm({
            nameValid: !!this.props.contact.name.length,
            telValid: !!this.props.contact.tel.length,
            formValid: !!this.props.contact.name.length && !!this.props.contact.tel.length
        });
    }

    updateField(type, value) {
        const nameValid = type === 'name' ? true : this.props.contact.nameValid;
        const telValid = type === 'tel' ? true : this.props.contact.telValid
        this.props.updateForm({
            [type]: value,
            nameValid,
            telValid,
            formValid: nameValid && telValid
        });
    }

    render() {
        const classes = `contact ${this.props.isMobile ? 'mobile' : ''}`;
        const errors = this.props.contact.formValid === false ?
            <div className="invalid">* required</div> : '';
        
        return (
            <div className={classes}>
                <span className="phone-number">
                    <a href="tel:5108425221">
                        <img className="icon" src={phoneIcon} />
                        Call (510) 842-5221
                    </a>
                </span>
                <div className="contact-form">
                    <span className="contact-header">Contact us</span>
                    <input className={!this.props.contact.nameValid ? 'invalid' : ''} placeholder="Name*" type="text" value={this.props.contact.name} onChange={event => this.updateField('name', event.target.value)}/>
                    <input className={!this.props.contact.telValid ? 'invalid' : ''} placeholder="Phone*" type="tel" value={this.props.contact.tel} onChange={event => this.updateField('tel', event.target.value)} />
                    <input placeholder="Email" type="email" value={this.props.contact.email} onChange={event => this.updateField('email', event.target.value)} />
                    {errors}
                    <button onClick={() => this.validateForm()}>Submit</button>
                </div>
            </div>
        );
    }
}
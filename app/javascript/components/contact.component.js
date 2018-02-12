import React from 'react';
import phoneIcon from '../../assets/images/phone-white.png';

export class Contact extends React.Component {

    render() {
        const classes = `contact ${this.props.isMobile ? 'mobile' : ''}`;
        
        return (
            <div className={classes}>
                <span className="phone-number">
                    <img className="icon" src={phoneIcon} />
                    Call (510) 842-5221
                </span>
                <div className="contact-form">
                    <span className="contact-header">Contact us</span>
                    <input placeholder="Name*" />
                    <input placeholder="Phone*" />
                    <input placeholder="Email" />
                    <button>Submit</button>
                </div>
            </div>
        );
    }
}
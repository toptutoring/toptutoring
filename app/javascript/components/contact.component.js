import React from 'react';

export class Contact extends React.Component {

    render() {
        return (
            <div className={this.props.isContactExpanded ? 'contact' : 'contact collapsed'}>
                <span className="phone-number">Call (510) 842-5221</span>
                <div className="contact-form">
                    <span className="contact-header">Or hear back from us</span>
                    <input placeholder="Name" />
                    <input placeholder="Phone" />
                    <input placeholder="Email" />
                    <button>Continue</button>
                </div>
            </div>
        );
    }
}
import React from 'react';
import { Contact } from './contact.component';
import { ContactNav } from './contact-nav.component';

export class Home extends React.Component {
    handleScroll = (event) => this.setContactLayout(event.target.documentElement.scrollTop);
    handleResize = () => this.setMobileLayout(window.document.body.clientWidth);

    constructor() {
        super();
        this.state = { isContactExpanded: true, isMobile: false };
    }

    componentDidMount() {
        window.addEventListener('scroll', this.handleScroll);
        window.addEventListener('resize', this.handleResize);
        this.setMobileLayout(window.document.body.clientWidth);
    }

    componentWillUnmount() {
        window.removeEventListener('scroll', this.handleScroll);
        window.removeEventListener('resize', this.handleResize);
    }
    render() {
        const contact = this.state.isMobile ? <Contact isMobile={true}/> :
            (this.state.isContactExpanded ? <Contact isMobile={false}/> : '');
        const contactNav = this.state.isMobile ? '' :
            <ContactNav isContactExpanded={this.state.isContactExpanded}/>;

        return (
            <div>
                {contactNav}
                {contact}
                <div className="react-container-content"></div>
            </div>

        )
    }

    setContactLayout(scrollTop) {
        if (scrollTop > 100 && this.state.isContactExpanded) {
            this.setState({ isContactExpanded: false });
        } else if (scrollTop <= 100 && !this.state.isContactExpanded) {
            this.setState({ isContactExpanded: true });
        }
    }

    setMobileLayout(width) {
        if (width < 991 && !this.state.isMobile) {
            this.setState({ isMobile: true });
        } else if (width >= 991 && this.state.isMobile) {
            this.setState({ isMobile: false });
        }
    }
}
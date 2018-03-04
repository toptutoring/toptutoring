import React from 'react';
import { Contact } from './contact.component';
import { createStore } from 'redux'
import contactApp from '../reducers/contact.reducer';
import { updateContact, toggleIsContactCollapsed, toggleIsMobile } from '../actions/contact.actions';

const store = createStore(contactApp);

export class Home extends React.Component {
    storeSubscription;
    handleScroll = (event) => this.setContactLayout(event.target.documentElement.scrollTop);
    handleResize = () => this.setMobileLayout(window.document.body.clientWidth);
    collapsePoint = 400;

    constructor() {
        super();
        this.state = store.getState();
        this.storeSubscription = store.subscribe(() => {
            this.setState(store.getState());
        });
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
        const contactOnPage =
            <Contact 
                position={this.state.isMobile ? 'mobile' : ''}
                contact={this.state.contact}
                updateForm={contact => this.updateContact(contact)}
            />;
        const contactOnTop = this.state.isMobile || this.state.isContactCollapsed === undefined ? '' :
            <Contact 
                position={`collapsed ${this.state.isContactCollapsed ? 'slide-down' : 'slide-up'}`}
                contact={this.state.contact}
                updateForm={contact => this.updateContact(contact)}
            />;

        return (
            <div>
                {contactOnTop}
                {contactOnPage}
                <div className="home-content"></div>
            </div>

        )
    }

    updateContact(contact) {
        store.dispatch(updateContact(contact));
    }

    setContactLayout(scrollTop) {
        const firstRender = this.state.isContactCollapsed === undefined;
        if (scrollTop > this.collapsePoint && (firstRender || !this.state.isContactCollapsed)) {
            store.dispatch(toggleIsContactCollapsed(true));
        } else if (scrollTop <= this.collapsePoint && !firstRender && this.state.isContactCollapsed) {
            store.dispatch(toggleIsContactCollapsed(false));
        }
    }

    setMobileLayout(width) {
        if (width < 991 && !this.state.isMobile) {
            store.dispatch(toggleIsMobile(true));
        } else if (width >= 991 && this.state.isMobile) {
            store.dispatch(toggleIsMobile(false));
        }
    }
}
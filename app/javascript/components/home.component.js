import React from 'react';
import { Contact } from './contact.component';

export class Home extends React.Component {
    handleScroll = (event) => this.setContactLayout(event.target.documentElement.scrollTop);

    constructor() {
        super();
        this.state = { isContactExpanded: true };
    }

    componentDidMount() {
        window.addEventListener('scroll', this.handleScroll);
    }

    componentWillUnmount() {
        window.removeEventListener('scroll', this.handleScroll);
    }
    render() {
        return (
            <div>
                <Contact isContactExpanded={this.state.isContactExpanded}/>
                <div className="react-container-content"></div>
            </div>
        )
    }

    setContactLayout(scrollTop) {
        if (scrollTop > 100 && this.state.isContactExpanded) {
            this.setState({ isContactExpanded: false});
        } else if (scrollTop <= 100 && !this.state.isContactExpanded) {
            this.setState({ isContactExpanded: true});
        }
    }
}
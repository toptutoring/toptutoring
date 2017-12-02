import React from 'react';
import { render } from 'react-dom';

export default class Subject extends React.Component {
  constructor(props) {
    super(props);
    this.handleClick = this.handleClick.bind(this);
    this.state = props.subject;
  };

  handleClick(tutoringType) { 
    let token = $('meta[name=csrf-token]').attr('content')
    $.ajax({
      url: ('/admin/subjects/' + this.state.id + "?&authenticity_token=" + token),
      type: 'PATCH', 
      data: { subject: { tutoring_type: tutoringType } },
      success: (response) => { 
        this.setState({ tutoring_type: tutoringType });
        console.log(response.message);
      }
    });
  }

  tutoringTypeButtons() {
    if (this.state.tutoring_type == "academic") {
      return (
        <td>
        <button className="btn btn-primary" disabled="true">Academic</button>
        <button className="btn btn-outline btn-success" onClick={() => this.handleClick("test_prep")}>Test Prep</button>
        </td>
      );
    } else {
      return (
        <td>
        <button className="btn btn-outline btn-primary" onClick={() => this.handleClick("academic")}>Academic</button>
        <button className="btn btn-success" disabled="true">Test Prep</button>
        </td>
      );
    }
  };

  render() {
    return (
      <tr>
        <td>{ this.state.name }</td>
        { this.tutoringTypeButtons() }
      </tr>
    );
  }
};


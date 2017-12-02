import React from 'react';
import { render } from 'react-dom';
import Subject from '../components/subject_component';

export default class SubjectTable extends React.Component {
  constructor(props) {
    super(props);
    this.state = props;
  }
  render() {
    let subjects = this.state.subjects
    let subjectComponents = () => {
      // maps each subject into a component and adds id of the subject as key
      return Object.keys(subjects).map(key => <Subject key={subjects[key].id} subject={subjects[key]}/>);
    }

    return (
      // most of this html can live in the actual dom since it does not have to be dynamically rendered
      <div className="row">
        <div className="col-sm-12">
          <div className="widget">
            <div className="widget-heading clearfix">
              <h3 className="widget-title pull-left">Subjects</h3>
            </div>
            <div className="widget-body">
              <div className="table-responsive">
                <table className="table mb-0 table-striped table-hover">
                  <thead>
                    <tr>
                      <th>Subject Name</th>
                      <th>Tutoring Type</th>
                    </tr>
                  </thead>
                  <tbody>
                    { subjectComponents() }
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
};

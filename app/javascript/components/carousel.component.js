import React from "react";
import Slider from "react-slick";

export class Carousel extends React.Component {
  render() {
    var settings = {
    };
    return (
      <Slider {...settings}>
        <div>
          <p className="lead">I was looking for a good Chemistry teacher for my son. I gave Top Tutoring a try, and do not regret it one bit. They were very fast in matching a good teacher with my requirements. After few classes my sons grades improved and encouraged by this experience we hired another tutor for another subject through this service. </p>
          <div className="quote-author">
            <div className="icon-container pull-left">
              <i className="ti-user"></i>
            </div>
            <h6 className="uppercase">Pragya S.</h6>
            <span>Parent</span>
          </div>
        </div>
        <div>
          <p className="lead">Smart, patient, professional, knowledgeable, and passionate tutors! They taught both of my kids Math, English, old and new SAT, and also helped them in writing excellent and effective college application essay. I would hire them again without hesitation. Highly recommended!</p>
          <div className="quote-author">
            <div className="icon-container pull-left">
              <i className="ti-user"></i>
            </div>
            <h6 className="uppercase">Gary C.</h6>
            <span>Parent</span>
          </div>
        </div>
        <div>
          <p className="lead">...he was really good at explaining all the concepts. He knew what he was doing and made it fun and easy to understand. I did well on my SATs and got into UC Berkeley.&nbsp;</p>
          <div className="quote-author">
            <div className="icon-container pull-left">
              <i className="ti-user"></i>
            </div>
            <h6 className="uppercase">Ashley K.</h6>
            <span>Student</span>
          </div>
        </div>
      </Slider>
    );
  }
}

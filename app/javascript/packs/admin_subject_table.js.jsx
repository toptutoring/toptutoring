import React from "react";
import { render } from "react-dom";
import SubjectTable from "../components/subject_table_component";

document.addEventListener("DOMContentLoaded", () => {
  // container identifies the div in the html to put the element into
  const container = document.getElementById("root");

  // finds the activerecord data formatted to json
  const node = document.getElementById("subjects")
  const data = JSON.parse(node.getAttribute("data")) 

  // standard React mounting that seneds subjects data to the component
  render(<SubjectTable subjects={data} />, container);
});

import {
    updateContact, toggleIsContactCollapsed, toggleIsMobile
} from '../actions/contact.actions';
  
  const initialState = {
      contact: {
        name: '',
        tel: '',
        email: '',
        nameValid: undefined,
        telValid: undefined,
        formValid: undefined
      },
      isContactCollapsed: undefined,
      isMobile: false
  };
  
  function contactApp(state = initialState, action) {
    switch (action.type) {
        case ('UPDATE_CONTACT'): {
            return { ...state, contact: { ...state.contact, ...action.payload } };
        }
        case ('TOGGLE_IS_MOBILE'): {
            return { ...state, isMobile: action.payload };
        }
        case ('TOGGLE_IS_CONTACT_EXPANDED'): {
            return { ...state, isContactCollapsed: action.payload };
        }
        default:
            return state;
    }
  }
  
  export default contactApp;
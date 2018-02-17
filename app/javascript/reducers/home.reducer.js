import {
    updateContact, toggleIsContactExpanded, toggleIsMobile
} from '../actions/home.actions';
  
  const initialState = {
      contact: {
        name: '',
        tel: '',
        email: '',
        nameValid: true,
        telValid: true,
        formValid: undefined
      },
      isContactExpanded: undefined,
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
            return { ...state, isContactExpanded: action.payload };
        }
        default:
            return state;
    }
  }
  
  export default contactApp;
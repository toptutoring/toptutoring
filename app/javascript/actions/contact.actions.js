export const UPDATE_CONTACT = 'UPDATE_CONTACT';
export const TOGGLE_IS_MOBILE = 'TOGGLE_IS_MOBILE';
export const TOGGLE_IS_CONTACT_EXPANDED = 'TOGGLE_IS_CONTACT_EXPANDED';

export function updateContact(payload) {
  return { type: UPDATE_CONTACT, payload };
}

export function toggleIsMobile(payload) {
    return { type: TOGGLE_IS_MOBILE, payload };
}

export function toggleIsContactCollapsed(payload) {
    return { type: TOGGLE_IS_CONTACT_EXPANDED, payload };
}




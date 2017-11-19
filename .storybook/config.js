import { configure } from '@storybook/react'
import styleHref from './style_href.js.erb'

function insertLinkTag(href) {
  const head = document.head

  const link = document.createElement('link')
  link.rel = 'stylesheet'
  link.type = 'text/css'
  link.href = href

  head.appendChild(link)
}

function loadStories() {
  insertLinkTag(styleHref)
  require('./stories/buttons');
}

configure(loadStories, module)

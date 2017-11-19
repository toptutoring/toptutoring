import React from 'react'
import { storiesOf } from '@storybook/react'
import Button from 'components/button'

storiesOf('Buttons', module)
  .add('Generic Button', () => (
    <Button buttonText="I am so le'general" />
  ))

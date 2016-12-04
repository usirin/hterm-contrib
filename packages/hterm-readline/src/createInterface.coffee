import { assign } from 'lodash'
import InputStream from './HtermInputStream'
import OutputStream from './HtermOutputStream'
import ReadlineInterface from './ReadlineInterface'
import decorateStreams from './decorateStreams'

export default createInterface = (options) ->

  { term, input, output } = options

  if input and output
    options = assign {}, options, decorateStreams { input, output }
    return new ReadlineInterface options

  unless term
    throw new Error 'You need to set a hterm.Terminal.'

  options = assign {}, options, decorateStreams
    input: new InputStream term.io
    output: new OutputStream term.io

  return new ReadlineInterface options



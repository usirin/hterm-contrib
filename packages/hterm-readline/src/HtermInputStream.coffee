import { Readable } from 'stream'
import ansiEscapes from 'ansi-escapes'

ESC      = '\u001b['
UP       = "#{ESC}A"
DOWN     = "#{ESC}B"
FORWARD  = "#{ESC}C"
BACKWARD = "#{ESC}D"

export default class HtermInputStream extends Readable

  constructor: (io) ->
    @io = io
    @_data = ''
    super

  _read: ->
    @io.onVTKeystroke = @io.sendString = (str) =>
      str = switch str
        when UP then ansiEscapes.cursorUp()
        when DOWN then ansiEscapes.cursorDown()
        when FORWARD then ansiEscapes.cursorForward()
        when BACKWARD then ansiEscapes.cursorBackward()
        else str

      @_data += str
      @push str

  pause: ->
    super
    @emit 'pause'

  resume: ->
    super
    @emit 'resume'



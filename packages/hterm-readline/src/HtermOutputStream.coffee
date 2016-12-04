import { Writable } from 'stream'

export default class HtermOutputStream extends Writable

  constructor: (io) ->
    @io = io
    super

  _write: (data, enc, next) ->
    @io.writeUTF8 data.toString()
    next()


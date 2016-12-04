import LineInputStream from 'line-input-stream'
import MuteStream from 'mute-stream'

export default decorateStreams = ({ input, output }) ->
  res = {}

  if input
    res.input = LineInputStream input

  if output
    ms = new MuteStream
    ms.pipe output
    res.output = ms

  return res


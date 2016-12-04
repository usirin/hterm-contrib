import InputStream from './HtermInputStream'
import OutputStream from './HtermOutputStream'
import ReadlineInterface from './ReadlineInterface'
import createInterface from './createInterface'

export { InputStream }
export { OutputStream }
export { ReadlineInterface as Interface }
export { createInterface }

defaultExport = {
  createInterface
  Interface: ReadlineInterface
  InputStream
  OutputStream
  moveCursor: ReadlineInterface.moveCursor
}

export default defaultExport

module.exports = defaultExport


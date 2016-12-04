import Command from './BaseCommand'
export { Command }

import patchHterm from './patch-hterm'
export { patchHterm }

defaultExport = {
  Command, patchHterm
}

export default defaultExport

module.exports = defaultExport

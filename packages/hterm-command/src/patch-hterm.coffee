import { assign } from 'lodash'

export default patchHterm = (hterm) ->
  { Terminal } = hterm

  class PatchedTerminal extends Terminal

    # 1st difference: accept 3rd argument (config)
    runCommandClass: (Command, argString, config = {}) ->
      environment = @prefs_.get 'environment'
      unless isObject environment
        environment = {}

      # 2nd difference: pass (config) as 2nd arg directly
      @command = new Command
        io: @io.push()
        argString: argString
        environment: environment
        onExit: (code) => @io.pop()
      , config

      # the result. this allows chaining.
      return @command.run()


  extensions =
    Terminal: PatchedTerminal

  return assign {}, hterm, extensions


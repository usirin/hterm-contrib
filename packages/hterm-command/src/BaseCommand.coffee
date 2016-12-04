import { isFunction } from 'lodash'
import { InputStream, OutputStream } from 'hterm-readline'
import minimist from 'minimist'

parseArgs = (str) -> minimist str.split(' ').map (arg) -> arg.trim()

export default class BaseCommand

  constructor: (options, config = {}) ->

    @options_ = options

    @argv_ = parseArgs options.argString

    @environment_ = options.environment or {}

    @io_ = options.io

    @exited_ = no

    @rl_ = config.rl


  run: ->
    input = new InputStream @io_
    output = new OutputStream @io_

    result = @run_(input, output)

    if isFunction result?.then
      return result.then @bound 'exit'

    @exit result


  run_: -> throw new Error "commands should implement run_"

  exit: (code) ->
    @exited_ = yes
    @options_.onExit(code)
    return Promise.resolve code


  bound: (method) -> this[method].bind this



import readline, { InputStream, OutputStream } from 'hterm-readline'
import { Command } from 'hterm-command'
import { assign } from 'lodash'
import minimist from 'minimist'
import chalk from 'chalk'
chalk.enabled = true

export createCmdRegistry = (commands = {}) ->
  return {
    register: (Cmd) -> commands[Cmd.name_] = Cmd
    get: (cmd) -> commands[cmd] ? null
  }

export default class Shell extends Command

  @name_ = 'hterm-sh'

  @commands = createCmdRegistry()

  constructor: (options, config) ->

    super options, config

    @rl_ = null

    @config_ = config


  runCommand: (cmd, argString) ->

    Cmd = Shell.commands.get cmd

    unless Cmd
      @rl_.output.write "#{chalk.bold.red "error:"} command not found: '#{cmd}'\n"
      return @rl_.prompt()

    config = assign {}, @config_, { rl: @rl_ }

    return runCommand(@io_, Cmd, argString, config).then (args...) =>
      @config_.onCommand { cmd, argString }, args...
      @rl_.prompt()


  onLine: (line) ->

    { cmd, argString } = parseLine line

    @runCommand cmd, argString


  run_: ->

    @rl_ = createReadline @io_, @argv_.prompt
    @rl_.on 'line', @bound 'onLine'

    return new Promise (resolve) =>
      @rl_.on 'close', resolve
      @rl_.prompt()


export createReadline = (io, prompt) ->

  input = new InputStream io
  output = new OutputStream io

  if prompt.trim() is prompt then prompt += ' '

  rl = readline.createInterface { input, output, prompt }

export parseLine = (line) ->
  [cmd, argv...] = line.split(' ').map (arg) -> arg.trim()

  return {
    cmd: cmd
    argString: argv.join ' '
  }

export runCommand = (io, Command, argString, config) ->
  io.terminal_.runCommandClass(
    Command, argString, config
  )


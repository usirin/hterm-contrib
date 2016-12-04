import Input from 'inquirer/lib/prompts/input'
import List from 'inquirer/lib/prompts/list'
import Expand from 'inquirer/lib/prompts/expand'
import Password from 'inquirer/lib/prompts/password'

import PromptUI from './ui/Prompt'

export createPrompt = ({ term, input, output, rl }) ->

  prompts =
    input: Input
    list: List
    expand: Expand
    password: Password

  uiOptions = switch
    when rl then { rl }
    when input and output then { input, output }
    when term then { term }
    else { }

  ui = new PromptUI prompts, uiOptions

  return (questions) -> ui.run(questions)

defaultExport = { createPrompt }

export default defaultExport

module.exports = defaultExport

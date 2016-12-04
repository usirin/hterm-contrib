import { EventEmitter } from 'events'
import { isPlainObject, isArray, isFunction, set, clone } from 'lodash'
import { Observable } from 'rx'
import runAsync from 'run-async'

import { createInterface } from 'hterm-readline'

# port of Inquirer.js prompt ui
# see https://github.com/SBoudrias/Inquirer.js/blob/master/lib/ui/prompt.js
export default class PromptUI extends EventEmitter

  constructor: (prompts, options) ->
    @prompts = prompts
    @rl = options.rl or createInterface options

  run: (questions) ->

    @answers = {}
    questions = [questions]  if isPlainObject questions
    obs = if isArray questions
    then Observable.from questions
    else questions

    @process = obs
      .concatMap @processQuestion.bind this
      .publish()

    @process.connect()

    reduce = (_, { name, answer }) =>
      set(@answers, name, answer)
      return @answers

    return @process
      .reduce(reduce, @answers)
      .toPromise Promise
      .then @onCompletion.bind this


  onCompletion: (answers) ->
    @close?()
    return answers


  processQuestion: (q) ->
    q = clone(q)
    return Observable.defer =>
      Observable.of q
        .concatMap @setDefaultType.bind this
        .concatMap @filterIfRunnable.bind this
        .concatMap fetchAsyncQuestionProp.bind null, q, 'message', @answers
        .concatMap fetchAsyncQuestionProp.bind null, q, 'default', @answers
        .concatMap fetchAsyncQuestionProp.bind null, q, 'choices', @answers
        .concatMap @fetchAnswer.bind this


  setDefaultType: (q) ->

    q.type = 'input'  unless @prompts[q.type]
    Observable.defer -> Observable.return q


  filterIfRunnable: (q) ->

    switch
      when q.when is false then Observable.empty()
      when not isFunction q.when then Observable.return(q)


  fetchAnswer: (q) ->
    prompt = new @prompts[q.type](q, @rl, @answers)

    return Observable.defer ->
      Observable.fromPromise(
        prompt.run().then (ans) -> { name: q.name, answer: ans }
      )


fetchAsyncQuestionProp = (q, prop, answers) ->

  return Observable.return q  unless isFunction q[prop]

  promise = runAsync(q[prop])(answers)
    .then (answer) ->
      q[prop] = answer
      return q

  return Observable.fromPromise(promise)



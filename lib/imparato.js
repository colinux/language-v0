const { CompositeDisposable } = require('atom')
const toggleLineComment = require('./ToggleLineComment')
const setLineAsChar = require('./LineAsChar')

module.exports = {
  subscriptions: null,

  activate () {
    this.subscriptions = new CompositeDisposable()
    this.subscriptions.add(atom.commands.add('atom-workspace',
      { 'imparato:toggle-line-comment': () => toggleLineComment() })
    )

    this.subscriptions.add(atom.commands.add('atom-workspace',
      { 'imparato:line-as-char': () => setLineAsChar() })
    )
  },

  deactivate () {
    this.subscriptions.dispose()
  }
}

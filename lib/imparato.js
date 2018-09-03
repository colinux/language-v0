const { CompositeDisposable } = require('atom')
const toggleLineComment = require('./ToggleLineComment')
const setLineAsSpeaker = require('./LineAsSpeaker')

module.exports = {
  subscriptions: null,

  activate () {
    this.subscriptions = new CompositeDisposable()
    this.subscriptions.add(atom.commands.add('atom-workspace',
      { 'imparato:toggle-line-comment': () => toggleLineComment() })
    )

    this.subscriptions.add(atom.commands.add('atom-workspace',
      { 'imparato:line-as-speaker': () => setLineAsSpeaker() })
    )
  },

  deactivate () {
    this.subscriptions.dispose()
  }
}

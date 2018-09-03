const { CompositeDisposable } = require('atom')
const toggleLineComment = require('./ToggleLineComment')

module.exports = {
  subscriptions: null,

  activate () {
    this.subscriptions = new CompositeDisposable()
    this.subscriptions.add(atom.commands.add('atom-workspace',
      { 'imparato:toggle-line-comment': () => toggleLineComment() })
    )
  },

  deactivate () {
    this.subscriptions.dispose()
  }
}

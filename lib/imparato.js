const { CompositeDisposable } = require('atom')
const toggleLineAsComment = require('./LineAsComment')

module.exports = {
  subscriptions: null,

  activate () {
    this.subscriptions = new CompositeDisposable()
    this.subscriptions.add(atom.commands.add('atom-workspace',
      {'imparato:line-as-comment': () => toggleLineAsComment() })
    )
  },

  deactivate () {
    this.subscriptions.dispose()
  },
}

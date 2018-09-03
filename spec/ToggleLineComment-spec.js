// If you want an example of language specs, check out:
// https://github.com/atom/language-javascript/blob/master/spec/javascript-spec.coffee
const path = require('path')

const packageName = 'language-v0'
const command = 'imparato:toggle-line-comment'

describe('Toggle Line Comment', () => {
  let editor, buffer, workspaceElement

  beforeEach(() => {
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise(() => {
      const filepath = path.join('replica.v0.txt')
      return atom.workspace.open(filepath).then((e) => {
        editor = e
        buffer = e.getBuffer()
      })
    })

    waitsForPromise(() => {
      return atom.packages.activatePackage(packageName)
    })
  })

  it('enable comment', () => {
    editor.setCursorBufferPosition([1, 0])

    atom.commands.dispatch(workspaceElement, command)

    expect(buffer.getText()).toBe('Spec :\n(Hey)\n(Having lunch)\n')
  })

  it('ignore empty lines', () => {
    editor.setCursorBufferPosition([3, 0])

    atom.commands.dispatch(workspaceElement, command)

    expect(buffer.getText()).toBe('Spec :\nHey\n(Having lunch)\n')
  })

  it('disable comment', () => {
    editor.setCursorBufferPosition([2, 0])

    atom.commands.dispatch(workspaceElement, command)

    expect(buffer.getText()).toBe('Spec :\nHey\nHaving lunch\n')
  })
})

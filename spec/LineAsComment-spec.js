// If you want an example of language specs, check out:
// https://github.com/atom/language-javascript/blob/master/spec/javascript-spec.coffee
const path = require('path')

const packageName = 'language-v0'

describe('Line As Comment', () => {
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

  describe('Toggle as a comment', () => {
    it('enable comment', () => {
      editor.setCursorBufferPosition([1, 0])

      atom.commands.dispatch(workspaceElement, 'imparato:line-as-comment')

      expect(buffer.getText()).toBe("Spec :\n(Hey)\n(Having lunch)\n")
    })

    it('ignore empty lines', () => {
      editor.setCursorBufferPosition([3, 0])

      atom.commands.dispatch(workspaceElement, 'imparato:line-as-comment')

      expect(buffer.getText()).toBe("Spec :\nHey\n(Having lunch)\n")
    })
  })

  describe('Toggle as uncomment', () => {
    it('disable comment', () => {
      editor.setCursorBufferPosition([2, 0])

      atom.commands.dispatch(workspaceElement, 'imparato:line-as-comment')

      expect(buffer.getText()).toBe("Spec :\nHey\nHaving lunch\n")
    })
  })
})

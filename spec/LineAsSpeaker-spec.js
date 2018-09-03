// If you want an example of language specs, check out:
// https://github.com/atom/language-javascript/blob/master/spec/javascript-spec.coffee
const path = require('path')
const temp = require('temp')

const packageName = 'language-v0'
const command = 'imparato:line-as-speaker'

describe('Line As Speaker', () => {
  let editor, buffer, workspaceElement

  beforeEach(() => {
    const directory = temp.mkdirSync()
    atom.project.setPaths([directory])
    workspaceElement = atom.views.getView(atom.workspace)
    const filePath = path.join(directory, 'play.v0.txt')

    atom.workspace.open(filePath).then((e) => {
      editor = e
      buffer = e.getBuffer()
    })

    waitsForPromise(() => {
      return atom.packages.activatePackage(packageName)
    })
  })

  describe('Base behavior', () => {
    beforeEach(() => { editor.insertText('Spec :\nHey\n') })

    it('transform a line as speaker label', () => {
      editor.setCursorBufferPosition([1, 0])

      atom.commands.dispatch(workspaceElement, command)

      expect(buffer.getText()).toBe('Spec :\nHey :\n')
    })

    it('works when cursor is at the middle of the line', () => {
      editor.setCursorBufferPosition([1, 2])

      atom.commands.dispatch(workspaceElement, command)

      expect(buffer.getText()).toBe('Spec :\nHey :\n')
    })

    it('works when cursor is at the end of the line', () => {
      editor.setCursorBufferPosition([1, 5])

      atom.commands.dispatch(workspaceElement, command)

      expect(buffer.getText()).toBe('Spec :\nHey :\n')
    })

    it('ignore empty lines', () => {
      editor.setCursorBufferPosition([2, 0])

      atom.commands.dispatch(workspaceElement, command)

      expect(buffer.getText()).toBe('Spec :\nHey\n')
    })

    it('ignore line already having a speaker', () => {
      editor.setCursorBufferPosition([0, 0])

      atom.commands.dispatch(workspaceElement, command)

      expect(buffer.getText()).toBe('Spec :\nHey\n')
    })
  })

  describe('Trim and space handling', () => {
    it('ensure single space before semi-colon', () => {
      editor.insertText('Spec :\nHey   \n')
      editor.setCursorBufferPosition([1, 0])

      atom.commands.dispatch(workspaceElement, command)

      expect(buffer.getText()).toBe('Spec :\nHey :\n')
    })

    it('normalize spaces for line already being a speaker', () => {
      editor.insertText('Spec   :\nHey\n')
      editor.setCursorBufferPosition([0, 0])

      atom.commands.dispatch(workspaceElement, command)

      expect(buffer.getText()).toBe('Spec :\nHey\n')
    })
  })

  describe('escaped semi-colons', () => {
    it('convert lines ending by escaped semi-colon', () => {
      editor.insertText('Spec :\nHey \\:\n') // eslint-disable-line no-useless-escape
      editor.setCursorBufferPosition([1, 0])

      atom.commands.dispatch(workspaceElement, command)

      expect(buffer.getText()).toBe('Spec :\nHey :\n')
    })
  })

  describe('comments handling', () => {
    it('comment after comma', () => {
      editor.insertText('Spec, crying\nHey\n')
      editor.setCursorBufferPosition([0, 3])

      atom.commands.dispatch(workspaceElement, command)

      expect(buffer.getText()).toBe('Spec (crying) :\nHey\n')
    })

    it('normalize comment in parenthesis', () => {
      editor.insertText('Spec(crying)\nHey\n')
      editor.setCursorBufferPosition([0, 3])

      atom.commands.dispatch(workspaceElement, command)

      expect(buffer.getText()).toBe('Spec (crying) :\nHey\n')
    })

    it('normalize comment in parenthesis for a line already being speaker', () => {
      editor.insertText('Spec(crying):\nHey\n')
      editor.setCursorBufferPosition([0, 3])

      atom.commands.dispatch(workspaceElement, command)

      expect(buffer.getText()).toBe('Spec (crying) :\nHey\n')
    })
  })
})

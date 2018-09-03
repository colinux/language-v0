const commentStart = '('
const commentEnd = ')'

class ToggleLineComment {
  constructor () {
    this.editor = atom.workspace.getActiveTextEditor()

    if (this.editor) {
      this.buffer = this.editor.getBuffer()
    }
  }

  toggle () {
    // Note: we can't use the native toggle Line Comment,
    // because native code insert an hardcoded space before / after the delimiter
    // However the uncomment native code works as we want.

    if (!this.buffer) {
      return
    }

    this.editor.mutateSelectedText((selection, index) => {
      const [start, end] = selection.getBufferRowRange()
      const lineStart = this.buffer.lineForRow(start)
      const lineEnd = this.buffer.lineForRow(end)

      // ignore empty line
      if (lineEnd.length === 0) {
        return
      }

      if (lineStart[0] === commentStart && lineEnd.slice(-1) === commentEnd) {
        this.uncomment(start, end, lineEnd)
        return
      }

      this.comment(start, end)
    })
  }

  uncomment (start, end, lineEnd) {
    this.buffer.transact(() => {
      this.buffer.delete([[end, lineEnd.length - 1], [end, lineEnd.length]])
      this.buffer.delete([[start, 0], [start, 1]])
    })
  }

  comment (start, end) {
    this.buffer.transact(() => {
      this.buffer.insert([start, 0], commentStart)
      this.buffer.insert([end, this.buffer.lineLengthForRow(end)], commentEnd)
    })
  }
}

module.exports = () => {
  const instance = new ToggleLineComment()
  instance.toggle()
}

class LineAsChar {
  constructor () {
    this.editor = atom.workspace.getActiveTextEditor()

    if (this.editor) {
      this.buffer = this.editor.getBuffer()
    }
  }

  transform () {
    if (!this.buffer) {
      return
    }

    this.editor.mutateSelectedText((selection, index) => {
      const bufferRowRange = selection.getBufferRowRange()
      const lineText = this.editor.lineTextForBufferRow(bufferRowRange[0])
      const bufferRange = [ [bufferRowRange[0], 0], [bufferRowRange[1], lineText.length] ]

      // ignore empty line
      if (lineText.length === 0) {
        return
      }

      this.buffer.backwardsScanInRange(/(?:\s*, (.+)|\s*\((.+)\)|(\S))\s*\\?:?$/, bufferRange, ({ match, replace }) => {
        if (match[1] || match[2]) {
          replace(` (${match[1] || match[2]}) :`)
          return
        }

        replace(`${match[3]} :`)
      })
    })
  }
}

module.exports = () => {
  const instance = new LineAsChar()
  instance.transform()
}

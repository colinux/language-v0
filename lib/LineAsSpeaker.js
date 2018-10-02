class LineAsSpeaker {
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

      this.buffer.backwardsScanInRange(/^@?([^\\(,]+?)(?:\s*,\s*(.+)|\s*\((.+)\))?\s*$/, bufferRange, ({ match, replace }) => {
        let comment = ''
        if (match[2] || match[3]) {
          comment = ` (${match[2] || match[3]})`
        }

        replace(`@${match[1]}${comment}`)
      })
    })
  }
}

module.exports = () => {
  const instance = new LineAsSpeaker()
  instance.transform()
}

# If you want an example of language specs, check out:
# https://github.com/atom/language-javascript/blob/master/spec/javascript-spec.coffee

describe "V0 grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-v0")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.v0")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.v0"

  describe "replica", ->
    it "no useless space", ->
      lines = grammar.tokenizeLines """
        @Eugène
        My text
        Another line.
      """

      expect(lines[0][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[0][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[1][0]).toEqual value: "My text", scopes: ['source.v0']
      expect(lines[2][0]).toEqual value: "Another line.", scopes: ['source.v0']

    it "with extra blank", ->
      lines = grammar.tokenizeLines """
        @Eugène

        My text
        Another line.
      """

      expect(lines[0][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[0][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[1][0]).toEqual value: "", scopes: ['source.v0']
      expect(lines[2][0]).toEqual value: "My text", scopes: ['source.v0']
      expect(lines[3][0]).toEqual value: "Another line.", scopes: ['source.v0']

    it "with character comment", ->
      lines = grammar.tokenizeLines """
        @Eugène (comment)
        My text
        Another line.
      """

      expect(lines[0][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[0][1]).toEqual value: "Eugène ", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[0][2]).toEqual value: "(", scopes: ['source.v0', 'meta.comment.v0', 'punctuation.definition.comment.v0']
      expect(lines[0][3]).toEqual value: "comment", scopes: ['source.v0', 'meta.comment.v0', 'comment.line.v0']
      expect(lines[0][4]).toEqual value: ")", scopes: ['source.v0',  'meta.comment.v0', 'punctuation.definition.comment.v0']

      expect(lines[1][0]).toEqual value: "My text", scopes: ['source.v0']
      expect(lines[2][0]).toEqual value: "Another line.", scopes: ['source.v0']

    it "with character comment and extra spaces", ->
      lines = grammar.tokenizeLines """
        @Eugène (comment)

        My text
      """

      expect(lines[0][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[0][1]).toEqual value: "Eugène ", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[0][2]).toEqual value: "(", scopes: ['source.v0', 'meta.comment.v0', 'punctuation.definition.comment.v0']
      expect(lines[0][3]).toEqual value: "comment", scopes: ['source.v0', 'meta.comment.v0', 'comment.line.v0']
      expect(lines[0][4]).toEqual value: ")", scopes: ['source.v0',  'meta.comment.v0', 'punctuation.definition.comment.v0']

      expect(lines[1][0]).toEqual value: "", scopes: ['source.v0']
      expect(lines[2][0]).toEqual value: "My text", scopes: ['source.v0']

    it "with comment in text", ->
      lines = grammar.tokenizeLines """
        @Eugène
        My text (a comment) then
        Another line
      """

      expect(lines[0][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[0][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']

      expect(lines[1][0]).toEqual value: "My text ", scopes: ['source.v0']
      expect(lines[1][1]).toEqual value: "(", scopes: ['source.v0', 'meta.comment.v0', 'punctuation.definition.comment.v0']
      expect(lines[1][2]).toEqual value: "a comment", scopes: ['source.v0', 'meta.comment.v0', 'comment.line.v0']
      expect(lines[1][3]).toEqual value: ")", scopes: ['source.v0', 'meta.comment.v0', 'punctuation.definition.comment.v0']
      expect(lines[1][4]).toEqual value: " then", scopes: ['source.v0']

      expect(lines[2][0]).toEqual value: "Another line", scopes: ['source.v0']

    it "with comment in single line", ->
      lines = grammar.tokenizeLines """
        @Eugène
        (single line comment)
        My text
      """

      expect(lines[0][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[0][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']

      expect(lines[1][0]).toEqual value: "(", scopes: ['source.v0', 'meta.comment.v0', 'punctuation.definition.comment.v0']
      expect(lines[1][1]).toEqual value: "single line comment", scopes: ['source.v0', 'meta.comment.v0', 'comment.line.v0']
      expect(lines[1][2]).toEqual value: ")", scopes: ['source.v0', 'meta.comment.v0', 'punctuation.definition.comment.v0']
      expect(lines[2][0]).toEqual value: "My text", scopes: ['source.v0']


    it "replicas chaining with blank link", ->
      lines = grammar.tokenizeLines """
        @Eugène
        My text
        Another line.

        @Hector
        Your text

        ## Scène 2
      """

      expect(lines[0][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[0][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[1][0]).toEqual value: "My text", scopes: ['source.v0']
      expect(lines[2][0]).toEqual value: "Another line.", scopes: ['source.v0']

      expect(lines[3][0]).toEqual value: "", scopes: ['source.v0']

      expect(lines[4][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[4][1]).toEqual value: "Hector", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[5][0]).toEqual value: "Your text", scopes: ['source.v0']

    it "line ending with colon are not characters", ->
      lines = grammar.tokenizeLines """
        ## Scene 1

        @Eugène
        Listing :
      """

      expect(lines[3][0]).toEqual value: "Listing :", scopes: ['source.v0']

  describe "scene/separator", ->
    it "scene and first replica", ->
      lines = grammar.tokenizeLines """
        ## Scene 1

        @Eugène
        My text
      """

      expect(lines[0][0]).toEqual value: "## Scene 1", scopes: ['source.v0', 'empty.heading.markup.md']
      expect(lines[1][0]).toEqual value: "", scopes: ['source.v0']
      expect(lines[2][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[2][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[3][0]).toEqual value: "My text", scopes: ['source.v0']

    it "scene with colon and first replica", ->
      lines = grammar.tokenizeLines """
        ## Scene 1 :

        @Eugène
        My text
      """

      expect(lines[0][0]).toEqual value: "## Scene 1 :", scopes: ['source.v0', 'empty.heading.markup.md']
      expect(lines[1][0]).toEqual value: "", scopes: ['source.v0']
      expect(lines[2][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[2][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[3][0]).toEqual value: "My text", scopes: ['source.v0']

    it "scenes chaining", ->
      lines = grammar.tokenizeLines """
        ## Scene 1

        @Eugène
        My text

        ## Scene 2

        @Hector
        Your text
      """

      expect(lines[0][0]).toEqual value: "## Scene 1", scopes: ['source.v0', 'empty.heading.markup.md']
      expect(lines[1][0]).toEqual value: "", scopes: ['source.v0']
      expect(lines[2][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[2][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[3][0]).toEqual value: "My text", scopes: ['source.v0']
      expect(lines[4][0]).toEqual value: "", scopes: ['source.v0']

      expect(lines[5][0]).toEqual value: "## Scene 2", scopes: ['source.v0', 'empty.heading.markup.md']
      expect(lines[6][0]).toEqual value: "", scopes: ['source.v0']
      expect(lines[7][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[7][1]).toEqual value: "Hector", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[8][0]).toEqual value: "Your text", scopes: ['source.v0']

    it "consecutive separators and first replica", ->
      lines = grammar.tokenizeLines """
        # Acte 1
        ## Scene 1

        @Eugène
        My text
      """

      expect(lines[0][0]).toEqual value: "# Acte 1", scopes: ['source.v0', 'empty.heading.markup.md']
      expect(lines[1][0]).toEqual value: "## Scene 1", scopes: ['source.v0', 'empty.heading.markup.md']
      expect(lines[2][0]).toEqual value: "", scopes: ['source.v0']
      expect(lines[3][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[3][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[4][0]).toEqual value: "My text", scopes: ['source.v0']

  # describe "scene comment", ->
  #   it "after metadata, before separator", ->
  #     lines = grammar.tokenizeLines """
  #       A comment
  #
  #       ## Scene 1
  #
  #       @Eugène
  #       My text
  #     """
  #
  #     expect(lines[0][0]).toEqual value: "A comment", scopes: ['source.v0', 'comment.block.v0']
  #     expect(lines[1][0]).toEqual value: "", scopes: ['source.v0']
  #     expect(lines[2][0]).toEqual value: "## Scene 1", scopes: ['source.v0', 'empty.heading.markup.md']
  #     expect(lines[4][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
  #     expect(lines[4][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
  #     expect(lines[5][0]).toEqual value: "My text", scopes: ['source.v0']

  #   it "between scene and replica", ->
  #     lines = grammar.tokenizeLines """
  #       author = colin
  #
  #       ## Scene 1
  #
  #       A comment
  #
  #       @Eugène
  #       My text
  #     """
  #
  #     expect(lines[2][0]).toEqual value: "## Scene 1", scopes: ['source.v0', 'empty.heading.markup.md']
  #
  #     expect(lines[3][0]).toEqual value: "", scopes: ['source.v0']
  #     expect(lines[4][0]).toEqual value: "A comment", scopes: ['source.v0', 'comment.block.v0']
  #     expect(lines[5][0]).toEqual value: "", scopes: ['source.v0']
  #
  #     expect(lines[6][0]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
  #     expect(lines[6][1]).toEqual value: ":", scopes: ['source.v0', 'punctuation.definition.function.v0']
  #     expect(lines[7][0]).toEqual value: "My text", scopes: ['source.v0']
  #
  #   it "multiple lines between scene and replica", ->
  #     lines = grammar.tokenizeLines """
  #       author = colin
  #
  #       ## Scene 1
  #
  #       A comment
  #
  #       Another comment
  #
  #       @Eugène
  #       My text
  #     """
  #
  #     expect(lines[2][0]).toEqual value: "## Scene 1", scopes: ['source.v0', 'empty.heading.markup.md']
  #
  #     expect(lines[3][0]).toEqual value: "", scopes: ['source.v0']
  #     expect(lines[4][0]).toEqual value: "A comment", scopes: ['source.v0', 'comment.block.v0']
  #     expect(lines[5][0]).toEqual value: "", scopes: ['source.v0']
  #     expect(lines[6][0]).toEqual value: "Another comment", scopes: ['source.v0', 'comment.block.v0']
  #     expect(lines[7][0]).toEqual value: "", scopes: ['source.v0']
  #
  #     expect(lines[8][0]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
  #     expect(lines[8][1]).toEqual value: ":", scopes: ['source.v0', 'punctuation.definition.function.v0']
  #     expect(lines[9][0]).toEqual value: "My text", scopes: ['source.v0']
  #
  #   it "between 2 separators", ->
  #     lines = grammar.tokenizeLines """
  #       author = colin
  #
  #       # Acte 1
  #
  #       A comment
  #
  #       ## Scene 1
  #     """
  #
  #     expect(lines[2][0]).toEqual value: "# Acte 1", scopes: ['source.v0', 'empty.heading.markup.md']
  #     expect(lines[3][0]).toEqual value: "", scopes: ['source.v0']
  #     expect(lines[4][0]).toEqual value: "A comment", scopes: ['source.v0', 'comment.block.v0']
  #     expect(lines[5][0]).toEqual value: "", scopes: ['source.v0']
  #     expect(lines[6][0]).toEqual value: "## Scene 1", scopes: ['source.v0', 'empty.heading.markup.md']
  #
  #   it "between 2 separators, multiples lines", ->
  #     lines = grammar.tokenizeLines """
  #       author = colin
  #
  #       # Acte 1
  #
  #       A comment
  #
  #       Another comment
  #
  #       ## Scene 1
  #     """
  #
  #     expect(lines[2][0]).toEqual value: "# Acte 1", scopes: ['source.v0', 'empty.heading.markup.md']
  #     expect(lines[3][0]).toEqual value: "", scopes: ['source.v0']
  #     expect(lines[4][0]).toEqual value: "A comment", scopes: ['source.v0', 'comment.block.v0']
  #     expect(lines[5][0]).toEqual value: "", scopes: ['source.v0']
  #     expect(lines[6][0]).toEqual value: "Another comment", scopes: ['source.v0', 'comment.block.v0']
  #     expect(lines[7][0]).toEqual value: "", scopes: ['source.v0']
  #     expect(lines[8][0]).toEqual value: "## Scene 1", scopes: ['source.v0', 'empty.heading.markup.md']

  describe "hotfix cases", ->
    it "with separator, second replica text must not be a comment", ->
      lines = grammar.tokenizeLines """
        ## Scene 1

        @Eugène
        My text

        @Hector
        Your text
      """

      expect(lines[0][0]).toEqual value: "## Scene 1", scopes: ['source.v0', 'empty.heading.markup.md']
      expect(lines[1][0]).toEqual value: "", scopes: ['source.v0']
      expect(lines[2][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[2][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[3][0]).toEqual value: "My text", scopes: ['source.v0']
      expect(lines[4][0]).toEqual value: "", scopes: ['source.v0']

      expect(lines[5][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[5][1]).toEqual value: "Hector", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[6][0]).toEqual value: "Your text", scopes: ['source.v0']

    it "scene and replica with blank lines", ->
      lines = grammar.tokenizeLines """
        ## Scene 1

        @Eugène

        My text

        @Hector

        Your text
      """

      expect(lines[0][0]).toEqual value: "## Scene 1", scopes: ['source.v0', 'empty.heading.markup.md']
      expect(lines[1][0]).toEqual value: "", scopes: ['source.v0']
      expect(lines[2][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[2][1]).toEqual value: "Eugène", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[3][0]).toEqual value: "", scopes: ['source.v0']
      expect(lines[4][0]).toEqual value: "My text", scopes: ['source.v0']
      expect(lines[5][0]).toEqual value: "", scopes: ['source.v0']

      expect(lines[6][0]).toEqual value: "@", scopes: ['source.v0', 'punctuation.definition.function.v0']
      expect(lines[6][1]).toEqual value: "Hector", scopes: ['source.v0', 'entity.name.function.v0']
      expect(lines[7][0]).toEqual value: "", scopes: ['source.v0']
      expect(lines[8][0]).toEqual value: "Your text", scopes: ['source.v0']

    it "second scene after second replica", ->
      lines = grammar.tokenizeLines """
        ## Scene 1

        @Eugène
        My text

        @Hector
        Your text

        ## Scène 2
      """

      expect(lines[8][0]).toEqual value: "## Scène 2", scopes: ['source.v0', 'empty.heading.markup.md']

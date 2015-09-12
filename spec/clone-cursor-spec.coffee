CloneCursor = require "../lib/clone-cursor"

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "CloneCursor", ->
  [workspaceElement] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    
    waitsForPromise ->
      atom.workspace.open("sample.js")
    waitsForPromise ->
      atom.packages.activatePackage("clone-cursor")
  
  it "should have a working editor", ->
    expect(CloneCursor.ensureEditor()).toBe(true)
    edit = CloneCursor.editor
    expect(edit).not.toBeNull()
    expect(edit).toBeDefined()
  
  it "should be the correct file", ->
    expect(CloneCursor.editor.getPath()).toContain("sample.js")
  
  describe "when cloning up", ->
    [editor] = []
    
    beforeEach ->
      editor = atom.workspace.getActiveTextEditor()
      expect(editor).not.toBeNull()
      expect(editor).toBeDefined()
    
    it "duplicates the cursor up", ->
      expect(editor.hasMultipleCursors()).toBe(false)
      atom.commands.dispatch workspaceElement, "clone-cursor:up"
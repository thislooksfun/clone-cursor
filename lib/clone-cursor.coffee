{CompositeDisposable} = require 'atom'

module.exports = CloneCursor =

  editor: null
  
  activate: (state) ->
    @subscriptions = new CompositeDisposable
    
    @subscriptions.add atom.commands.add 'atom-workspace', 'clone-cursor:up':         => @up()
    @subscriptions.add atom.commands.add 'atom-workspace', 'clone-cursor:down':       => @down()
  
  #Makes sure the @editor instance is accurate
  ensureEditor: ->
    e = atom.workspace.getActiveTextEditor()
    @editor = e if @editor isnt e
  
  getExtremeCursors: ->
    @ensureEditor()
    if !@editor.hasMultipleCursors()
      e = @editor.getCursor()
      [e, e]
    else
      [first, ..., last] = @editor.getCursorsOrderedByBufferPosition()
      [first, last]
  
  getFarthestRight: ->
    @ensureEditor()
    cursors = @editor.getCursors()
    cursors.sort (a,b) -> b.getScreenColumn() - a.getScreenColumn()
    console.log cursors[0].getScreenColumn()
    cursors[0].getScreenColumn()
  
  done: ->
    @editor = null
  
  up: ->
    @ensureEditor()
    [top, bottom] = @getExtremeCursors()
    if top.isLastCursor()
      line = top.getScreenRow() - 1
      return if line < 0
      @editor.addCursorAtScreenPosition([line, @getFarthestRight()])
    else if bottom.isLastCursor()
      @editor.removeCursor(bottom)
      bottom.destroy()
    @done()
  
  down: ->
    @ensureEditor()
    [top, bottom] = @getExtremeCursors()
    if bottom.isLastCursor()
      line = bottom.getScreenRow() + 1
      return if line >= @editor.getScreenLineCount()
      @editor.addCursorAtScreenPosition([line, @getFarthestRight()])
    else if top.isLastCursor()
      @editor.removeCursor(top)
      top.destroy()
    @done()

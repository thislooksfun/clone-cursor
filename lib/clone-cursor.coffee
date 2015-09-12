{CompositeDisposable} = require 'atom'

module.exports = CloneCursor =
  
  editor: null
  
  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'clone-cursor:up':   => @up()
    @subscriptions.add atom.commands.add 'atom-workspace', 'clone-cursor:down': => @down()
  
  #Makes sure the @editor instance is accurate
  ensureEditor: ->
    e = atom.workspace.getActiveTextEditor()
    @editor = e if @editor isnt e
    @editor != null && @editor != undefined
  
  getExtremeCursors: ->
    if !@ensureEditor()
      console.log "No editor!"
      return
    
    if !@editor.hasMultipleCursors()
      c = @editor.getLastCursor()
      [c, c]
    else
      [top, ..., bottom] = @editor.getCursorsOrderedByBufferPosition()
      [top, bottom]
  
  getFarthestRight: ->
    if !@ensureEditor()
      console.log "No editor!"
      return
    
    cursors = @editor.getCursors()
    cursors.sort (a,b) -> b.getScreenColumn() - a.getScreenColumn()
    cursors[0].getScreenColumn()
  
  up: ->
    if !@ensureEditor()
      console.log "No editor!"
      return
    
    [top, bottom] = @getExtremeCursors()
    if top.isLastCursor()
      line = top.getScreenRow() - 1
      return if line < 0
      @editor.addCursorAtScreenPosition([line, @getFarthestRight()])
    else if bottom.isLastCursor()
      #@editor.removeCursor(bottom)
      bottom.destroy()
    @done()
  
  down: ->
    if !@ensureEditor()
      console.log "No editor!"
      return
    
    [top, bottom] = @getExtremeCursors()
    if bottom.isLastCursor()
      line = bottom.getScreenRow() + 1
      return if line >= @editor.getScreenLineCount()
      @editor.addCursorAtScreenPosition([line, @getFarthestRight()])
    else if top.isLastCursor()
      #@editor.removeCursor(top)
      top.destroy()
    @done()
  
  done: ->
    @editor = null
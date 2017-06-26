{CompositeDisposable} = require 'atom'
{File} = require 'atom'

samePrefix = (str1, str2) ->
  if str1.length < str2.length
    [str2, str1] = [str1, str2]
  return str1.indexOf(str2) == 0


module.exports = ExtensionCycler =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'extension-cycler:engage': => @engage()

  deactivate: ->
    @subscriptions.dispose()

  engage: ->
    editor = atom.workspace.getActiveTextEditor()
    ourprefix = editor.getPath().replace( /\.[^.]+/, '') #-- w/o extension
    new File(editor.getPath())
        .getParent()
        .getEntries((err, entries) ->
            files = (entry.getPath() for entry in entries \
                        when entry.isFile() and samePrefix(entry.getPath(), ourprefix))
                    .sort()
            currentindex = files.indexOf(editor.getPath())
            if currentindex != -1
                nextindex = (currentindex + 1) % files.length
                atom.workspace.open(files[nextindex])
        )

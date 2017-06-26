ExtensionCyclerView = require './extension-cycler-view'
{CompositeDisposable} = require 'atom'

module.exports = ExtensionCycler =
  extensionCyclerView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @extensionCyclerView = new ExtensionCyclerView(state.extensionCyclerViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @extensionCyclerView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'extension-cycler:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @extensionCyclerView.destroy()

  serialize: ->
    extensionCyclerViewState: @extensionCyclerView.serialize()

  toggle: ->
    console.log 'ExtensionCycler was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

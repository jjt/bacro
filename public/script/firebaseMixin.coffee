fbRoot = require './fbRoot'
sliceArgs = require '../../lib/sliceArgs'

FirebaseMixin =

  componentWillMount: ()->
    if @firebaseInitFn? and _.isFunction @firebaseInitFn
      @firebaseInitFn()

  componentWillUnmount: ()->
    @firebaseDestroy()

  firebaseInit: (path, fbRootAlias)->
    fb = fbRoot.child path
    @firebaseRefs = []
    @firebaseRefRoot = fb
    if fbRootAlias?
      this[fbRootAlias] = fb

  firebaseDestroy: ()->
    @firebaseRefRoot?.off()
    if @firebaseRefs?
      @firebaseRefs.forEach (ref)->
        ref.off()
    delete @firebaseRefRoot
    
  firebaseRef: (child)->
    ref = @firebaseRefRoot
    if child?
      ref = ref.child child
    @firebaseRefs.push ref
    ref

  firebaseOn: (child)->
    ref = @firebaseRef child
    ref.on.apply ref, sliceArgs(arguments, 1)

  firebaseOnce: (child)->
    ref = @firebaseRef child
    ref.once.apply ref, sliceArgs(arguments, 1)

  firebaseOff: ()->
    args = Array.prototype.slice.call arguments, 0
    if args? and args.length > 0
      return @firebaseRefRoot.off.apply @firebaseRefRoot, args
    @firebaseRefRoot.off()
  
module.exports = FirebaseMixin

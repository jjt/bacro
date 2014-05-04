fbRoot = require './fbRoot'
sliceArgs = require '../../lib/sliceArgs'

FirebaseMixin =

  componentWillUnmount: ()->
    @firebaseDestroy()

  firebaseInit: (path, fbRootAlias)->
    fb = fbRoot.child path
    @firebaseRefs = []
    @firebaseRefRoot = fb
    if fbRootAlias?
      this[fbRootAlias] = fb

  firebaseDestroy: ()->
    @firebaseRefRoot.off()
    if @firebaseRefs?
      @firebaseRefs.forEach (ref)->
        ref.off()
    delete @firebaseRefRoot
    
  firebaseRef: (path)->
    ref = @firebaseRefRoot
    if path?
      ref = ref.child path
    @firebaseRefs.push ref
    ref

  firebaseOn: (child)->
    ref = @firebaseRefRoot
    if child?
      ref = ref.child child
    ref.on.apply ref, sliceArgs(arguments, 1)
    @firebaseRefs.push ref
    ref

  firebaseOnce: (child)->
    ref = @firebaseRefRoot
    if child?
      ref = ref.child child
    ref.once.apply ref, sliceArgs(arguments, 1)
    @firebaseRefs.push ref
    ref

  firebaseOff: ()->
    args = Array.prototype.slice.call arguments, 0
    if args? and args.length > 0
      return @firebaseRefRoot.off.apply @firebaseRefRoot, args
    @firebaseRefRoot.off()
  
module.exports = FirebaseMixin

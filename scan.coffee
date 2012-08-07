sp = getSpotifyApi(1)
models = sp.require('sp://import/scripts/api/models')
player = models.player
scanMode = true

init = ->
  player.observe(models.EVENT.CHANGE, (e) ->
    if e.data.curtrack == true
      wrapper()
    return
  )
  $("#scan").click(->
    scanMode = !scanMode
  )
  wrapper()
  return

updatePageWithTrackDetails = () ->
  header = $("#header")
  canvas = $("#canvas")

  playerTrackInfo = player.track
  if not playerTrackInfo
    headerContent = "Nothing is playing!"
    cover = null
  else
    track = playerTrackInfo.data
    album = track.album
    if track.image?
      cover = track.image
    else if album.cover?
      cover = album.cover
    else
      cover = null
    headerContent = "#{track.name} on the album #{track.album.artist.name}."
  
  header.html(headerContent)
  if cover
    canvas.attr("src", cover)
  return

startAtRandomPosition = ->
  # start the track at random position but it's always before the halfway mark
  track = player.track
  startingPoint = Math.floor((track.duration / 2) *  Math.random())
  player.position = startingPoint

  # raise the volume gradually
  # which currently doesn't work because API doesn't allow it
  volumeInterval = setInterval(->
    player.volume = 0.2 + player.volume
    if player.volume >= 1.0
      clearInterval(volumeInterval)
      return
  , 500)
  return

wrapper = ->
  # set the volume to be zero in the beginning
  # which currently doesn't work because API doesn't allow it
  player.volume = 0

  updatePageWithTrackDetails()
  playInterval = setInterval(() ->
    if player.position > 0
      # track is ready to be played
      clearInterval(playInterval)
      startAtRandomPosition()
    else
      console.log("not ready")
  , 200)
  return

# keeps rotating through tracks
setInterval(() ->
  if scanMode
    player.next()
  return
, 30000)

exports.init = init

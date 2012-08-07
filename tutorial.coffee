sp = getSpotifyApi(1)
models = sp.require('sp://import/scripts/api/models')
player = models.player

init = ->
  console.log("my spotify app")
  player.observe(models.EVENT.CHANGE, (e) ->
    if e.data.curtrack == true
      wrapper()
    return
  )
  wrapper()
  return

updatePageWithTrackDetails = () ->
  header = $("#header")
  playerTrackInfo = player.track
  if not playerTrackInfo
    header.html( "Nothing is playing!")
  else
    track = playerTrackInfo.data
    header.html("#{track.name} on the album #{track.album.artist.name}.")
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
  , 500)

  # play the track for 30 seconds and move to the next song
  setTimeout(() ->
    player.next()
  , 30000)

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

exports.init = init

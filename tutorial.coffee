sp = getSpotifyApi(1)
models = sp.require('sp://import/scripts/api/models')
player = models.player

init = ->
  console.log("my spotify app")
  updatePageWithTrackDetails()
  player.observe(models.EVENT.CHANGE, (e) ->
    if e.data.curtrack == true
      updatePageWithTrackDetails()
    return
  )
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

exports.init = init

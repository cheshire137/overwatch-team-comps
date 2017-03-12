json.compositionPlayer do
  json.id @comp_player.id
  json.compositionID @comp_player.composition_id
  json.player do
    json.id @player.id
    json.name @player.name
    json.battletag @player.battletag
  end
end

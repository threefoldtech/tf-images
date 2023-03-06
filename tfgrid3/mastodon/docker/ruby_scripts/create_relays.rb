require 'json'


relays = JSON.parse(ENV['RELAYS_LINKS'])

relays.each { |x|
    rel = Relay.create(
        inbox_url: x
    )
    rel.enable!
    rel.save!
}

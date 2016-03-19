class ImportCalendar
  include InfluxConnection

  def import_event(event)
    data = generate_points(event)

    precision = 's'
    retention = 'default' # Defaults to infinite
    influx.write_points(data, precision, retention)
  end

  def generate_points(event)
    event[:attendees]
      .map do |attendee|
        {
          series: 'events',
          tags: {
            username: attendee,
            channel: channel_id(event[:attendees])
          },
          timestamp: event[:start].to_i,
          values: {
            summary: event[:summary]
          }
        }
      end
  end

  def channel_id(attendees)
    attendees
      .map { |a| a.split('@').first }
      .sort
      .join("-")
  end
end
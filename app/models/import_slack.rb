class ImportSlack
  include InfluxConnection

  def nuke_db!
    if influx.list_databases.map{|h| h['name']}.include? 'thor'
      influx.delete_database('thor')
    end

    influx.create_database('thor')
  end

  def import(messages)
    data = messages.map { |message| generate_point(message) }

    precision = 's'
    retention = 'default' # Defaults to infinite
    influx.write_points(data, precision, retention)
  end

  def generate_point(message = nil)
    puts message
    {
      series: 'messages',
      tags: {
        username: message[:email],
        channel: message[:channel]
      },
      timestamp: message[:ts],
      values: {
        message: message[:text]
      }
    }
  end
end

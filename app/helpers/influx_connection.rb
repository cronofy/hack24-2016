require 'influxdb'

module InfluxConnection
  def self.included(klass)
    klass.extend(self)
  end

  def self.influx
    @_influx ||= InfluxDB::Client.new('thor')
  end

  def influx
    InfluxConnection.influx
  end
end

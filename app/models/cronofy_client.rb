class CronofyClient

  def events

    events = []

    base_time = Time.new(2015, 5, 4, 10, 0)

    52.times do |n|
      event = {
        attendees: ['adam@cronofy.com', 'garry@cronofy.com'],
        summary: 'Dev meeting',
        start: base_time + n.weeks
      }
      event[:attendees] << 'stephen@cronofy.com' if n > 40
      events << event
    end

    52.times do |n|
      event = {
        attendees: ['adam@cronofy.com', 'jenni@cronofy.com'],
        summary: 'Marketing meeting',
        start: base_time + n.weeks
      }
      event[:attendees] << 'jeremy@cronofy.com' if n > 46
      events << event
    end

    12.times do |n|
      event = {
        attendees: ['adam@cronofy.com', 'jenni@cronofy.com', 'garry@cronofy.com'],
        summary: 'All Hands',
        start: base_time + n.weeks
      }
      event[:attendees] << 'stephen@cronofy.com' if n > 40
      event[:attendees] << 'jeremy@cronofy.com' if n > 46
      events << event
    end

    13.times do |n|
      event = {
        attendees: ['adam@cronofy.com', 'catherine@cronofy.com'],
        summary: 'Finance meeting',
        start: base_time + (13 + n).weeks
      }
      event[:attendees] << 'garry@cronofy.com' if n % 4 == 0
      events << event
    end

    events
  end

end
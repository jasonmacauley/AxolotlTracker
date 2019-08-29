module ChangeType
  class DefaultChange
    def handle(action)
      puts 'Default Change - ' + action['data']['old'].keys[0]
    end
  end
end

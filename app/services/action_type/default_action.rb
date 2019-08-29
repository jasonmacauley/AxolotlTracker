module ActionType
  class DefaultAction
    def handle(action)
      puts 'Default Action: ' + action['type']
    end
  end
end

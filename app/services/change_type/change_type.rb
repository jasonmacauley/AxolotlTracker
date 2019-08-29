module ChangeType
  class ChangeType
    CHANGE_TYPES = {
        'idList' => IdList
    }.freeze

    def handle(action)
      if CHANGE_TYPES.key?(action['data']['old'].keys[0])
        CHANGE_TYPES[action['data']['old'].keys[0]].new.handle(action)
      else
        DefaultChange.new.handle(action)
      end
    end
  end
end

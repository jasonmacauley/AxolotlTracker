module ActionType
  class ActionType
    ACTION_TYPES = {
        'updateCard' => UpdateCard,
        'createCard' => CreateCard
    }.freeze

    def handle(action)
      if ACTION_TYPES.key?(action['type'])
        ACTION_TYPES[action['type']].new.handle(action)
      else
        DefaultAction.new.handle(action)
      end
    end
  end
end

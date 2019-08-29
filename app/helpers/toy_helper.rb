module ToyHelper
  def data
    @data = {
        'sorted_actions' => Action.order(trello_card_id: :asc).order(datetime: :asc),
        'list_times' => ListTime.order(trello_card_id: :asc).order(enter: :asc)
    }
  end
end

module ApplicationHelper
  def datepicker_input(form, field)
    content_tag :td, :data => {:provide => 'datepicker', 'date-format' => 'yyyy-mm-dd', 'date-autoclose' => 'true'} do
      puts 'Date picker doing stuff!'
      form.text_field field, class: 'form-control', placeholder: 'YYYY-MM-DD', autoclose: true, toggleActive: true
    end
  end
end

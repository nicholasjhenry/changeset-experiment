defmodule Directory.PersonView do
  use Directory.Web, :view

  import Phoenix.HTML.Form

  def fields_for(_form, fields_data, options \\ [], fun) when is_function(fun, 1) do
    fields = Phoenix.HTML.FormData.to_form(fields_data, options)
    html_escape [fun.(fields)]
  end
end


defmodule SwedishDate do
  @spec new(integer, integer, integer) :: %Timex.Date{}
  def new(year, month, day) do
    %Timex.Date{year: year, month: month, day: day}
  end
end

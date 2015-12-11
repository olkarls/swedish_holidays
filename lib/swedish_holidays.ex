defmodule SwedishHolidays do
  use Timex

  def day_filters do
    %{
      :red_day_not_sunday => 1800,
      :red_day => 1700,
      :friday_after_red_day => 1400,
      :monday_before_red_day => 1300,
      :day_before_red_day => 1200,
      :day_after_red_day => 1100,
      :monday => 1000,
      :tuesday => 900,
      :wednesday => 800,
      :thursday => 700,
      :friday => 600,
      :saturday => 500,
      :sunday => 400,
      :monday_to_thursday => 300,
      :weekday => 200,
      :weekend => 100,
      :any_day => 0
    }
  end

  def swedish_date(year, month, day) do
    Date.from({{year, month, day}, {0, 0, 0}}, "Europe/Stockholm")
  end
end

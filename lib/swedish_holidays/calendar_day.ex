defmodule SwedishHolidays.CalendarDay do
  @moduledoc """
  """

  alias SwedishHolidays.CalendarDay

  defstruct code: nil, date: nil, red_day: nil

  def find(year, month, day) do
    Timex.to_date({year, month, day})
    |> find
  end

  @spec find(Timex.Date) :: %CalendarDay{}
  def find(date) do
    day =
      all(date.year)
      |> Enum.filter(fn(d) -> d.date == date end)
      |> List.first

    case day do
      nil -> other(date)
      true -> day
    end
  end

  @spec find(Timex.Date, Timex.Date) :: [%CalendarDay{}]
  def find(from, to) do
    0..Timex.diff(from, to, :days)
    |> Enum.map(fn(n) ->
      find(Timex.add(from, Timex.Duration.from_days(n)))
    end)
  end

  def match_any(calendar_days, day_filters) do
    Enum.map(day_filters, fn(filter) ->
      Enum.filter(calendar_days, fn(day) ->
        CalendarDay.matches?(day, filter)
      end)
    end)
    |> List.flatten
    |> Enum.sort(&(&1.date < &2.date))
  end

  def match_all(calendar_days, day_filters) do
    Enum.map(calendar_days, fn(day) ->
      is_match = Enum.map(day_filters, fn(filter) ->
        CalendarDay.matches?(day, filter)
      end)
      unless false in is_match do
        day
      end
    end)
    |> Enum.filter(fn(d) ->
      d != nil
    end)
  end

  def matches?(calendar_day, day_filter) do
    day_filter in matching_filters(calendar_day)
  end

  def all(year) do
    [
       new_years_day(year),
       twelfth_day(year),
       maundy_thursday(year),
       good_friday(year),
       easter_eve(year),
       easter_day(year),
       easter_monday(year),
       first_of_may(year),
       ascension_day(year),
       whitsun_eve(year),
       whitsun_day(year),
       whit_monday(year),
       national_day(year),
       midsummer_eve(year),
       midsummer_day(year),
       all_saints_day(year),
       christmas_eve(year),
       christmas_day(year),
       boxing_day(year),
       new_years_eve(year)
     ]
  end

  def new_years_day(year) do
    create(:new_years_day, Timex.to_date({year, 1, 1}), true)
  end

  def twelfth_day(year) do
    create(:twelfth_day, Timex.to_date({year, 1, 6}), true)
  end

  def maundy_thursday(year) do
    date = good_friday(year).date
    |> Timex.subtract(Timex.Duration.from_days(1))

    create(:maundy_thursday, date, false)
  end

  def good_friday(year) do
    date = easter_day(year).date
    |> Timex.subtract(Timex.Duration.from_days(2))

    create(:good_friday, date, true)
  end

  def easter_eve(year) do
    date = easter_day(year).date
    |> Timex.subtract(Timex.Duration.from_days(1))

    create(:easter_eve, date, false)
  end

  def easter_day(year) do
    g = rem(year, 19)
    c = div(year, 100)
    j = (c - div(c, 4) - div((8 * c + 13), 25) + 19 * g + 15)
    h = rem(j, 30)
    i = h - div(h, 28) * (1 - div(h, 28) * div(29, (h + 1)) * div((21 - g), 11))
    day   = i - rem((year + div(year, 4) + i + 2 - c + div(c, 4)), 7) + 28
    month = 3

    if (day > 31) do
      month = month + 1
      day = day - 31
    end

    create(:easter_day, Timex.to_date({year, month, day}), true)
  end

  def easter_monday(year) do
    date = easter_day(year).date
    |> Timex.add(Timex.Duration.from_days(1))

    create(:easter_monday, date, true)
  end

  def first_of_may(year) do
    create(:first_of_may, Timex.to_date({year, 5, 1}), true)
  end

  def ascension_day(year) do
    date = easter_day(year).date
    |> Timex.add(Timex.Duration.from_days((5 * 7) + 4))

    create(:ascension_day, date, true)
  end

  def whitsun_eve(year) do
    date = whitsun_day(year).date
    |> Timex.subtract(Timex.Duration.from_days(1))

    create(:whitsun_eve, date, false)
  end

  def whitsun_day(year) do
    date = easter_day(year).date
    |> Timex.add(Timex.Duration.from_days(7 * 7))

    create(:whitsun_day, date, true)
  end

  def whit_monday(year) do
    date = whitsun_day(year).date
    |> Timex.add(Timex.Duration.from_days(1))

    red_day = year <= 2004

    create(:whit_monday, date, red_day)
  end

  def national_day(year) do
    red_day = year >= 2005

    create(:national_day, Timex.to_date({year, 6, 6}), red_day)
  end

  def midsummer_eve(year) do
    date =
      midsummer_day(year).date
      |> Timex.subtract(Timex.Duration.from_days(1))

    create(:midsummer_eve, date, false)
  end

  def midsummer_day(year) do
    start_date = Timex.to_date({year, 6, 20})
    date = Timex.add(start_date, Timex.Duration.from_days(6 - (Timex.weekday(start_date))))

    create(:midsummer_day, date, true)
  end

  def all_saints_day(year) do
    start_date = Timex.to_date({year, 10, 31})

    date = Timex.add(start_date, Timex.Duration.from_days(6 - Timex.weekday(start_date)))

    create(:all_saints_day, date, true)
  end

  def christmas_eve(year) do
    create(:christmas_eve, Timex.to_date({year, 12, 24}), false)
  end

  def christmas_day(year) do
    create(:christmas_day, Timex.to_date({year, 12, 25}), true)
  end

  def boxing_day(year) do
    create(:boxing_day, Timex.to_date({year, 12, 26}), true)
  end

  def new_years_eve(year) do
    create(:new_years_eve, Timex.to_date({year, 12, 31}), false)
  end


  def matching_filters2(calendar_day) do
    [
      :day_after_red_day_not_monday,
      :day_before_red_day_not_saturday,
      :red_day_not_sunday,
      :red_day,
      :friday_after_red_day,
      :monday_before_red_day,
      :day_before_red_day,
      :day_after_red_day,
      :sunday,
      :saturday,
      :friday,
      :thursday,
      :wednesday,
      :tuesday,
      :monday,
      :monday_to_thursday,
      :weekend,
      :weekday,
      :any_day
    ]
    |> Enum.each(fn(f) ->

    end)
  end

  def matching_filters(calendar_day) do
    matching = [FilterCriteria.any_day]

    if is_day_after_red_day_not_monday(calendar_day) do
      matching = [FilterCriteria.day_after_red_day_not_monday | matching]
    end

    if is_day_before_red_day_not_saturday(calendar_day) do
      matching = [FilterCriteria.day_before_red_day_not_saturday | matching]
    end

    if is_red_day_not_sunday(calendar_day) do
      matching = [FilterCriteria.red_day_not_sunday | matching]
    end

    if is_red_day(calendar_day) do
      matching = [FilterCriteria.red_day | matching]
    end

    if is_day_after_red_day(calendar_day) do
      matching = [FilterCriteria.day_after_red_day | matching]
    end

    if is_day_before_red_day(calendar_day) do
      matching = [FilterCriteria.day_before_red_day | matching]
    end

    if is_friday_after_red_day(calendar_day) do
      matching = [FilterCriteria.friday_after_red_day | matching]
    end

    if is_monday_before_red_day(calendar_day) do
      matching = [FilterCriteria.monday_before_red_day | matching]
    end

    if is_monday(calendar_day) do
      matching = [FilterCriteria.monday | matching]
    end

    if is_tuesday(calendar_day) do
      matching = [FilterCriteria.tuesday | matching]
    end

    if is_wednesday(calendar_day) do
      matching = [FilterCriteria.wednesday | matching]
    end

    if is_thursday(calendar_day) do
      matching = [FilterCriteria.thursday | matching]
    end

    if is_friday(calendar_day) do
      matching = [FilterCriteria.friday | matching]
    end

    if is_saturday(calendar_day) do
      matching = [FilterCriteria.saturday | matching]
    end

    if is_sunday(calendar_day) do
      matching = [FilterCriteria.sunday | matching]
    end

    if is_monday_to_thursday(calendar_day) do
      matching = [FilterCriteria.monday_to_thursday | matching]
    end

    if is_weekday(calendar_day) do
      matching = [FilterCriteria.weekday | matching]
    end

    if is_weekend(calendar_day) do
      matching = [FilterCriteria.weekend | matching]
    end

    matching
    |> Enum.sort
  end

  def to_string(calendar_day) do
    {:ok, formatted_date} =
      calendar_day.date
      |> Timex.format("%Y-%m-%d", :strftime)

    "#{formatted_date}, code: #{calendar_day.code}, red_day: #{calendar_day.red_day}"
  end

  defp is_monday(calendar_day) do
    Timex.weekday(calendar_day.date) == 1
  end

  defp is_tuesday(calendar_day) do
    Timex.weekday(calendar_day.date) == 2
  end

  defp is_wednesday(calendar_day) do
    Timex.weekday(calendar_day.date) == 3
  end

  defp is_thursday(calendar_day) do
    Timex.weekday(calendar_day.date) == 4
  end

  defp is_friday(calendar_day) do
    Timex.weekday(calendar_day.date) == 5
  end

  defp is_saturday(calendar_day) do
    Timex.weekday(calendar_day.date) == 6
  end

  defp is_sunday(calendar_day) do
    Timex.weekday(calendar_day.date) == 7
  end

  defp is_monday_before_red_day(calendar_day) do
    next_calendar_day(calendar_day).red_day &&
      Timex.weekday(calendar_day.date) == 1
  end

  defp is_friday_after_red_day(calendar_day) do
    previous_calendar_day(calendar_day).red_day &&
      Timex.weekday(calendar_day.date) == 5
  end

  defp is_day_after_red_day_not_monday(calendar_day) do
    previous_calendar_day(calendar_day).red_day &&
      Timex.weekday(calendar_day.date) != 1
  end

  defp is_day_before_red_day_not_saturday(calendar_day) do
    next_calendar_day(calendar_day).red_day &&
      Timex.weekday(calendar_day.date) != 6
  end

  defp is_day_before_red_day(calendar_day) do
    next_calendar_day(calendar_day).red_day
  end

  defp is_day_after_red_day(calendar_day) do
    previous_calendar_day(calendar_day).red_day
  end

  defp is_red_day(calendar_day) do
    calendar_day.red_day
  end

  defp is_red_day_not_sunday(calendar_day) do
    calendar_day.red_day
      && Timex.weekday(calendar_day.date) != 7
  end

  defp is_weekday(calendar_day) do
    weekday = Timex.weekday(calendar_day.date)
    weekday >= 1 && weekday <= 5
  end

  defp is_monday_to_thursday(calendar_day) do
    weekday = Timex.weekday(calendar_day.date)
    weekday >= 1 && weekday <= 4
  end

  defp is_weekend(calendar_day) do
    Timex.weekday(calendar_day.date) >= 6
  end

  defp previous_calendar_day(calendar_day) do
    CalendarDay.find(Timex.subtract(calendar_day.date, Timex.Duration.from_days(1)))
  end

  defp next_calendar_day(calendar_day) do
    CalendarDay.find(Timex.add(calendar_day.date, Timex.Duration.from_days(1)))
  end

  defp other(date) do
    {code, red_day} =
      case Timex.weekday(date) do
        2 ->
          {:tuesday, false}
        3 ->
          {:wednesday, false}
        4 ->
          {:thursday, false}
        5 ->
          {:friday, false}
        6 ->
          {:saturday, false}
        7 ->
          {:sunday, true}
        _ ->
          {:monday, false}
      end

    create(code, date, red_day)
  end

  defp create(code, date, red_day) do
    %CalendarDay{
      code: code,
      date: date,
      red_day: red_day
    }
  end
end

defmodule SwedishHolidays.CalendarDay do
  import SwedishHolidays
  import Timex

  alias Timex.Time
  alias Timex.Date
  alias Timex.DateFormat
  alias SwedishHolidays.CalendarDay

  defstruct code: nil, date: nil, red_day: nil

  def find(date) do
    day =
      all(date.year)
      |> Enum.filter(fn(d) -> d.date == date end)
      |> List.first

    cond do
      day == nil ->
        other(date)
      true ->
        day
    end
  end

  def find(from, to) do
    0..Date.diff(from, to, :days)
    |> Enum.map fn(n) ->
      find(Date.add(from, Time.to_timestamp(n, :days)))
    end
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
    create(:new_years_day, swedish_date(year, 1, 1), true)
  end

  def twelfth_day(year) do
    create(:twelfth_day, swedish_date(year, 1, 6), true)
  end

  def maundy_thursday(year) do
    date = good_friday(year).date
    |> Date.subtract(Time.to_timestamp(1, :days))

    create(:maundy_thursday, date, false)
  end

  def good_friday(year) do
    date = easter_day(year).date
    |> Date.subtract(Time.to_timestamp(2, :days))

    create(:good_friday, date, true)
  end

  def easter_eve(year) do
    date = easter_day(year).date
    |> Date.subtract(Time.to_timestamp(1, :days))

    create(:easter_eve, date, true)
  end

  def easter_day(year) do
    a = rem(year, 19)
    b = div(year, 100)
    c = rem(year, 100)
    d = div(b, 4)
    e = rem(b, 4)
    f = div(b + 8, 25)
    g = div(b - f + 1, 3)
    h = rem(19 * a + b - d - g + 15, 30)
    i = div(c, 4)
    k = rem(c, 4)
    l = rem(32 + 2 * e + 2 * i - h - k, 7)
    m = div((a + 11 * h + 22 * l), 451)
    x = h + l - 7 * m + 114
    month = div(x, 31)
    day = rem(x, 31) + 1

    create(:easter_day, swedish_date(year, month, day), true)
  end

  def easter_monday(year) do
    date = easter_day(year).date
    |> Date.add(Time.to_timestamp(1, :days))

    create(:easter_monday, date, true)
  end

  def first_of_may(year) do
    create(:first_of_may, swedish_date(year, 5, 1), true)
  end

  def ascension_day(year) do
    date = easter_day(year).date
    |> Date.add(Time.to_timestamp((5 * 7) + 4, :days))

    create(:ascension_day, date, true)
  end

  def whitsun_eve(year) do
    date = whitsun_day(year).date
    |> Date.subtract(Time.to_timestamp(1, :days))

    create(:whitsun_eve, date, false)
  end

  def whitsun_day(year) do
    date = easter_day(year).date
    |> Date.add(Time.to_timestamp(7 * 7, :days))

    create(:whitsun_day, date, true)
  end

  def whit_monday(year) do
    date = whitsun_day(year).date
    |> Date.add(Time.to_timestamp(1, :days))

    red_day = year <= 2004

    create(:whit_monday, date, red_day)
  end

  def national_day(year) do
    red_day = year >= 2005

    create(:national_day, swedish_date(year, 6, 6), red_day)
  end

  def midsummer_eve(year) do
    date = midsummer_day(year).date
    |> Date.subtract(Time.to_timestamp(1, :days))

    create(:midsummer_eve, date, false)
  end

  def midsummer_day(year) do
    date = swedish_date(year, 06, 20)

    date =
      date
      |> Date.add(Time.to_timestamp(6 - Date.weekday(date), :days))

    create(:midsummer_day, date, true)
  end

  def all_saints_day(year) do
    date = swedish_date(year, 10, 31)

    date =
      date
      |> Date.add(Time.to_timestamp(6 - Date.weekday(date), :days))

    create(:all_saints_day, date, true)
  end

  def christmas_eve(year) do
    create(:christmas_eve, swedish_date(year, 12, 24), false)
  end

  def christmas_day(year) do
    create(:christmas_day, swedish_date(year, 12, 25), true)
  end

  def boxing_day(year) do
    create(:boxing_day, swedish_date(year, 12, 26), true)
  end

  def new_years_eve(year) do
    create(:new_years_eve, swedish_date(year, 12, 31), false)
  end

  def matching_filters(calendar_day) do
    matching = [day_filters[:any_day]]

    if is_red_day_not_sunday(calendar_day) do
      matching = [day_filters[:red_day_not_sunday] | matching]
    end

    if is_red_day(calendar_day) do
      matching = [day_filters[:red_day] | matching]
    end

    if is_day_after_red_day(calendar_day) do
      matching = [day_filters[:day_after_red_day] | matching]
    end

    if is_day_before_red_day(calendar_day) do
      matching = [day_filters[:day_before_red_day] | matching]
    end

    if is_day_before_red_day(calendar_day) do
      matching = [day_filters[:day_before_red_day] | matching]
    end

    if is_friday_after_red_day(calendar_day) do
      matching = [day_filters[:friday_after_red_day] | matching]
    end

    if is_monday_before_red_day(calendar_day) do
      matching = [day_filters[:monday_before_red_day] | matching]
    end

    if is_monday(calendar_day) do
      matching = [day_filters[:monday] | matching]
    end

    if is_tuesday(calendar_day) do
      matching = [day_filters[:tuesday] | matching]
    end

    if is_wednesday(calendar_day) do
      matching = [day_filters[:wednesday] | matching]
    end

    if is_thursday(calendar_day) do
      matching = [day_filters[:thursday] | matching]
    end

    if is_friday(calendar_day) do
      matching = [day_filters[:friday] | matching]
    end

    if is_saturday(calendar_day) do
      matching = [day_filters[:saturday] | matching]
    end

    if is_sunday(calendar_day) do
      matching = [day_filters[:sunday] | matching]
    end

    if is_monday_to_thursday(calendar_day) do
      matching = [day_filters[:monday_to_thursday] | matching]
    end

    if is_weekday(calendar_day) do
      matching = [day_filters[:weekday] | matching]
    end

    if is_weekend(calendar_day) do
      matching = [day_filters[:weekend] | matching]
    end

    matching
    |> Enum.sort
  end

  def to_string(calendar_day) do
    {:ok, formatted_date} =
      calendar_day.date
      |> DateFormat.format("%Y-%m-%d", :strftime)

    "#{formatted_date}, code: #{calendar_day.code}, red_day: #{calendar_day.red_day}"
  end

  defp is_monday(calendar_day) do
    Date.weekday(calendar_day.date) == 1
  end

  defp is_tuesday(calendar_day) do
    Date.weekday(calendar_day.date) == 2
  end

  defp is_wednesday(calendar_day) do
    Date.weekday(calendar_day.date) == 3
  end

  defp is_thursday(calendar_day) do
    Date.weekday(calendar_day.date) == 4
  end

  defp is_friday(calendar_day) do
    Date.weekday(calendar_day.date) == 5
  end

  defp is_saturday(calendar_day) do
    Date.weekday(calendar_day.date) == 6
  end

  defp is_sunday(calendar_day) do
    Date.weekday(calendar_day.date) == 7
  end

  defp is_monday_before_red_day(calendar_day) do
    next_calendar_day(calendar_day).red_day &&
      Date.weekday(calendar_day.date) == 1
  end

  defp is_friday_after_red_day(calendar_day) do
    previous_calendar_day(calendar_day).red_day &&
      Date.weekday(calendar_day.date) == 5
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
      && Date.weekday(calendar_day.date) != 7
  end

  defp is_weekday(calendar_day) do
    weekday = Date.weekday(calendar_day.date)
    weekday >= 1 && weekday <= 5
  end

  defp is_monday_to_thursday(calendar_day) do
    weekday = Date.weekday(calendar_day.date)
    weekday >= 1 && weekday <= 4
  end

  defp is_weekend(calendar_day) do
    Date.weekday(calendar_day.date) >= 6
  end

  defp previous_calendar_day(calendar_day) do
    CalendarDay.find(Date.subtract(calendar_day.date, Time.to_timestamp(1, :days)))
  end

  defp next_calendar_day(calendar_day) do
    CalendarDay.find(Date.add(calendar_day.date, Time.to_timestamp(1, :days)))
  end

  defp other(date) do
    red_day = false

    case Date.weekday(date) do
      2 ->
        code = :tuesday
      3 ->
        code = :wednesday
      4 ->
        code = :thursday
      5 ->
        code = :friday
      6 ->
        code = :saturday
      7 ->
        code = :sunday
        red_day = true
      _ ->
        code = :monday
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

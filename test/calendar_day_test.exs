defmodule CalendarDayTest do
  use ExUnit.Case
  import SwedishHolidays
  alias SwedishHolidays.CalendarDay

  test "struct" do
    day = %CalendarDay{}

    assert day.code == nil
    assert day.date == nil
    assert day.red_day == nil
  end

  test "find whole year" do
    from = swedish_date(2015, 01, 01)
    to = swedish_date(2015, 12, 31)

    days = CalendarDay.find(from, to)

    assert Enum.count(days) == 365
  end

  test "find whole leap year" do
    from = swedish_date(2016, 01, 01)
    to = swedish_date(2016, 12, 31)

    days = CalendarDay.find(from, to)

    assert Enum.count(days) == 366
  end

  test "find range" do
    from = swedish_date(2015, 11, 30)
    to = swedish_date(2015, 12, 06)

    days = CalendarDay.find(from, to)

    assert Enum.count(days) == 7
  end

  test "find monday" do
    day = CalendarDay.find(swedish_date(2015, 12, 7))

    assert day.code == :monday
    assert day.date == swedish_date(2015, 12, 7)
    assert day.red_day == false
  end

  test "find tuesday" do
    day = CalendarDay.find(swedish_date(2015, 12, 8))

    assert day.code == :tuesday
    assert day.date == swedish_date(2015, 12, 8)
    assert day.red_day == false
  end

  test "find wednesday" do
    day = CalendarDay.find(swedish_date(2015, 12, 9))

    assert day.code == :wednesday
    assert day.date == swedish_date(2015, 12, 9)
    assert day.red_day == false
  end

  test "find thursday" do
    day = CalendarDay.find(swedish_date(2015, 12, 10))

    assert day.code == :thursday
    assert day.date == swedish_date(2015, 12, 10)
    assert day.red_day == false
  end

  test "find friday" do
    day = CalendarDay.find(swedish_date(2015, 12, 11))

    assert day.code == :friday
    assert day.date == swedish_date(2015, 12, 11)
    assert day.red_day == false
  end

  test "find saturday" do
    day = CalendarDay.find(swedish_date(2015, 12, 12))

    assert day.code == :saturday
    assert day.date == swedish_date(2015, 12, 12)
    assert day.red_day == false
  end

  test "find sunday" do
    day = CalendarDay.find(swedish_date(2015, 12, 13))

    assert day.code == :sunday
    assert day.date == swedish_date(2015, 12, 13)
    assert day.red_day == true
  end

  test "find among holidays" do
    day = CalendarDay.find(swedish_date(2015, 4, 4))

    assert day.code == :easter_eve
    assert day.date == swedish_date(2015, 4, 4)
    assert day.red_day == true
  end

  test "all" do
    days = CalendarDay.all(2015)

    assert Enum.count(days) == 20
  end

  test "new years day" do
    day = CalendarDay.new_years_day(2015)

    assert day.code == :new_years_day
    assert day.date == swedish_date(2015, 1, 1)
    assert day.red_day == true
  end

  test "twelfth day" do
    day = CalendarDay.twelfth_day(2015)

    assert day.code == :twelfth_day
    assert day.date == swedish_date(2015, 1, 6)
    assert day.red_day == true
  end

  test "maundy thursday" do
    day = CalendarDay.maundy_thursday(2015)

    assert day.code == :maundy_thursday
    assert day.date == swedish_date(2015, 4, 2)
    assert day.red_day == false
  end

  test "good friday" do
    day = CalendarDay.good_friday(2015)

    assert day.code == :good_friday
    assert day.date == swedish_date(2015, 4, 3)
    assert day.red_day == true
  end

  test "easter eve" do
    day = CalendarDay.easter_eve(2015)

    assert day.code == :easter_eve
    assert day.date == swedish_date(2015, 4, 4)
    assert day.red_day == true
  end

  test "easter day 2015" do
    day = CalendarDay.easter_day(2015)

    assert day.code == :easter_day
    assert day.date == swedish_date(2015, 4, 5)
    assert day.red_day == true
  end

  test "easter day 2025" do
    day = CalendarDay.easter_day(2025)

    assert day.code == :easter_day
    assert day.date == swedish_date(2025, 4, 20)
    assert day.red_day == true
  end

  test "easter day 2004" do
    day = CalendarDay.easter_day(2004)

    assert day.code == :easter_day
    assert day.date == swedish_date(2004, 4, 11)
    assert day.red_day == true
  end

  test "easter monday" do
    day = CalendarDay.easter_monday(2015)

    assert day.code == :easter_monday
    assert day.date == swedish_date(2015, 4, 6)
    assert day.red_day == true
  end

  test "first of may" do
    day = CalendarDay.first_of_may(2015)

    assert day.code == :first_of_may
    assert day.date == swedish_date(2015, 5, 1)
    assert day.red_day == true
  end

  test "ascension day" do
    day = CalendarDay.ascension_day(2015)

    assert day.code == :ascension_day
    assert day.date == swedish_date(2015, 5, 14)
    assert day.red_day == true
  end

  test "whitsun eve" do
    day = CalendarDay.whitsun_eve(2015)

    assert day.code == :whitsun_eve
    assert day.date == swedish_date(2015, 5, 23)
    assert day.red_day == false
  end

  test "whitsun day" do
    day = CalendarDay.whitsun_day(2015)

    assert day.code == :whitsun_day
    assert day.date == swedish_date(2015, 5, 24)
    assert day.red_day == true
  end

  test "whit monday 2015" do
    day = CalendarDay.whit_monday(2015)

    assert day.code == :whit_monday
    assert day.date == swedish_date(2015, 5, 25)
    assert day.red_day == false
  end

  test "whit monday 2004" do
    day = CalendarDay.whit_monday(2004)

    assert day.code == :whit_monday
    assert day.date == swedish_date(2004, 5, 31)
    assert day.red_day == true
  end

  test "national day 2015" do
    day = CalendarDay.national_day(2015)

    assert day.code == :national_day
    assert day.date == swedish_date(2015, 6, 6)
    assert day.red_day == true
  end

  test "national day 2004" do
    day = CalendarDay.national_day(2004)

    assert day.code == :national_day
    assert day.date == swedish_date(2004, 6, 6)
    assert day.red_day == false
  end

  test "midsummer eve" do
    day = CalendarDay.midsummer_eve(2015)

    assert day.code == :midsummer_eve
    assert day.date == swedish_date(2015, 6, 19)
    assert day.red_day == false
  end

  test "midsummer day 2015" do
    day = CalendarDay.midsummer_day(2015)

    assert day.code == :midsummer_day
    assert day.date == swedish_date(2015, 6, 20)
    assert day.red_day == true
  end

  test "midsummer day 2016" do
    day = CalendarDay.midsummer_day(2016)

    assert day.code == :midsummer_day
    assert day.date == swedish_date(2016, 6, 25)
    assert day.red_day == true
  end

  test "all saints day 2015" do
    day = CalendarDay.all_saints_day(2015)

    assert day.code == :all_saints_day
    assert day.date == swedish_date(2015, 10, 31)
    assert day.red_day == true
  end

  test "all saints day 2016" do
    day = CalendarDay.all_saints_day(2016)

    assert day.code == :all_saints_day
    assert day.date == swedish_date(2016, 11, 5)
    assert day.red_day == true
  end

  test "christmas eve" do
    day = CalendarDay.christmas_eve(2015)

    assert day.code == :christmas_eve
    assert day.date == swedish_date(2015, 12, 24)
    assert day.red_day == false
  end

  test "christmas day" do
    day = CalendarDay.christmas_day(2015)

    assert day.code == :christmas_day
    assert day.date == swedish_date(2015, 12, 25)
    assert day.red_day == true
  end

  test "boxing day" do
    day = CalendarDay.boxing_day(2015)

    assert day.code == :boxing_day
    assert day.date == swedish_date(2015, 12, 26)
    assert day.red_day == true
  end

  test "new years eve" do
    day = CalendarDay.new_years_eve(2015)

    assert day.code == :new_years_eve
    assert day.date == swedish_date(2015, 12, 31)
    assert day.red_day == false
  end

  test "matches on monday" do
    matching =
      swedish_date(2015, 12, 7)
      |> CalendarDay.find
      |> CalendarDay.matching_filters

    assert 0 in matching
    assert 200 in matching
    assert 300 in matching
    assert 1000 in matching
    assert 1100 in matching
  end

  test "matches on tuesday" do
    matching =
      swedish_date(2015, 12, 8)
      |> CalendarDay.find
      |> CalendarDay.matching_filters

    assert 0 in matching
    assert 200 in matching
    assert 300 in matching
    assert 900 in matching
  end

  test "matches on wednesday" do
    matching =
      swedish_date(2015, 12, 9)
      |> CalendarDay.find
      |> CalendarDay.matching_filters

    assert 0 in matching
    assert 200 in matching
    assert 300 in matching
    assert 800 in matching
  end

  test "matches on thursday" do
    matching =
      swedish_date(2015, 12, 10)
      |> CalendarDay.find
      |> CalendarDay.matching_filters

    assert 0 in matching
    assert 200 in matching
    assert 300 in matching
    assert 700 in matching
  end

  test "matches on friday" do
    matching =
      swedish_date(2015, 12, 11)
      |> CalendarDay.find
      |> CalendarDay.matching_filters

    assert 0 in matching
    assert 200 in matching
    assert 600 in matching
  end

  test "matches on saturday" do
    matching =
      swedish_date(2015, 12, 12)
      |> CalendarDay.find
      |> CalendarDay.matching_filters

    assert 0 in matching
    assert 100 in matching
    assert 500 in matching
    assert 1200 in matching
  end

  test "matches on sunday" do
    matching =
      swedish_date(2015, 12, 13)
      |> CalendarDay.find
      |> CalendarDay.matching_filters

    assert 0 in matching
    assert 100 in matching
    assert 400 in matching
    assert 1700 in matching
  end

  test "matches on good_friday" do
    matching =
      CalendarDay.good_friday(2015)
      |> CalendarDay.matching_filters

    assert 1800 in matching
    assert 1700 in matching
    assert 1200 in matching
    assert 600 in matching
    assert 200 in matching
    assert 0 in matching
  end

  test "friday after red day" do
    matching =
      swedish_date(2015, 01, 02)
      |> CalendarDay.find
      |> CalendarDay.matching_filters

    assert 1400 in matching
  end

  test "monday before red day" do
    matching =
      swedish_date(2017, 06, 05)
      |> CalendarDay.find
      |> CalendarDay.matching_filters

    assert 1300 in matching
  end

  test "day is matching filter" do
    day =
      swedish_date(2015, 12, 10)
      |> CalendarDay.find

    assert CalendarDay.matches?(day, day_filters[:thursday]) == true
  end

  test "day is not matching filter" do
    day =
      swedish_date(2015, 12, 10)
      |> CalendarDay.find

    assert CalendarDay.matches?(day, day_filters[:weekend]) == false
  end

  test "filter day range by any match" do
    from = swedish_date(2016, 01, 01)
    to = swedish_date(2016, 01, 31)

    days = CalendarDay.find(from, to)
    filters = [day_filters[:day_after_red_day], day_filters[:red_day_not_sunday]]
    matches = CalendarDay.match_any(days, filters)

    assert Enum.count(matches) == 8
  end

  test "filter day range by all filters" do
    from = swedish_date(2016, 01, 01)
    to = swedish_date(2016, 01, 31)

    days = CalendarDay.find(from, to)
    filters = [day_filters[:friday], day_filters[:red_day_not_sunday]]
    matches = CalendarDay.match_all(days, filters)

    assert Enum.count(matches) == 1
  end

end

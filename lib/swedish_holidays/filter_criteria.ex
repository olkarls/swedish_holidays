defmodule FilterCriteria do

  def day_after_red_day_not_monday do
    {:day_after_red_day_not_monday, 2000}
  end

  def day_before_red_day_not_saturday do
    {:day_before_red_day_not_saturday, 1900}
  end

  def red_day_not_sunday do
    {:red_day_not_sunday, 1800}
  end

  def red_day do
    {:red_day, 1700}
  end

  def friday_after_red_day do
    {:friday_after_red_day, 1400}
  end

  def monday_before_red_day do
    {:monday_before_red_day, 1300}
  end

  def day_before_red_day do
    {:day_before_red_day, 1200}
  end

  def day_after_red_day do
    {:day_after_red_day, 1100}
  end

  def sunday do
    {:sunday, 1000}
  end

  def saturday do
    {:saturday, 900}
  end

  def friday do
    {:friday, 800}
  end

  def thursday do
    {:thursday, 700}
  end

  def wednesday do
    {:wednesday, 600}
  end

  def tuesday do
    {:tuesday, 500}
  end

  def monday do
    {:monday, 400}
  end

  def monday_to_thursday do
    {:monday_to_thursday, 300}
  end

  def weekend do
    {:weekend, 200}
  end

  def weekday do
    {:weekday, 100}
  end

  def any_day do
    {:any_day, 0}
  end
end

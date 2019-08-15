class EquationsController < ApplicationController
  def home
  end

  def start
  end

  def new
    @equation = Equation.new(solution: generate_equation)
    @equation.save!
  end

  def score
    @sign = params[:sign]
    @equation = Equation.find(params[:equation])
    @equation.score = score_calculator(@sign, @equation)
    @equation.save!
  end

  private

  def generate_equation
    time = Time.now
    if time.sec <= 15
      return division
    elsif time.sec <= 30
      return multiplication
    elsif time.sec <= 45
      return substraction
    else
      return addition
    end
  end

  def division
    div_solution = rand(2..10)
    dividing = rand(1..10)
    divided = div_solution * dividing
    return "#{divided} : #{dividing} = #{div_solution}"
  end

  def multiplication
    multiplier1 = rand(1..10)
    multiplier2 = rand(1..10)
    mul_solution = multiplier1 * multiplier2
    return "#{multiplier1} * #{multiplier2} = #{mul_solution}"
  end

  def substraction
    substracted = rand(1..100)
    substractor = rand(1..substracted)
    sub_solution = substracted - substractor
    return "#{substracted} - #{substractor} = #{sub_solution}"
  end

  def addition
    adding1 = rand(1..100)
    adding2 = rand(1..100)
    add_solution = adding1 + adding2
    return "#{adding1} + #{adding2} = #{add_solution}"
  end

  def score_calculator(sign, equation)
    if sign == equation.solution[/[^\w\s]/]
      correct_points = 100
      deduction_time = Time.now - equation.created_at
      return correct_points - deduction_time.to_i
    else
      return 0
    end
  end
end

class EquationsController < ApplicationController
  def home
  end

  def start
  end

  def new
    @test = whole_equation
    @equation = Equation.new(solution: @test)
    @equation.save!
  end

  def score
    @signs = params
    @equation = Equation.find(params[:equation])
    @equation.score = score_calculator(@signs, @equation)
    @equation.save!
  end

  private

  def whole_equation
    operators = {1 => :+, 2 => :-, 3 => :*, 4 => ":"}
    randop = [1,2,3,4].shuffle
    i = 0
    num = [0, 0, 0, 0, 0]
    while i <= 4
      if randop[i] == 4
        division_array = division
        num[i + 1] = division_array[1]
        if randop[i - 1] == 4 && randop[i - 2] == 4 && randop[i - 3] == 4 && i - 3 >= 0
          num[i - 3] = num[i - 3] * division_array[0]
        elsif randop[i - 1] == 4 && randop[i - 2] == 4 && i - 2 >= 0
          num[i - 2] = num[i - 2] * division_array[0]
        elsif randop[i - 1] == 4 && i - 1 >= 0
          num[i - 1] = num[i - 1] * division_array[0]
        else
          num[i] = division_array[0]
        end
      elsif randop[i] == 3
        num[i] = rand(1..10) if (randop[i - 1] != 4 && i - 1 >= 0) || num[i] == 0
        num[i + 1] = rand(1..10) if randop[i + 1] != 4
      else
        num[i] = rand(1..100) if num[i] == 0
        num[i + 1] = rand(1..100) if num[i + 1] == 0
      end
      i += 1
    end

    # Background maths
    used = [nil, nil, nil, nil]
    d = 0
    while d <= 4
      if randop[d] == 4
        if used[d - 1].nil? || d == 0
          used[d] = num[d] / num[d + 1]
          solution = used[d]
        else
          used[d] = used[d - 1] / num[d + 1]
          used[d - 1] = used[d]
          solution = used[d]
        end
      elsif randop[d] == 3
        if used[d - 1].nil? || d == 0
          used[d] = num[d] * num[d + 1]
          solution = used[d]
        else
          used[d] = used[d - 1] * num[d + 1]
          used[d - 1] = used[d]
          solution = used[d]
        end
      end
      d += 1
    end

    a = 0
    while a <= 4
      if randop[a] == 1
        if (used[a - 1].nil? || a == 0) && used[a + 1].nil?
          used[a] = num[a] + num[a + 1]
          solution = used[a]
        elsif used[a - 1] != nil && used[a + 1].nil?
          used[a] = used[a - 1] + num[a + 1]
          used[a - 1] = used[a]
          solution = used[a]
        elsif (used[a - 1].nil? || a == 0) && used[a + 1] != nil
          used[a] = used[a + 1] + num[a]
          used[a + 1] = used[a]
          solution = used[a]
        else
          used[a] = used[a + 1] + used[a - 1]
          used[a + 1] = used[a]
          used[a - 1] = used[a]
          solution = used[a]
        end
      elsif randop[a] == 2
        if (used[a - 1].nil? || a == 0) && used[a + 1].nil?
          used[a] = num[a] - num[a + 1]
          solution = used[a]
        elsif used[a - 1] != nil && used[a + 1].nil?
          used[a] = used[a - 1] - num[a + 1]
          used[a - 1] = used[a]
          solution = used[a]
        elsif (used[a - 1].nil? || a == 0) && used[a + 1] != nil
          used[a] = num[a] - used[a + 1]
          used[a + 1] = used[a]
          solution = used[a]
        else
          used[a] = used[a - 1] - used[a + 1]
          used[a + 1] = used[a]
          used[a - 1] = used[a]
          solution = used[a]
        end
      end
      a += 1
    end
    if (randop[1] == 4 || randop[1] == 3) && (randop[2] == 4 || randop[2] == 3)
      solution = num[0] + used[3] if randop[0] == 1
      if randop[0] == 2 && randop[3] == 2
        solution = used[1] - num[4]
      elsif randop[0] == 2 && randop[3] == 1
        solution = used[1] + num[4]
      elsif randop[0] == 2
        solution = num [0] - used[3]
      end
    end

    return "#{num[0]} #{operators[randop[0]]} #{num[1]} #{operators[randop[1]]} #{num[2]} #{operators[randop[2]]} #{num[3]} #{operators[randop[3]]} #{num[4]} #{randop[4]} #{num[5]} =  #{solution}"
  end

  def short_equation
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
    return [divided, dividing]
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

  def score_calculator(signs, equation)
    op_arr = equation.solution.scan(/([^\w\s])/).flatten
    if op_arr[0] == signs[:op0] && op_arr[1] == signs[:op1] && op_arr[2] == signs[:op2] && op_arr[3] == signs[:op3]
      correct_points = 1000
      deduction_time = Time.now - equation.created_at
      return correct_points - deduction_time
    else
      return 0
    end
  end
end

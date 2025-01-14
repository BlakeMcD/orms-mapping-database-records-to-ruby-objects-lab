class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student

  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
      sql = <<-SQL
      SELECT * FROM Students
    SQL

    DB[:conn].execute(sql).map do |row|
      Student.new_from_db(row)
    end    
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
      sql = <<-SQL
      SELECT * FROM Students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      Student.new_from_db(row)
    end.first
  end

  #all students in grade9 method
  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM Students
      WHERE grade = 9
    SQL

    grade_nine = []

    DB[:conn].execute(sql).map do |row|
      grade_nine << row
    end

    grade_nine
  end

  #all students below grade12 method
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM Students
      WHERE grade < 12
    SQL

    # students_below_twelve = []

    DB[:conn].execute(sql).map do |row|
      # students_below_twelve << row
      self.new_from_db(row)
    end

    # students_below_twelve
  end

  # .first_X_students_in_grade_10
  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
      SELECT * FROM Students
      WHERE grade = 10
      LIMIT ?
    SQL

    DB[:conn].execute(sql, number).map do |row|
      self.new_from_db(row)
    end
  end

  # .first_student_in_grade_10
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM Students
      WHERE grade = 10
      LIMIT 1
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  # all students in Grade X
  def self.all_students_in_grade_X(grade_level)
    sql = <<-SQL
      SELECT * FROM Students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, grade_level).map do |row|
      self.new_from_db(row)
    end

  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end

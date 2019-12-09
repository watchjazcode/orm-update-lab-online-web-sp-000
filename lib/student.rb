require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade, :id

  #student = Student.new("Tiffany", "11th")

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS students")
  end

  def save
    if @id == nil
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    else
      update
    end
    return self
  end

    #Student.create(name: "Sally", grade: "10th")

  def self.create(attributes)
    Student.new(attributes[:name], attributes[:grade]).save
  end

  def self.new_from_db(row)
    Student.new(id: row[0], name: row[1], grade: row[2])
  end

  def self.find_by_name(name)
    student_data = DB[:conn].execute("SELECT * FROM students WHERE name = ? ", name)
    return self.new_from_db(student_data[0])
  end

  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", @name, @grade, @id)
  end

end

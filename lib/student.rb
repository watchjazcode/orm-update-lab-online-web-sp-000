require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :breed, :id

def initialize(name:, breed:, id: nil) #nil because if we don't provide id database will do it for us.
  @name = name
  @breed = breed
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
      DB[:conn].execute("INSERT INTO students (name, grade) VALUES (?, ?)", @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    return self
    end

    #Student.create(name: "Sally", grade: "10th")

    def self.create(attributes)
      Student.new(attributes[:name], attributes[:grade]).save
    end

  end


  def self.new_from_db(row)
    Dog.new(id: row[0], name: row[1], breed: row[2])
  end

  def self.find_by_name(name)
      dog_data = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? ", name)
      return self.new_from_db(dog_data[0])
    end

    def update
      DB[:conn].execute("UPDATE dogs SET name = ? WHERE id = ?", @name, @id) #coming from instance, so instance variables
    end


end

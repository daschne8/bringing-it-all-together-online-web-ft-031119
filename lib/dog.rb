class Dog
  attr_accessor :name,:breed,:id
  attr_reader

  def initialize(attributes)
    attributes.each{|key,value| self.send("#{key}=",value)}
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO dogs(name,breed)
      VALUES(?,?)
      SQL
      DB[:conn].execute(sql,self.name,self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end

  def update
    sql = <<-SQL
    UPDATE dogs
    SET name = ?, breed = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql,self.name,self.breed,self.id)
  end

  def self.create(attributes)
    dog = Dog.new(attributes)
    dog.save
    dog
  end

  def self.new_from_db(row)
    self.create(id:row[0], name:row[1], breed:row[2])
  end

  def self.find_by_id(id)
    sql = <<-SQL
    SELECT * FROM dogs WHERE id = ?
    SQL
    rs = DB[:conn].execute(sql,id)[0]
    Dog.new_from_db(rs)
  end

  def self.find_or_create_by(name:,breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?",name,breed)
    if !dog.empty?
      dog_data = dog[0]
      dog = self.new_from_db(dog_data)
    else
      dog = self.create(name: name, breed: breed)
    end
    dog
  end

  def self.find_by_name(name:)
    sql = <<-SQL
    SELECT * FROM dogs WHERE name = ?
    SQL
    rs = DB[:conn].execute(sql,id)[0]
    Dog.new_from_db(rs)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS dogs")
  end
end

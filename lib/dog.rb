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

  def new_from_db(row)
    self.create(id:row[0], name:row[1], breed:row[2])
  end

  def self.find_by_id(id)
    sql = <<-SQL
    SELECT * FROM dogs WHERE id = ?
    SQL
    self.create(DB[:conn].execute(sql,id))
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

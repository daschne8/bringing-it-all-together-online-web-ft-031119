class Dog
  attr_accessor :name,:breed,:id
  attr_reader

  def initialize(attributes)
    attributes.each{|key,value| self.send("#{key}=",value)}
  end

  def save

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

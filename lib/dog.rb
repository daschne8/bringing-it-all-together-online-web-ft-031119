class Dog
  attr_accessor :name,:breed
  attr_reader :id

  def initialize(id=nil,name,breed)
    @id,@name,@breed = id,name,breed
  end

  def save

  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs(

    )
    DB[:conn].execute("")
  end
end

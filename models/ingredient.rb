require_relative("../db/sql_runner")

class Ingredient

  attr_reader :id, :name, :plural_name

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @plural_name = options['plural_name']
  end

  def save()
    sql = "INSERT INTO ingredients
    (
      name, plural_name
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@name, @plural_name]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  # returns array of Recipe obj for this ingredient
  def recipes()
    sql = "SELECT rec.*
    FROM recipes rec
    INNER JOIN recipe_ingredients ing
    ON ing.recipe_id = rec.id
    WHERE ing.ingredient_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map { |recipe| Recipe.new(recipe) }
  end

  def self.all()
    sql = "SELECT * FROM ingredients"
    results = SqlRunner.run(sql)
    return results.map { |ingredient| Ingredient.new(ingredient) }
  end

  def self.find(id)
    sql = "SELECT * FROM ingredients
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    return Ingredient.new(results.first)
  end

  def self.delete_all
    sql = "DELETE FROM ingredients"
    SqlRunner.run( sql )
  end

end

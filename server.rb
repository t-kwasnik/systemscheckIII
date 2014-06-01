require 'sinatra'
require 'pg'

def get_recipe(id)
  connection = PG.connect(dbname: 'recipes')
  if id == nil
    result = connection.exec('SELECT id, name FROM recipes ORDER BY name;').to_a
  else
    result = connection.exec_params('SELECT id, name, instructions, description FROM recipes WHERE id = $1;', [id]).to_a
    ingredients = connection.exec_params('SELECT id, name FROM ingredients WHERE recipe_id = $1;', [id]).to_a
    result << ingredients
  end
end




get "/recipes" do
  @recipes = get_recipe(nil)
  erb :recipes
end

get "/recipes/:id" do
  @recipes = get_recipe(params[:id])
  erb :recipe
end

require 'sinatra'
require 'pg'

def get_recipe(id)
  connection = PG.connect(dbname: 'recipes')
  if id == nil
    result = connection.exec('SELECT id, name FROM recipes ORDER BY name;').to_a
  else
    result = connection.exec_params('SELECT id, name, instructions, description FROM recipes WHERE id = $1;', [id]).to_a
  end
end



get "/recipes" do
  @recipes = get_recipe(nil)
  erb :recipes
end

get "/recipes/:id" do
  @recipes = get_recipe(params[:id])
  @ingredients = get_ingredients(params[:id])
  erb :recipe
end

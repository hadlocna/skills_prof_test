get '/' do
  # render home page
  @users = User.all

  erb :index
end

#----------- SESSIONS -----------
get '/profile/new' do
  skills = Skill.all

  params.each do |input|
    p "-----this is the params=-----"
    p input[0]
    p input[1]
    Proficiency.create(user_id: session[:id], skill_id: input[0].to_i)

  end

  erb :index
end

get '/sessions/new' do
  # render sign-in page
  @email = nil
  erb :sign_in
end

post '/sessions' do
  # sign-in
  @email = params[:email]
  user = User.authenticate(@email, params[:password])
  if user
    # successfully authenticated; set up session and redirect
    session[:user_id] = user.id
    redirect '/'
  else
    # an error occurred, re-render the sign-in form, displaying an error
    @error = "Invalid email or password."
    erb :sign_in
  end
end

delete '/sessions/:id' do
  # sign-out -- invoked via AJAX
  return 401 unless params[:id].to_i == session[:user_id].to_i
  session.clear
  200
end


#----------- USERS -----------

get '/users/new' do
  # render sign-up page
  @user = User.new
  erb :sign_up
end


get '/profile/:id' do
  @user_id = params[:id]
  erb :profile
end


post '/users' do
  # sign-up
  @user = User.new params[:user]
  if @user.save
    # successfully created new account; set up the session and redirect
    session[:user_id] = @user.id
    redirect '/'
  else
    # an error occurred, re-render the sign-up form, displaying errors
    erb :sign_up
  end
end

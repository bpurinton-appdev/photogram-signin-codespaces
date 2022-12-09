class UsersController < ApplicationController
  def new_registration_form
    render({ :template => "users/signup_form" })
  end

  def sign_out
    reset_session
    redirect_to("/", notice: "See ya later!")
  end

  def sign_in
    render({ :template => "users/signin_form" })
  end

  def authenticate
    the_user = params.fetch("input_username")
    the_password = params.fetch("input_password")

    lookup_user = User.where(username: the_user).at(0)

    if lookup_user == nil
      redirect_to("/user_sign_in", alert: "No one by that name 'round these parts")
    else
      if lookup_user.authenticate(the_password)
        session.store(:user_id, lookup_user.id)
        redirect_to("/", notice: "Welcome back #{lookup_user.username}!")
      else
        redirect_to("/user_sign_in", alert: "Password incorrect")
      end
    end
  end

  def index
    @users = User.all.order({ :username => :asc })

    render({ :template => "users/index.html" })
  end

  def show
    the_username = params.fetch("the_username")
    @user = User.where({ :username => the_username }).at(0)

    render({ :template => "users/show.html.erb" })
  end

  def create
    user = User.new

    user.username = params.fetch("input_username")
    user.password = params.fetch("input_password")
    user.password_confirmation = params.fetch("input_password_confirmation")

    save_status = user.save

    if save_status == true
      session.store(:user_id, user.id)
      redirect_to("/users/#{user.username}", { notice: "Welcome " + user.username + "!" })
    else
      redirect_to("/user_sign_up", alert: user.errors.full_messages.to_sentence)
    end
  end

  def update
    the_id = params.fetch("the_user_id")
    user = User.where({ :id => the_id }).at(0)

    user.username = params.fetch("input_username")

    user.save

    redirect_to("/users/#{user.username}")
  end

  def destroy
    username = params.fetch("the_username")
    user = User.where({ :username => username }).at(0)

    user.destroy

    redirect_to("/users")
  end
end

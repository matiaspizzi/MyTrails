class UsersController < ApplicationController
  def account
    @user = current_user
    @leaders = @user.leaders
    @employees = @user.employees
  end

  def show_all
    authorize current_user, :show_all?, policy_class: UserPolicy
    @users_group_by_role = User.all.order(:name).group_by(&:role)
    @admins = @users_group_by_role["admin"] || []
    @employees = @users_group_by_role["employee"] || []
    @leaders = @users_group_by_role["leader"] || []
    render "admin/users_roles"
  end

  def set_user_role
    @user = User.find(params[:id])
    authorize @user, :set_role?, policy_class: UserPolicy
    @user.update(role: params[:user][:role])
    redirect_to users_roles_path
  end

  def update_profile_image
    @user = current_user
    authorize @user, :update_profile_image?, policy_class: UserPolicy

    unless params[:user][:profile_image].present?
      flash[:alert] = "No image selected."
      render :account and return
    end

    file = params[:user][:profile_image]

    if file.size > 1.megabyte
      flash[:alert] = "The image is too large. The maximum size is 1MB."
      render :account and return
    end

    base64_image = Base64.strict_encode64(file.read)
    mime_type = file.content_type

    if @user.update(profile_image: "data:#{mime_type};base64,#{base64_image}")
      redirect_to account_path, notice: "Profile image updated successfully."
    else
      flash[:alert] = @user.errors[:profile_image].first
      render :account
    end
  end

  def delete_profile_image
    @user = current_user
    authorize @user, :delete_profile_image?, policy_class: UserPolicy
    @user.update!(profile_image: nil)
    redirect_to account_path, notice: "Profile image deleted successfully."
  end
end

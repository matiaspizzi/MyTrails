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
      flash[:alert] = t("users.profile_image.no_image")
      render :account and return
    end

    @user.profile_image.attach(params[:user][:profile_image])

    if @user.valid?
      redirect_to account_path, notice: t("users.profile_image.updated")
    else
      flash[:alert] = @user.errors[:profile_image].first
      render :account
    end
  end

  def delete_profile_image
    @user = current_user
    authorize @user, :delete_profile_image?, policy_class: UserPolicy
    @user.profile_image.purge
    redirect_to account_path, notice: t("users.profile_image.deleted")
  end
end

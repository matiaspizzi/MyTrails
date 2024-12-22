class UsersController < ApplicationController

  def account
    @user = current_user
    @leaders = @user.leaders || []
  end

  def update_profile_image
    @user = current_user

    if params[:user][:profile_image].present?
      file = params[:user][:profile_image]

      size_in_bytes = file.size
      max_size_in_bytes = 1.megabytes

      if size_in_bytes > max_size_in_bytes
        flash[:alert] = "The image is too large. The maximum size is 1MB."
        render :account and return
      end

      base64_image = Base64.strict_encode64(file.read)
      mime_type = file.content_type

      if @user.update(profile_image: "data:#{mime_type};base64,#{base64_image}")
        flash[:notice] = "Profile image updated successfully."
        redirect_to account_path
      else
        flash[:alert] = @user.errors[:profile_image].first
        render :account
      end
    else
      flash[:alert] = "No image selected."
      render :account
    end
  end

  def delete_profile_image
    @user = current_user
    @user.update(profile_image: nil)
    flash[:notice] = "Profile image deleted successfully."
    redirect_to account_path
  end

  private

  def set_user
    @user = User.find(params[:id] || current_user.id)
  end

  def user_params
    params.require(:user).permit(:profile_image)
  end
end
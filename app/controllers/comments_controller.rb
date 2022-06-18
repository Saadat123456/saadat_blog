require_relative './modules/form_error_handler'

class CommentsController < ApplicationController
  include FormErrorHandler

  def comment
    new_comment = Comment.new(comment_params)
    errors = []
    errors << 'Empty Comment Not Allowed' if params[:comment][:text] == ''
    found_errors = validate_form(errors)

    unless found_errors
      new_comment.author = current_user
      new_comment.post = Post.find(params[:id])

      if new_comment.save
        new_comment.post.increment!(:comment_counter)
        flash[:success] = ['Comment Added Successfully']
        redirect_to user_post_path(user_id: params[:user_id], id: params[:id])
        return
      end
    end
    redirect_to user_post_path(user_id: params[:user_id], id: params[:id])
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end
end

module Api
  module V1
    class PostsController < Api::V1::ApiController
      before_action :doorkeeper_authorize!, except: :index

      def index
        question = Question.find_by_slug(params['question-slug'])
        posts = question.posts.order(created_at: :desc)
        render json: posts, each_serializer: PostSerializer, meta: {}
      end

      def create
        post = Post.new(post_params)
        post.question = Question.find_by_slug(params['data']['attributes']['question-slug'])

        if post.save
          render json: post, status: :created
        else
          render json: post,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      private

      def post_params
        params.require(:data).require(:attributes).permit(:description)
      end
    end
  end
end

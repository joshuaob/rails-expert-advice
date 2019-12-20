module Api
  module V1
    class QuestionsController < Api::V1::ApiController
      before_action :doorkeeper_authorize!, except: :index

      def index
        questions = if params['title']
                      filter_by_title(params['title'])
                    elsif params['tag']
                      filter_by_tag(params['tag'])
                    else
                      Question.order(created_at: :desc).paginate(page: params[:page], per_page: params[:perPage])
                    end

        render json: questions, each_serializer: QuestionSerializer, meta: {}
      end

      def show
        question = Question.find_by_slug(params[:id])
        render json: question
      end

      def create
        question = Question.new(question_params)
        question.user = current_user

        if question.save
          render json: question, status: :created
        else
          render json: question,
                 status: :unprocessable_entity,
                 serializer: ActiveModel::Serializer::ErrorSerializer
        end
      end

      def update
        question = Question.find_by_slug(params['data']['attributes']['slug'])

        if question.user != current_user
          render json: {}, status: :unauthorized
        else
          question.assign_attributes(question_params)
          question.save
          render json: question
        end
      end

      def destroy
        question = Question.find(params[:id])

        if question.user != current_user
          render json: {}, status: :unauthorized
        else
          question.destroy
          render json: {}, status: :ok
        end
      end

      private

      def question_params
        params.require(:data).require(:attributes).permit(:description, :title, :tags)
      end

      def filter_by_title(title)
        Question.where('questions.title ILIKE ?', "%#{title.parameterize}%").paginate(page: params[:page], per_page: params[:perPage])
      end

      def filter_by_tag(tag)
        Question.where('questions.tags ILIKE ?', "%#{tag.parameterize}%").paginate(page: params[:page], per_page: params[:perPage])
      end
    end
  end
end

# 15.times {
#   question = Question.new
#   question.title = Faker::Lorem.question
#   question.description = Faker::Lorem.paragraph(sentence_count: (3..7).to_a.sample)
#   question.tags = Faker::Lorem.words.join(",")
#   question.user = User.last
#   question.save
# }
